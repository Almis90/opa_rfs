# Vendor test 12: Max mode with two-dimensional sizing

## Vendor setup

Combines max-media-query output with `vmin`. The vendor emits a fluid value when
either width or height is at or below the breakpoint.

## Dart comparison

Using the shortest side produces the same runtime condition. Dedicated fixtures
cover sizes where one side remains below the breakpoint and where both sides
reach it. As with test 11, declaration placement is irrelevant to runtime
evaluation.

**Status: Runtime equivalent and directly covered numerically.**
