import 'dart:typed_data';

import 'package:rational/rational.dart';
import 'package:rational_extension/rational_extension.dart';

void main() {
  final third = Rational.fromInt(1, 3);

  // Check whether a rational value is zero.
  print('Is zero: ${third.isZero}'); // false
  print('Is not zero: ${third.isNotZero}'); // true

  // Convert repeating values to decimal values with a chosen precision.
  print('Truncated to 4 places: ${third.toTruncateDecimal(4)}'); // 0.3333
  print('Rounded to 2 places: ${third.toRoundDecimal(2)}'); // 0.33
  print('Fixed to 2 places: ${third.toStringAsFixed(2)}'); // 0.33

  // Negative scales operate on digits to the left of the decimal point.
  final amount = Rational.parse('1234.56');
  print('Truncated to thousands: ${amount.toTruncateDecimal(-3)}'); // 1000
  print('Rounded to thousands: ${amount.toRoundDecimal(-3)}'); // 1000

  // Convert supported dynamic values to Rational. Unsupported values return null.
  final fromInt = rationalFromDynamic(3);
  final fromString = rationalFromDynamic('0.75');
  final fromNull = rationalFromDynamic(null);
  final unsupported = rationalFromDynamic(1.5);
  print('From int: $fromInt'); // 3
  print('From string: $fromString'); // 3/4
  print('From null: $fromNull'); // null
  print('Unsupported type: $unsupported'); // null

  // toBytes stores the numerator and denominator as two signed int64 values
  // in the platform byte order.
  final bytes = Rational.fromInt(-3, 7).toBytes();
  final data = ByteData.sublistView(bytes);
  final numerator = data.getInt64(0, Endian.host);
  final denominator = data.getInt64(8, Endian.host);
  print('Encoded rational: $numerator/$denominator'); // -3/7
}
