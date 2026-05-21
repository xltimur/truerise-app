import 'dart:convert';

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/data/api/dto/rectification_request_dto.dart';
import 'package:rectify/data/api/dto/rectification_response_dto.dart';
import 'package:rectify/data/api/mappers.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/data/models/time_window.dart';

import '../fixtures/sample_calculation.dart';

void main() {
  group('requestToDto (astrology-api.io v3)', () {
    test('maps birth_data fields correctly', () {
      final dto = requestToDto(sampleRequest());
      final bd = dto.subject.birthData;

      expect(bd.year, 1990);
      expect(bd.month, 5);
      expect(bd.day, 14);
      expect(bd.latitude, closeTo(50.4501, 1e-4));
      expect(bd.longitude, closeTo(30.5234, 1e-4));
      expect(bd.city, 'Kyiv, Ukraine');
    });

    test('birth_data anchor takes hour/minute from approximate time', () {
      // sampleRequest uses approximate time 07:14, ±60min. The provider
      // treats subject.birth_data.hour:minute as the center of the
      // delta search window — sending 00:00 would silently re-anchor
      // the search to midnight.
      final dto = requestToDto(sampleRequest());
      final bd = dto.subject.birthData;
      expect(bd.hour, 7);
      expect(bd.minute, 14);
    });

    test('unknown mode defaults the anchor to midday', () {
      final req = sampleRequest().copyWith(timeWindow: TimeWindow.unknown());
      final bd = requestToDto(req).subject.birthData;
      // 12:00 is benign: the search ignores the anchor when start/end
      // are supplied, and 12:00 reads as "no specific guess" to a
      // human reading the raw JSON.
      expect(bd.hour, 12);
      expect(bd.minute, 0);
    });

    test('approximate mode → delta_minutes + step_minutes', () {
      final dto = requestToDto(sampleRequest());
      final ts = dto.timeSearch;

      expect(ts.deltaMinutes, 60);
      expect(ts.stepMinutes, 4);
      expect(ts.start, isNull);
      expect(ts.end, isNull);
    });

    test('unknown mode → start/end full-day window', () {
      final req = sampleRequest().copyWith(
        timeWindow: TimeWindow.unknown(),
      );
      final ts = requestToDto(req).timeSearch;

      expect(ts.start, '00:00');
      expect(ts.end, '23:59');
      expect(ts.stepMinutes, 4);
      expect(ts.deltaMinutes, isNull);
    });

    test('step keeps candidate counts under the provider 500-cap', () {
      // astrology-api.io v3 rejects any search resolving to > 500
      // candidate times. Unknown / 24h mode is the widest window the
      // app can build; a 2-minute grid blew past the cap (~719) and
      // the provider failed the request.
      final unknown = requestToDto(
        sampleRequest().copyWith(timeWindow: TimeWindow.unknown()),
      ).timeSearch;
      const dayMinutes = 24 * 60;
      expect(
        dayMinutes / unknown.stepMinutes!,
        lessThan(500),
        reason: '24h search must resolve to well under 500 candidates',
      );

      // Widest approximate window: ±360 minutes (a 720-minute span).
      final widest = requestToDto(
        sampleRequest().copyWith(
          timeWindow: TimeWindow.approximate(
            time: const TimeOfDay(hour: 12, minute: 0),
            windowMinutes: 360,
          ),
        ),
      ).timeSearch;
      expect(
        (2 * widest.deltaMinutes!) / widest.stepMinutes!,
        lessThan(500),
        reason: 'widest approximate window must stay under 500 candidates',
      );
    });

    test('event with month → YYYY-MM date + precision=month', () {
      final dto = requestToDto(sampleRequest());
      final evt = dto.events.first; // marriage, year=2014, month=6

      expect(evt.date, '2014-06');
      expect(evt.datePrecision, 'month');
      expect(evt.category, 'marriage');
    });

    test('event without month → YYYY date + precision=year', () {
      // The relocation event in the sample request has no month.
      final dto = requestToDto(sampleRequest());
      final relocation = dto.events.firstWhere((e) => e.category == 'move');

      expect(relocation.date, '2021');
      expect(relocation.datePrecision, 'year');
    });

    test('all 5 sample events are included in order', () {
      final dto = requestToDto(sampleRequest());
      expect(dto.events, hasLength(5));
      expect(dto.events.first.category, 'marriage');
    });

    test('event payload never serializes the domain LifeEvent.id', () {
      // The provider's EventInput schema has no `id` field — events are
      // correlated to scores via array index (`event_index`). Sending
      // an extra `id` field risks 422 on strict deserialization.
      final dto = requestToDto(sampleRequest());
      final json = jsonEncode(dto.toJson());
      expect(json.contains('"id"'), isFalse);
      for (final entry in dto.events) {
        final eventJson = entry.toJson();
        expect(eventJson.containsKey('id'), isFalse);
      }
    });

    test('request JSON round-trips through fromJson without losing fields', () {
      final dto = requestToDto(sampleRequest());
      final json = jsonEncode(dto.toJson());
      final decoded = RectificationSearchRequestDto.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
      expect(decoded, dto);
    });

    test('request JSON uses snake_case keys for provider', () {
      final dto = requestToDto(sampleRequest());
      final json = dto.toJson();

      expect(json.containsKey('subject'), isTrue);
      expect(
        (json['subject'] as Map<String, dynamic>).containsKey('birth_data'),
        isTrue,
      );
      expect(json.containsKey('time_search'), isTrue);
      expect(json.containsKey('events'), isTrue);
    });

    test('Authorization header is not part of the DTO payload', () {
      // Confirms that the Bearer token is not embedded in the request body.
      final dto = requestToDto(sampleRequest());
      final json = jsonEncode(dto.toJson());
      expect(json.toLowerCase().contains('authorization'), isFalse);
      expect(json.toLowerCase().contains('bearer'), isFalse);
    });
  });

  group('responseToResult (v3)', () {
    const responseDto = RectificationSearchResponseDto(
      candidates: <CandidateV3Dto>[
        CandidateV3Dto(
          rank: 1,
          time: '07:14',
          aggregateScore: 18.4,
          normalizedScore: 78,
          grade: 'good',
          eventScores: <EventScoreDto>[
            EventScoreDto(
              eventIndex: 0,
              eventDate: '2014-06',
              eventCategory: 'marriage',
              totalScore: 9,
              interpretation: 'Venus return aligned.',
            ),
            EventScoreDto(
              eventIndex: 1,
              eventDate: '2019-09',
              eventCategory: 'career_change',
              totalScore: 1.5,
              interpretation: 'Mercury wide orb.',
            ),
          ],
        ),
        CandidateV3Dto(
          rank: 2,
          time: '07:42',
          normalizedScore: 61,
        ),
      ],
      summary: SummaryV3Dto(
        confidence: ConfidenceAssessmentDto(
          level: 'medium',
          explanation: 'top-2 separated',
          gapRatio: 0.18,
          liftRatio: 1.21,
        ),
        peakTime: '07:14',
        techniquesUsed: <String>['transit', 'progression'],
      ),
      computedAt: '2026-05-20T12:00:00Z',
    );

    test('converts the inbound DTO into a domain CalculationResult', () {
      final completedAt = DateTime.utc(2026, 5, 20, 12);
      final result = responseToResult(
        requestId: 'req-001',
        dto: responseDto,
        completedAt: completedAt,
        rawResponseJson: '{"raw":true}',
        requestEvents: sampleRequest().events,
      );

      expect(result.requestId, 'req-001');
      // v3 has no calculation_id in the response.
      expect(result.apiCalculationId, isNull);
      expect(result.method, 'transit+progression');
      expect(result.candidates, hasLength(2));
      // normalized_score (0..100) → confidence (0..1)
      expect(result.candidates.first.confidence, closeTo(0.78, 1e-9));
      expect(
        result.candidates.first.time,
        const TimeOfDay(hour: 7, minute: 14),
      );
      expect(result.candidates.last.confidence, closeTo(0.61, 1e-9));
      expect(result.evidence, hasLength(2));
      // event_index 0 → request.events[0].id == 'evt-1'
      expect(result.evidence.first.eventId, 'evt-1');
      expect(result.evidence.last.eventId, 'evt-2');
      expect(result.isDemo, isFalse);
      expect(result.completedAt, completedAt);
      expect(result.rawResponseJson, '{"raw":true}');
    });

    test('strength buckets fall out of total_score against local max', () {
      // The bucket boundaries match the mapper's heuristic:
      //   ratio ≥ 0.7 → strong, ≥ 0.4 → moderate, > 0 → weak, 0 → none.
      const dto = RectificationSearchResponseDto(
        candidates: <CandidateV3Dto>[
          CandidateV3Dto(
            rank: 1,
            time: '08:00',
            normalizedScore: 80,
            eventScores: <EventScoreDto>[
              EventScoreDto(
                eventIndex: 0,
                eventDate: '2014',
                eventCategory: 'marriage',
                totalScore: 10,
              ),
              EventScoreDto(
                eventIndex: 1,
                eventDate: '2019',
                eventCategory: 'career_change',
                totalScore: 5,
              ),
              EventScoreDto(
                eventIndex: 2,
                eventDate: '2021',
                eventCategory: 'move',
                totalScore: 1,
              ),
              EventScoreDto(
                eventIndex: 3,
                eventDate: '2009',
                eventCategory: 'education',
              ),
            ],
          ),
        ],
      );
      final result = responseToResult(
        requestId: 'r',
        dto: dto,
        completedAt: DateTime.utc(2026, 5, 20),
        requestEvents: sampleRequest().events,
      );
      expect(result.evidence[0].matchStrength, MatchStrength.strong);
      expect(result.evidence[1].matchStrength, MatchStrength.moderate);
      expect(result.evidence[2].matchStrength, MatchStrength.weak);
      expect(result.evidence[3].matchStrength, MatchStrength.none);
    });

    test('fallback explanation is built when interpretation is absent', () {
      const dto = RectificationSearchResponseDto(
        candidates: <CandidateV3Dto>[
          CandidateV3Dto(
            rank: 1,
            time: '08:00',
            normalizedScore: 50,
            eventScores: <EventScoreDto>[
              EventScoreDto(
                eventIndex: 0,
                eventDate: '2014-06',
                eventCategory: 'marriage',
                totalScore: 7,
              ),
            ],
          ),
        ],
      );
      final result = responseToResult(
        requestId: 'r',
        dto: dto,
        completedAt: DateTime.utc(2026, 5, 20),
        requestEvents: sampleRequest().events,
      );
      expect(
        result.evidence.single.explanation,
        contains('marriage event on 2014-06'),
      );
    });

    test('HH:MM:SS time parses hours and minutes correctly', () {
      const dto = RectificationSearchResponseDto(
        candidates: [
          CandidateV3Dto(rank: 1, time: '07:14:32', normalizedScore: 50),
        ],
      );
      final result = responseToResult(
        requestId: 'r',
        dto: dto,
        completedAt: DateTime.utc(2026, 5, 20),
      );
      expect(
        result.candidates.single.time,
        const TimeOfDay(hour: 7, minute: 14),
      );
    });

    test('missing summary leaves method null', () {
      const dto = RectificationSearchResponseDto(
        candidates: [],
      );
      final result = responseToResult(
        requestId: 'r',
        dto: dto,
        completedAt: DateTime.utc(2026, 5, 20),
      );
      expect(result.apiCalculationId, isNull);
      expect(result.method, isNull);
      expect(result.evidence, isEmpty);
    });

    test('event_index out of range falls back to synthesized id', () {
      const dto = RectificationSearchResponseDto(
        candidates: <CandidateV3Dto>[
          CandidateV3Dto(
            rank: 1,
            time: '08:00',
            normalizedScore: 50,
            eventScores: <EventScoreDto>[
              EventScoreDto(
                eventIndex: 99,
                eventDate: '2020',
                eventCategory: 'other',
                totalScore: 5,
              ),
            ],
          ),
        ],
      );
      final result = responseToResult(
        requestId: 'r',
        dto: dto,
        completedAt: DateTime.utc(2026, 5, 20),
        requestEvents: sampleRequest().events,
      );
      expect(result.evidence.single.eventId, 'event_99');
    });

    test('ascendant is pulled from chart.planetary_positions', () {
      const dto = RectificationSearchResponseDto(
        candidates: <CandidateV3Dto>[
          CandidateV3Dto(
            rank: 1,
            time: '07:14',
            normalizedScore: 80,
            chart: <String, dynamic>{
              'planetary_positions': <Map<String, dynamic>>[
                <String, dynamic>{'name': 'Sun', 'sign': 'Tau'},
                <String, dynamic>{'name': 'Ascendant', 'sign': 'Gem'},
              ],
            },
          ),
        ],
      );
      final result = responseToResult(
        requestId: 'r',
        dto: dto,
        completedAt: DateTime.utc(2026, 5, 20),
      );
      expect(result.candidates.single.ascendant, 'Gemini');
    });

    test('ascendant falls back to house_cusps when ASC body is absent', () {
      const dto = RectificationSearchResponseDto(
        candidates: <CandidateV3Dto>[
          CandidateV3Dto(
            rank: 1,
            time: '07:14',
            normalizedScore: 80,
            chart: <String, dynamic>{
              'planetary_positions': <Map<String, dynamic>>[
                <String, dynamic>{'name': 'Sun', 'sign': 'Tau'},
              ],
              'house_cusps': <Map<String, dynamic>>[
                <String, dynamic>{'house': 1, 'sign': 'Lib', 'degree': 12.0},
              ],
            },
          ),
        ],
      );
      final result = responseToResult(
        requestId: 'r',
        dto: dto,
        completedAt: DateTime.utc(2026, 5, 20),
      );
      expect(result.candidates.single.ascendant, 'Libra');
    });

    test('response JSON round-trips through fromJson', () {
      const dto = responseDto;
      final json = jsonEncode(dto.toJson());
      final decoded = RectificationSearchResponseDto.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
      expect(decoded, dto);
    });

    test('excluded rank-1 candidate is skipped when picking evidence', () {
      // Excluded candidates are kept in the result list but their
      // event_scores are not surfaced as domain evidence (the user
      // wanted the best non-excluded fit).
      const dto = RectificationSearchResponseDto(
        candidates: <CandidateV3Dto>[
          CandidateV3Dto(
            rank: 1,
            time: '07:14',
            normalizedScore: 80,
            excluded: true,
            eventScores: <EventScoreDto>[
              EventScoreDto(
                eventIndex: 0,
                eventDate: '2014-06',
                eventCategory: 'marriage',
                totalScore: 99,
              ),
            ],
          ),
          CandidateV3Dto(
            rank: 2,
            time: '07:42',
            normalizedScore: 60,
            eventScores: <EventScoreDto>[
              EventScoreDto(
                eventIndex: 0,
                eventDate: '2014-06',
                eventCategory: 'marriage',
                totalScore: 5,
              ),
            ],
          ),
        ],
      );
      final result = responseToResult(
        requestId: 'r',
        dto: dto,
        completedAt: DateTime.utc(2026, 5, 20),
        requestEvents: const <LifeEvent>[
          LifeEvent(
            id: 'first',
            category: EventCategory.marriage,
            year: 2014,
            month: 6,
            sortOrder: 0,
          ),
        ],
      );
      // Rank-2 candidate's score (5) becomes the evidence, not the
      // excluded rank-1's score (99).
      expect(result.evidence.single.eventId, 'first');
      expect(result.evidence.single.matchStrength, MatchStrength.strong);
    });
  });

  // -------------------------------------------------------------------------
  // Category mapping: verified against astrology-api.io v3 OpenAPI 2026-05-20
  // -------------------------------------------------------------------------

  group('EventCategory → provider string (official enum)', () {
    LifeEvent makeEvent(EventCategory cat) => LifeEvent(
      id: 'test',
      category: cat,
      year: 2020,
      sortOrder: 0,
    );

    test('relocation maps to move', () {
      final dto = requestToDto(sampleRequest());
      final evt = dto.events.firstWhere((e) => e.category == 'move');
      expect(evt.date, '2021');
    });

    test('financial maps to financial_gain', () {
      final cat = lifeEventToDto(makeEvent(EventCategory.financial)).category;
      expect(cat, 'financial_gain');
    });

    test('familyDeath maps to death_family', () {
      final cat = lifeEventToDto(makeEvent(EventCategory.familyDeath)).category;
      expect(cat, 'death_family');
    });

    test('illness maps to health_diagnosis', () {
      final cat = lifeEventToDto(makeEvent(EventCategory.illness)).category;
      expect(cat, 'health_diagnosis');
    });
  });
}
