# Vendor test 4: Enable class

## Vendor setup

Sets `$rfs-class: enable`. The fixed maximum is the normal value and responsive
behavior is emitted for `.enable-rfs` selector regions.

## Dart comparison

An enabled `RfsEnabled` subtree is tested inside a disabled subtree. The test
also verifies that the inherited numeric configuration and shortest-side
dimension survive the override.

**Status: Equivalent.** CSS selectors and specificity are not generated.
