# Vendor test 5: Breakpoint unit in EM

## Vendor setup

Sets the breakpoint output unit to `em`, producing `75em` for the default
1200px breakpoint while leaving the numeric responsive curve unchanged.

## Dart comparison

Flutter has no CSS media-query unit. `RfsConfig.breakpoint` is already a
resolved logical-pixel extent. Custom numeric breakpoints and clamping are
directly tested.

**Status: Not applicable for serialization; direct for breakpoint behavior.**
