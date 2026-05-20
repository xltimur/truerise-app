import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/data/api/dto/rectification_request_dto.dart';
import 'package:rectify/data/api/dto/rectification_response_dto.dart';
import 'package:rectify/data/api/mappers.dart';
import 'package:rectify/data/models/match_strength.dart';

import '../fixtures/sample_calculation.dart';

void main() {
  group('requestToDto', () {
    test('maps a domain CalculationRequest to the wire format', () {
      final request = sampleRequest();
      final dto = requestToDto(request);

      expect(dto.requestId, request.id);
      expect(dto.birthDate, '1990-05-14');
      expect(dto.birthPlace.city, 'Kyiv, Ukraine');
      expect(dto.birthPlace.latitude, closeTo(50.4501, 1e-4));
      expect(dto.birthPlace.longitude, closeTo(30.5234, 1e-4));
      expect(dto.timeWindow.mode, 'approximate');
      expect(dto.timeWindow.approximateTime, '07:14');
      expect(dto.timeWindow.windowMinutes, 60);
      expect(dto.lifeEvents, hasLength(5));
      expect(dto.lifeEvents.first.id, 'evt-1');
      expect(dto.lifeEvents.first.category, 'marriage');
    });

    test('round-trips through JSON without losing fields', () {
      final request = sampleRequest();
      final dto = requestToDto(request);

      final json = jsonEncode(dto.toJson());
      final decoded = RectificationRequestDto.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );

      expect(decoded, dto);
    });
  });

  group('responseToResult', () {
    const responseDto = RectificationResponseDto(
      calculationId: 'calc-9',
      method: 'western_transit',
      candidates: <RectificationCandidateDto>[
        RectificationCandidateDto(
          rank: 1,
          time: '07:14',
          confidence: 0.78,
          ascendant: 'Gemini',
        ),
        RectificationCandidateDto(rank: 2, time: '07:42', confidence: 0.61),
      ],
      evidence: <RectificationEventMatchDto>[
        RectificationEventMatchDto(
          eventId: 'evt-1',
          matchStrength: 'strong',
          explanation: 'Venus return aligned.',
        ),
        RectificationEventMatchDto(
          eventId: 'evt-2',
          matchStrength: 'weak',
          explanation: 'Mercury wide orb.',
        ),
      ],
    );

    test('converts the inbound DTO into a domain CalculationResult', () {
      final completedAt = DateTime.utc(2026, 5, 20, 12);
      final result = responseToResult(
        requestId: 'req-001',
        dto: responseDto,
        completedAt: completedAt,
        rawResponseJson: '{"raw":true}',
      );

      expect(result.requestId, 'req-001');
      expect(result.apiCalculationId, 'calc-9');
      expect(result.method, 'western_transit');
      expect(result.candidates, hasLength(2));
      expect(result.candidates.first.confidence, 0.78);
      expect(result.candidates.first.time.hour, 7);
      expect(result.candidates.first.time.minute, 14);
      expect(result.candidates.first.ascendant, 'Gemini');
      expect(result.evidence, hasLength(2));
      expect(result.evidence.first.matchStrength, MatchStrength.strong);
      expect(result.evidence.last.matchStrength, MatchStrength.weak);
      expect(result.isDemo, isFalse);
      expect(result.completedAt, completedAt);
      expect(result.rawResponseJson, '{"raw":true}');
    });

    test('unknown matchStrength tag falls back to MatchStrength.none', () {
      final result = responseToResult(
        requestId: 'r',
        dto: const RectificationResponseDto(
          calculationId: 'c',
          candidates: <RectificationCandidateDto>[],
          evidence: <RectificationEventMatchDto>[
            RectificationEventMatchDto(
              eventId: 'e',
              matchStrength: 'definitely-strong-but-typo',
              explanation: 'whatever',
            ),
          ],
        ),
        completedAt: DateTime.utc(2026, 5, 20),
      );

      expect(result.evidence.single.matchStrength, MatchStrength.none);
    });
  });
}
