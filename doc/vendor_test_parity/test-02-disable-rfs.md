# Vendor test 2: Disable responsive sizing

## Vendor setup

Sets `$enable-rfs: false` or `enableRfs: false`. Every supported value is
emitted at its fixed maximum without a responsive media query.

## Dart comparison

`RfsConfig(enabled: false)` returns the maximum immediately. This is directly
tested for positive and negative scalar values, context resolution, and a
two-dimensional fixture.

**Status: Direct.** CSS media-query omission is not applicable at runtime.
