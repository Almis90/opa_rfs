# Vendor test 11: Max-media-query mode

## Vendor setup

Reverses CSS declaration placement: the fixed maximum is emitted first and the
fluid expression is placed inside `@media (max-width: 1200px)`.

## Dart comparison

Min- and max-media-query modes produce the same final value at a given viewport
size. Dart calculates that value directly, so it needs no mode setting. Tests
cover fluid results below the breakpoint and fixed results at and above it.

**Status: Runtime equivalent.** CSS ordering and query serialization are not
applicable.
