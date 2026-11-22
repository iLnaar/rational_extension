import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';
import 'package:rational_extension/rational_extension.dart';
import 'package:test/test.dart';

void main() {
  group('rationalFromDynamic', () {
    test('returns null for null and unsupported values', () {
      expect(rationalFromDynamic(null), isNull);
      expect(rationalFromDynamic(1.5), isNull);
      expect(rationalFromDynamic(true), isNull);
      expect(rationalFromDynamic(Object()), isNull);
    });

    test('returns an existing Rational unchanged', () {
      final value = Rational.fromInt(3, 4);

      expect(rationalFromDynamic(value), same(value));
    });

    test('converts integers to Rational', () {
      expect(rationalFromDynamic(3), Rational.parse('3'));
      expect(rationalFromDynamic(0), Rational.zero);
      expect(rationalFromDynamic(-2), Rational.parse('-2'));
    });

    test('parses strings as Rational', () {
      expect(rationalFromDynamic('0.75'), Rational.fromInt(3, 4));
      expect(rationalFromDynamic('-2'), Rational.parse('-2'));
    });

    test('propagates string parsing errors', () {
      expect(
        () => rationalFromDynamic('not a rational'),
        throwsFormatException,
      );
    });
  });

  group('RationalExtn', () {
    group('zero checks', () {
      test('identifies zero and non-zero values', () {
        expect(Rational.zero.isZero, isTrue);
        expect(Rational.zero.isNotZero, isFalse);

        final nonZero = Rational.fromInt(-1, 3);
        expect(nonZero.isZero, isFalse);
        expect(nonZero.isNotZero, isTrue);
      });
    });

    group('toFloorDecimal', () {
      test('converts repeating values to the requested precision', () {
        expect(
          Rational.fromInt(1, 3).toFloorDecimal(4),
          Decimal.parse('0.3333'),
        );
        expect(
          Rational.fromInt(-1, 3).toFloorDecimal(4),
          Decimal.parse('-0.3333'),
        );
      });

      test('preserves terminating decimal values', () {
        expect(
          Rational.fromInt(7, 8).toFloorDecimal(2),
          Decimal.parse('0.875'),
        );
      });
    });

    group('toRoundDecimal', () {
      test('rounds repeating values to the requested precision', () {
        expect(Rational.fromInt(1, 3).toRoundDecimal(2), Decimal.parse('0.33'));
        expect(
          Rational.fromInt(-1, 3).toRoundDecimal(2),
          Decimal.parse('-0.33'),
        );
      });

      test('rounds finite values when precision is reduced', () {
        expect(Rational.fromInt(7, 8).toRoundDecimal(2), Decimal.parse('0.88'));
      });
    });

    group('toStringAsFixed', () {
      test('returns exactly the requested number of fractional digits', () {
        expect(Rational.fromInt(1, 3).toStringAsFixed(2), '0.33');
        expect(Rational.fromInt(7, 8).toStringAsFixed(3), '0.875');
        expect(Rational.parse('2').toStringAsFixed(2), '2.00');
      });
    });

    group('toBytes', () {
      test('encodes numerator and denominator as two signed 64-bit values', () {
        final bytes = Rational.fromInt(-3, 7).toBytes();
        final data = ByteData.sublistView(bytes);

        expect(bytes, hasLength(16));
        expect(data.getInt64(0, Endian.host), -3);
        expect(data.getInt64(8, Endian.host), 7);
      });
    });
  });
}
