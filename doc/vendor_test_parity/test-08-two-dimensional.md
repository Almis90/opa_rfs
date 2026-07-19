# Vendor test 8: Two-dimensional sizing

## Vendor setup

Enables `$rfs-two-dimensional`, replacing `vw` with `vmin` and requiring both
viewport dimensions to reach the breakpoint before using the maximum.

## Dart comparison

`RfsDimension.shortestSide` selects `min(width, height)`. Dedicated fixtures
cover unequal sides, equal sides, breakpoint clamping, a side below the
breakpoint, negative values, and disabled configuration. Widget and typography
tests also exercise shortest-side inheritance.

**Status: Direct.** Media-query text generation is not applicable.
