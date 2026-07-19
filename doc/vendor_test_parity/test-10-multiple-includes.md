# Vendor test 10: Include mixins multiple times

## Vendor setup

Imports the configured preprocessor implementation and then imports the shared
fixture, verifying that repeated mixin inclusion produces the same CSS as test
9. The PostCSS options file itself marks this scenario as not testable there.

## Dart comparison

Dart libraries are imported once per library namespace and calls to stateless
RFS resolvers do not emit or accumulate declarations. Reusing `Rfs.value`,
`RfsValue`, widgets, or typed helpers has no include-time side effect.

**Status: Not applicable.** Normal reuse is exercised throughout the Dart test
suite.
