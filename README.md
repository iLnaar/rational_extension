# rational_extension

Utility extensions for the popular [`rational`](https://pub.dev/packages/rational) package.

## Installation

Add the package to your project:

```sh
dart pub add rational_extension
```

Or add it to `pubspec.yaml`:

```yaml
dependencies:
  rational_extension: ^1.0.0
```

## Usage

```dart
import 'package:rational/rational.dart';
import 'package:rational_extension/rational_extension.dart';

void main() {
  final value = Rational.fromInt(1, 3);

  print(value.isZero); // false
  print(value.isNotZero); // true
  print(value.toTruncateDecimal(4)); // 0.3333
  print(value.toRoundDecimal(2)); // 0.33
  print(value.toStringAsFixed(2)); // 0.33
}
```

## API

### `RationalExtn`

Import `rational_extension.dart` to use the extension on `Rational`:

- `isZero` and `isNotZero` — check whether the value is zero;
- `toTruncateDecimal([digits])` — truncates toward zero at the specified
  decimal scale: `2` means hundredths, `0` means integers, and `-3` means
  thousands. Defaults to `intMaxDigits`;
- `toRoundDecimal([digits])` — rounds to the nearest value at the specified
  decimal scale, with halfway values rounded away from zero. Defaults to
  `intMaxDigits - 1`;
- `toStringAsFixed(fractionDigits)` — returns a string with the specified
  number of digits after the decimal point;
- `toBytes()` — encodes the numerator and denominator into 16 bytes: the first
  8 bytes contain the numerator, and the next 8 contain the denominator. Both
  values are stored as signed 64-bit integers in the platform's byte order.
  The numerator and denominator must fit in the `int64` range.

### `rationalFromDynamic(value)`

Converts a supported value to `Rational`:

```dart
final fromInt = rationalFromDynamic(3); // Rational with value 3
final fromString = rationalFromDynamic('3/4');
final fromNull = rationalFromDynamic(null); // null
final unsupported = rationalFromDynamic(1.5); // null
```

Supported values are `Rational`, `int`, and strings parsed with
`Rational.parse`. The function returns `null` for `null` and unsupported types.
String parsing errors are not caught and are propagated to the caller.

## Requirements

- Dart SDK `>=2.12.0 <4.0.0.`
- [`decimal`](https://pub.dev/packages/decimal)
- [`int_extension`](https://pub.dev/packages/int_extension)
- [`rational`](https://pub.dev/packages/rational)
