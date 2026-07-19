# Vendor test 3: Disable class

## Vendor setup

Sets `$rfs-class: disable`. Values are responsive normally, while elements in a
`.disable-rfs` selector region receive the fixed maximum.

## Dart comparison

`RfsEnabled(enabled: false)` provides the widget-subtree equivalent and keeps
the surrounding base value, factor, breakpoint, and dimension. Tests cover a
disabled subtree and a nested state reversal.

**Status: Equivalent.** Selector generation and specificity are not applicable.
Unlike the vendor's single global class mode, Dart permits arbitrary nested
enable/disable reversals as a Flutter extension.
