import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../domain/entities/raw_kanjivg.dart';
import '../../domain/entities/warning.dart';

/// Result of scanning raw KanjiVG entries for radical candidates.
class RadicalScanResult {
  const RadicalScanResult({required this.masters, this.warnings = const []});

  /// Master radicals keyed by masterSymbol.
  final Map<String, MasterInfo> masters;

  /// Warnings encountered during scanning (e.g. variant without original).
  final List<Warning> warnings;
}

/// Information about a master radical collected during scanning.
class MasterInfo {
  const MasterInfo({
    required this.masterSymbol,
    required this.isOfficial,
    required this.variants,
  });

  final String masterSymbol;
  final bool isOfficial;

  /// Variant shapes keyed by shape string. Includes self-variant if the master
  /// symbol was seen directly as a child element.
  final Map<String, VariantInfo> variants;
}

/// Information about a variant shape collected during scanning.
class VariantInfo {
  const VariantInfo({
    required this.shape,
    required this.isExplicitVariant,
    required this.positionCounts,
  });

  final String shape;

  /// True if this variant had `variant==true` in KanjiVG (explicit variant
  /// shape), false if it's a canonical self-shape.
  final bool isExplicitVariant;

  /// Position → number of kanji trees where this variant appeared at that
  /// position.
  final Map<Position, int> positionCounts;
}

/// Maps KanjiVG position strings to [Position] enum values.
Position mapKanjiVgPosition(String? kanjivgPosition) =>
    switch (kanjivgPosition) {
      'left' => Position.hen,
      'right' => Position.tsukuri,
      'top' => Position.kanmuri,
      'bottom' => Position.ashi,
      'kamae' => Position.kamae,
      'tare' => Position.tare,
      'nyo' => Position.nyo,
      _ => Position.unknown,
    };

/// Scans raw KanjiVG entries to extract radical candidates (Pass 1).
///
/// This is a pure function with no side effects — it does not touch the
/// database.
class RadicalScanner {
  /// Scans all entries and returns a [RadicalScanResult] with radical
  /// candidates and their variant/position information.
  RadicalScanResult scan(List<RawKanjiVg> entries) {
    final masters = <String, _MasterBuilder>{};
    final warnings = <Warning>[];

    for (final entry in entries) {
      final directChildren = _collectDirectChildren(entry.components);

      for (final child in directChildren) {
        final String masterSymbol;
        final String shape;
        final bool isExplicitVariant;

        if (child.variant == true && child.original != null) {
          masterSymbol = child.original!;
          shape = child.element;
          isExplicitVariant = true;
        } else {
          if (child.variant == true) {
            warnings.add(Warning(
              'Variant without original: ${child.element} '
              'in ${entry.character}',
            ));
          }
          masterSymbol = child.element;
          shape = child.element;
          isExplicitVariant = false;
        }

        final master = masters.putIfAbsent(
          masterSymbol,
          () => _MasterBuilder(masterSymbol),
        );

        if (child.radical == 'general') {
          master.isOfficial = true;
        }

        final variant = master.variants.putIfAbsent(
          shape,
          () => _VariantBuilder(shape, isExplicitVariant),
        );

        final position = mapKanjiVgPosition(child.position);
        variant.positionCounts[position] =
            (variant.positionCounts[position] ?? 0) + 1;
      }
    }

    return RadicalScanResult(
      masters: masters.map((k, v) => MapEntry(k, v.build())),
      warnings: warnings,
    );
  }

  /// Collects direct children from a root component, flattening structural
  /// groups (empty elements) and merging split parts (same element, different
  /// `part` values).
  List<_ChildInfo> _collectDirectChildren(KanjiVgComponent root) {
    // 1. Flatten structural groups (empty element nodes).
    final flat = <KanjiVgComponent>[];
    for (final child in root.children) {
      _flattenEmpty(child, flat);
    }

    // 2. Separate part-children from non-part children.
    final partGroups = <String, List<KanjiVgComponent>>{};
    final nonPart = <KanjiVgComponent>[];

    for (final child in flat) {
      if (child.element.isEmpty) continue;
      if (child.part != null) {
        partGroups.putIfAbsent(child.element, () => []).add(child);
      } else {
        nonPart.add(child);
      }
    }

    final result = <_ChildInfo>[];

    // Each part group becomes one merged child.
    for (final parts in partGroups.values) {
      result.add(_mergePartChildren(parts));
    }

    // Non-part children contribute individually.
    for (final child in nonPart) {
      result.add(_ChildInfo(
        element: child.element,
        position: child.position,
        variant: child.variant,
        original: child.original,
        radical: child.radical,
      ));
    }

    return result;
  }

  /// Recursively flattens empty-element nodes, promoting their children.
  void _flattenEmpty(KanjiVgComponent node, List<KanjiVgComponent> out) {
    if (node.element.isEmpty) {
      for (final child in node.children) {
        _flattenEmpty(child, out);
      }
    } else {
      out.add(node);
    }
  }

  /// Merges split parts into a single child, taking position/variant/original/
  /// radical from the first part that carries each attribute.
  _ChildInfo _mergePartChildren(List<KanjiVgComponent> parts) {
    String? position;
    bool? variant;
    String? original;
    String? radical;

    for (final part in parts) {
      position ??= part.position;
      variant ??= part.variant;
      original ??= part.original;
      radical ??= part.radical;
    }

    return _ChildInfo(
      element: parts.first.element,
      position: position,
      variant: variant,
      original: original,
      radical: radical,
    );
  }
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

class _ChildInfo {
  const _ChildInfo({
    required this.element,
    required this.position,
    required this.variant,
    required this.original,
    required this.radical,
  });

  final String element;
  final String? position;
  final bool? variant;
  final String? original;
  final String? radical;
}

class _MasterBuilder {
  _MasterBuilder(this.masterSymbol);

  final String masterSymbol;
  bool isOfficial = false;
  final Map<String, _VariantBuilder> variants = {};

  MasterInfo build() => MasterInfo(
        masterSymbol: masterSymbol,
        isOfficial: isOfficial,
        variants: variants.map((k, v) => MapEntry(k, v.build())),
      );
}

class _VariantBuilder {
  _VariantBuilder(this.shape, this.isExplicitVariant);

  final String shape;
  final bool isExplicitVariant;
  final Map<Position, int> positionCounts = {};

  VariantInfo build() => VariantInfo(
        shape: shape,
        isExplicitVariant: isExplicitVariant,
        positionCounts: Map.unmodifiable(positionCounts),
      );
}
