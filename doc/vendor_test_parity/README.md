# Vendor test parity

This directory compares the tests in `vendor/rfs/test` with the focused Dart
tests under `test/core`, `test/inherited`, `test/values`, `test/widgets`, and
`test/typography`, using fixtures in `test/fixtures/rfs_parity.dart`.

The vendor runner reads 12 scenarios from `vendor/rfs/test/tests.json`. Each
scenario is compiled through Less, Less 3, LibSass, Dart Sass, Stylus, and
PostCSS and compared with one expected CSS file. The language-specific source
files repeat the same behavior, so this comparison uses one document per
scenario instead of duplicating it for every preprocessor.

## Status meanings

| Status | Meaning |
| --- | --- |
| Direct | A Dart test explicitly exercises the supported runtime behavior. |
| Equivalent | Dart tests the Flutter runtime equivalent, not CSS serialization. |
| Partial | Supported parts are tested, but not as the same combined scenario. |
| Not applicable | The vendor assertion only concerns Sass/CSS parsing or output. |
| Gap | The Dart API supports the behavior but has no focused assertion for it. |

## Scenario index

| Vendor scenario | Purpose | Dart status |
| --- | --- | --- |
| [test-1](test-01-default-build.md) | Default build and the shared 28-value input matrix | Direct for supported numeric/widget cases |
| [test-2](test-02-disable-rfs.md) | Disable RFS globally | Direct |
| [test-3](test-03-disable-class.md) | Disable-class selector regions | Equivalent |
| [test-4](test-04-enable-class.md) | Enable-class selector regions | Equivalent |
| [test-5](test-05-breakpoint-em.md) | Serialize the breakpoint in `em` | Not applicable; numeric breakpoint behavior is direct |
| [test-6](test-06-base-value.md) | Change the base value | Direct behavior, different fixture value |
| [test-7](test-07-output-px.md) | Serialize output in pixels | Not applicable |
| [test-8](test-08-two-dimensional.md) | Use `vmin` sizing | Direct |
| [test-9](test-09-custom-config.md) | Combine most configuration switches | Direct for supported combined numeric cases |
| [test-10](test-10-multiple-includes.md) | Include the implementation multiple times | Not applicable |
| [test-11](test-11-max-mode.md) | Generate max-media-query output | Runtime equivalent |
| [test-12](test-12-max-mode-2d.md) | Combine max mode with `vmin` | Runtime equivalent |

The common selector/value cases used by all scenarios are expanded in
[shared-cases.md](shared-cases.md). The PostCSS option matrix is documented in
[postcss-options.md](postcss-options.md).

## Supported test gaps found

The supported runtime gaps identified by this comparison are now directly
covered: physical and directional margins through `RfsBox`, responsive shadow
offset/blur/spread values above the cutoff, and combined custom configuration
with `shortestSide`. CSS-only behavior remains intentionally out of scope.
