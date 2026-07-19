// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import 'rfs_builder.dart';

/// Text whose font size scales fluidly with the available layout.
///
/// The font size interpolates between [minFontSize] and [maxFontSize]
/// based on the surrounding constraints (or the app window when the
/// constraints are unbounded). All other [Text] options are forwarded
/// unchanged:
///
/// ```dart
/// RfsText('Fluid headline', maxFontSize: 64, minFontSize: 36)
/// ```
///
/// Use [RfsText.rich] for an [InlineSpan] tree. Configuration and
/// dimension come from the nearest `RfsScope` unless overridden with
/// [config] and [dimension].
class RfsText extends StatelessWidget {
  /// Creates fluid text from a plain string.
  const RfsText(
    String text, {
    super.key,
    required this.maxFontSize,
    this.minFontSize,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.textScaler,
    this.config,
    this.dimension,
  }) : text = text,
       textSpan = null;

  /// Creates fluid text from an [InlineSpan] tree.
  ///
  /// The resolved font size is applied to the root style; spans keep
  /// their own style overrides.
  const RfsText.rich(
    InlineSpan textSpan, {
    super.key,
    required this.maxFontSize,
    this.minFontSize,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.textScaler,
    this.config,
    this.dimension,
  }) : text = null,
       textSpan = textSpan;

  /// The string to display; null when constructed with [RfsText.rich].
  final String? text;

  /// The span tree to display; null when constructed with a plain string.
  final InlineSpan? textSpan;

  /// The font size used at or above the configured breakpoint.
  final double maxFontSize;

  /// The font size approached on the smallest layouts.
  ///
  /// When omitted, a minimum is derived from the configuration.
  final double? minFontSize;

  /// The base style; the resolved font size is applied on top of it.
  final TextStyle? style;

  /// Corresponds to [Text.textAlign].
  final TextAlign? textAlign;

  /// Corresponds to [Text.textDirection].
  final TextDirection? textDirection;

  /// Corresponds to [Text.locale].
  final Locale? locale;

  /// Corresponds to [Text.softWrap].
  final bool? softWrap;

  /// Corresponds to [Text.overflow].
  final TextOverflow? overflow;

  /// Corresponds to [Text.maxLines].
  final int? maxLines;

  /// Corresponds to [Text.semanticsLabel].
  final String? semanticsLabel;

  /// Corresponds to [Text.semanticsIdentifier].
  final String? semanticsIdentifier;

  /// Corresponds to [Text.textWidthBasis].
  final TextWidthBasis? textWidthBasis;

  /// Corresponds to [Text.textHeightBehavior].
  final TextHeightBehavior? textHeightBehavior;

  /// Corresponds to [Text.selectionColor].
  final Color? selectionColor;

  /// Corresponds to [Text.strutStyle].
  final StrutStyle? strutStyle;

  /// Corresponds to [Text.textScaler].
  ///
  /// Fluid sizing never modifies the ambient scaler; pass one here only
  /// to override what [Text] would use.
  final TextScaler? textScaler;

  /// Overrides the configuration from the nearest `RfsScope`.
  final RfsConfig? config;

  /// Overrides the dimension from the nearest `RfsScope`.
  final RfsDimension? dimension;

  @override
  Widget build(BuildContext context) => RfsBuilder(
    config: config,
    dimension: dimension,
    builder: (context, metrics) {
      final textStyle = (style ?? const TextStyle()).copyWith(
        fontSize: metrics.resolve(max: maxFontSize, min: minFontSize),
      );
      if (textSpan != null) {
        return Text.rich(
          textSpan!,
          style: textStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          semanticsIdentifier: semanticsIdentifier,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
          strutStyle: strutStyle,
          textScaler: textScaler,
        );
      }
      return Text(
        text!,
        style: textStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        semanticsIdentifier: semanticsIdentifier,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
        strutStyle: strutStyle,
        textScaler: textScaler,
      );
    },
  );
}
