# Vendor test 6: Change base value

## Vendor setup

Sets the base value to 17px. This changes the cutoff and factor-derived minimum
while preserving the other defaults.

## Dart comparison

`RfsConfig.baseValue` is directly tested with custom values 10 and 12, including
the cutoff and derived-minimum calculation. The exact vendor value 17 is not a
separate Dart fixture, but it follows the same numeric path.

**Status: Direct behavior with a different representative value.**
