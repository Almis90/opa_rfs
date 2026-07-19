# Vendor test 7: Pixel output

## Vendor setup

Sets `$rfs-unit: px`, changing serialized fixed and fluid values from REM to
pixels without changing the curve.

## Dart comparison

Dart returns `double` values in Flutter logical pixels and never serializes CSS.
There is no output-unit switch to test.

**Status: Not applicable.** The corresponding numeric values are covered by the
default parity fixtures.
