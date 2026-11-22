import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:int_extension/int_extension.dart';
import 'package:rational/rational.dart';

/// Converts a supported value to a [Rational].
///
/// Returns `null` if [value] is `null` or has an unsupported type. Strings are
/// parsed with [Rational.parse]; parsing errors are propagated to the caller.
Rational? rationalFromDynamic(dynamic value) {
  if (value == null) return null;
  if (value is Rational) return value;
  if (value is int) return value.toRational();
  if (value is String) return Rational.parse(value);
  return null;
}

/// Additional conversions and checks for rational numbers.
extension RationalExtn on Rational {
  /// Whether this rational number is equal to zero.
  bool get isZero => this == Rational.zero;

  /// Whether this rational number is not equal to zero.
  bool get isNotZero => this != Rational.zero;

  /// Encodes the numerator and denominator into 16 bytes.
  ///
  /// The first 8 bytes contain the numerator and the next 8 contain the
  /// denominator. Both values are stored as signed 64-bit integers using the
  /// platform's byte order. Values must fit in the `int64` range.
  Uint8List toBytes() {
    // Allocate a 16-byte buffer for the encoded values.
    final uInt8List = Uint8List(16);
    // View the buffer as two signed 64-bit integers.
    final buf64 = uInt8List.buffer.asInt64List();
    buf64[0] = numerator.toInt();
    buf64[1] = denominator.toInt();
    return uInt8List;
  }

  /// Truncates this number toward zero at the specified decimal scale.
  ///
  /// For example, `2` truncates to hundredths, `0` to integers, and `-3` to
  /// thousands.
  ///
  /// Defaults to [intMaxDigits].
  Decimal toTruncateDecimal([int digits = intMaxDigits]) {
    final scale = Rational.fromInt(10).pow(digits);
    final truncatedNumerator = (this * scale).truncate();
    return (truncatedNumerator.toRational() / scale).toDecimal();
  }

  /// Rounds this number to the nearest value at the specified decimal scale.
  ///
  /// Exact halfway values are rounded away from zero, as with [Decimal.round].
  ///
  /// Defaults to [intMaxDigits] minus one.
  Decimal toRoundDecimal([int digits = intMaxDigits - 1]) {
    final scale = Rational.fromInt(10).pow(digits);
    final roundedNumerator = (this * scale).round();
    return (roundedNumerator.toRational() / scale).toDecimal();
  }

  /// Returns a decimal representation with exactly [fractionDigits] digits
  /// after the decimal point.
  String toStringAsFixed(int fractionDigits) =>
      toDecimal(scaleOnInfinitePrecision: intMaxDigits)
          .toStringAsFixed(fractionDigits);
}
