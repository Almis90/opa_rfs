import 'package:flutter/material.dart';
import 'package:opa_rfs/opa_rfs.dart';

/// Runnable example application with URL-addressable destinations.
class RfsExampleApp extends StatelessWidget {
  const RfsExampleApp({super.key});

  static const demoRoute = '/demo';
  static const laboratoryRoute = '/laboratory';

  @override
  Widget build(BuildContext context) {
    final platformRoute =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    return MaterialApp(
      title: 'Flutter RFS showcase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff495057),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: platformRoute == '/' ? demoRoute : null,
      routes: {
        '/': (context) => _destination(context, 0),
        demoRoute: (context) => _destination(context, 0),
        laboratoryRoute: (context) => _destination(context, 1),
      },
    );
  }

  Widget _destination(BuildContext context, int index) => RfsExampleHome(
    initialIndex: index,
    onDestinationSelected: (value) {
      final route = value == 0 ? demoRoute : laboratoryRoute;
      if (ModalRoute.settingsOf(context)?.name != route) {
        Navigator.of(context).pushNamed(route);
      }
    },
  );
}

/// Example shell with two destinations: the showcase and the laboratory.
class RfsExampleHome extends StatefulWidget {
  const RfsExampleHome({
    super.key,
    this.initialIndex = 0,
    this.onDestinationSelected,
  }) : assert(initialIndex == 0 || initialIndex == 1);

  final int initialIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<RfsExampleHome> createState() => _RfsExampleHomeState();
}

class _RfsExampleHomeState extends State<RfsExampleHome> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  void _selectDestination(int value) {
    if (value == _index) return;
    if (widget.onDestinationSelected case final onSelected?) {
      onSelected(value);
    } else {
      setState(() => _index = value);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _index == 0
        ? RfsExampleShowcase(onOpenLaboratory: () => _selectDestination(1))
        : const RfsLaboratoryPage(),
    bottomNavigationBar: NavigationBar(
      key: const ValueKey('example-nav'),
      selectedIndex: _index,
      onDestinationSelected: _selectDestination,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.waves_rounded),
          label: 'Showcase',
        ),
        NavigationDestination(
          icon: Icon(Icons.science_outlined),
          label: 'Laboratory',
        ),
      ],
    ),
  );
}

/// A polished landing-page example showing RFS in a realistic product UI.
class RfsExampleShowcase extends StatefulWidget {
  const RfsExampleShowcase({super.key, this.onOpenLaboratory});

  final VoidCallback? onOpenLaboratory;

  static const _ink = Color(0xff102a43);
  static const _muted = Color(0xff627d98);
  static const _blue = Color(0xff147d92);
  static const _smallSpacingConfig = RfsConfig(baseValue: 12);
  static const _tinySpacingConfig = RfsConfig(baseValue: 4);

  @override
  State<RfsExampleShowcase> createState() => _RfsExampleShowcaseState();
}

class _RfsExampleShowcaseState extends State<RfsExampleShowcase> {
  double? _lastLoggedWidth;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xfff7fafc),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final wide = width >= 1000;
        final pagePadding = Rfs.value(80, width: width, min: 24);
        final sectionGap = Rfs.value(96, width: width, min: 56);
        final heroTitleSize = Rfs.value(68, width: width, min: 38);
        final responsiveHeroBodySize = Rfs.value(
          20,
          width: width,
          min: 17,
          config: RfsExampleShowcase._smallSpacingConfig,
        );
        final radius = Rfs.value(36, width: width, min: 18);

        _logResponsiveValues(
          width: width,
          wide: wide,
          titleSize: heroTitleSize,
          pagePadding: pagePadding,
          sectionGap: sectionGap,
          radius: radius,
          shadowBlur: Rfs.value(32, width: width, min: 12),
        );

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _PageShell(
                padding: pagePadding,
                child: Column(
                  children: [
                    _Navigation(wide: wide),
                    SizedBox(height: Rfs.value(64, width: width, min: 36)),
                    Flex(
                      direction: wide ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: wide
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: wide ? 10 : 0,
                          child: _HeroCopy(
                            titleSize: heroTitleSize,
                            bodySize: responsiveHeroBodySize,
                            width: width,
                          ),
                        ),
                        if (wide) SizedBox(width: Rfs.value(64, width: width)),
                        if (!wide) const SizedBox(height: 40),
                        Expanded(
                          flex: wide ? 11 : 0,
                          child: _DashboardPreview(
                            radius: radius,
                            width: width,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sectionGap),
                    _LogoRow(wide: wide),
                    SizedBox(height: sectionGap),
                    _FeatureSection(width: width, wide: wide, radius: radius),
                    SizedBox(height: sectionGap),
                    _LabTeaser(width: width, onOpen: widget.onOpenLaboratory),
                    SizedBox(height: sectionGap),
                    _ApiShowcase(width: width),
                    SizedBox(height: Rfs.value(40, width: width, min: 24)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: RfsExampleShowcase._ink,
                padding: EdgeInsets.symmetric(
                  vertical: Rfs.value(32, width: width, min: 24),
                ),
                child: Text(
                  'Flowline helps teams do their best work.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Rfs.value(
                      18,
                      width: width,
                      min: 16,
                      config: RfsExampleShowcase._smallSpacingConfig,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  void _logResponsiveValues({
    required double width,
    required bool wide,
    required double titleSize,
    required double pagePadding,
    required double sectionGap,
    required double radius,
    required double shadowBlur,
  }) {
    if (_lastLoggedWidth != null && (width - _lastLoggedWidth!).abs() < 0.5) {
      return;
    }
    _lastLoggedWidth = width;
    debugPrint(
      '[opa_rfs] width=${width.toStringAsFixed(1)}px '
      'mode=${wide ? 'desktop' : 'mobile'} '
      'title=${titleSize.toStringAsFixed(1)} '
      'pagePadding=${pagePadding.toStringAsFixed(1)} '
      'sectionGap=${sectionGap.toStringAsFixed(1)} '
      'radius=${radius.toStringAsFixed(1)} '
      'shadowBlur=${shadowBlur.toStringAsFixed(1)}',
    );
  }
}

class _PageShell extends StatelessWidget {
  const _PageShell({required this.padding, required this.child});

  final double padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1280),
      child: Padding(
        padding: EdgeInsets.only(
          left: padding,
          right: padding,
          top: Rfs.value(12, width: MediaQuery.sizeOf(context).width, min: 8),
        ),
        child: SafeArea(top: true, bottom: false, child: child),
      ),
    ),
  );
}

class _Navigation extends StatelessWidget {
  const _Navigation({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(
        Icons.waves_rounded,
        color: RfsExampleShowcase._blue,
        size: 28,
      ),
      const SizedBox(width: 8),
      const Text(
        'flowline',
        style: TextStyle(
          color: RfsExampleShowcase._ink,
          fontSize: 21,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      const Spacer(),
      if (wide) ...[
        TextButton(onPressed: () {}, child: const Text('Product')),
        TextButton(onPressed: () {}, child: const Text('Solutions')),
        TextButton(onPressed: () {}, child: const Text('Pricing')),
        const SizedBox(width: 12),
        OutlinedButton(onPressed: () {}, child: const Text('Sign in')),
        const SizedBox(width: 8),
        FilledButton(onPressed: () {}, child: const Text('Try it free')),
      ] else
        IconButton(
          onPressed: () {},
          tooltip: 'Open menu',
          icon: const Icon(Icons.menu_rounded),
        ),
    ],
  );
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.titleSize,
    required this.bodySize,
    required this.width,
  });

  final double titleSize;
  final double bodySize;
  final double width;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xffd9f0f2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Text(
          'THE CALMER WAY TO WORK',
          style: TextStyle(
            color: RfsExampleShowcase._blue,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      SizedBox(height: Rfs.value(24, width: width, min: 16)),
      Text(
        'Build calmer, clearer workflows for your team.',
        style: TextStyle(
          color: RfsExampleShowcase._ink,
          fontSize: titleSize,
          height: 1.03,
          fontWeight: FontWeight.w800,
          letterSpacing: -2.2,
        ),
      ),
      SizedBox(height: Rfs.value(24, width: width, min: 16)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Text(
          'One flexible workspace for planning projects, sharing knowledge, and keeping everyone aligned.',
          style: TextStyle(
            color: RfsExampleShowcase._muted,
            fontSize: bodySize,
            height: 1.55,
          ),
        ),
      ),
      SizedBox(height: Rfs.value(32, width: width, min: 24)),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('Start for free'),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('See how it works'),
          ),
        ],
      ),
      SizedBox(
        height: Rfs.value(
          20,
          width: width,
          min: 16,
          config: RfsExampleShowcase._smallSpacingConfig,
        ),
      ),
      const Text(
        'No credit card required  •  Free forever for small teams',
        style: TextStyle(color: RfsExampleShowcase._muted, fontSize: 12),
      ),
    ],
  );
}

class _DashboardPreview extends StatelessWidget {
  const _DashboardPreview({required this.radius, required this.width});

  final double radius;
  final double width;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(
      Rfs.value(
        10,
        width: width,
        min: 6,
        config: RfsExampleShowcase._tinySpacingConfig,
      ),
    ),
    decoration: BoxDecoration(
      color: const Color(0xffd9f0f2),
      borderRadius: BorderRadius.circular(radius),
    ),
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius - 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .12),
            blurRadius: Rfs.value(28, width: width, min: 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe6eef2))),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_rounded,
                  size: 18,
                  color: RfsExampleShowcase._muted,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Q3 product launch',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: RfsExampleShowcase._ink,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 13,
                  backgroundColor: const Color(0xfff7c59f),
                  child: const Text(
                    'A',
                    style: TextStyle(
                      fontSize: 11,
                      color: RfsExampleShowcase._ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Rfs.value(24, width: width, min: 14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good morning, Alex',
                  style: TextStyle(
                    color: RfsExampleShowcase._muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your team is on track',
                  style: TextStyle(
                    color: RfsExampleShowcase._ink,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: Rfs.value(
                    20,
                    width: width,
                    min: 12,
                    config: RfsExampleShowcase._smallSpacingConfig,
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: _Metric(
                        label: 'In progress',
                        value: '12',
                        color: Color(0xffd9f0f2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: _Metric(
                        label: 'Completed',
                        value: '28',
                        color: Color(0xffe5f3e7),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Rfs.value(
                    20,
                    width: width,
                    min: 12,
                    config: RfsExampleShowcase._smallSpacingConfig,
                  ),
                ),
                const Text(
                  'This week',
                  style: TextStyle(
                    color: RfsExampleShowcase._ink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const _TaskRow(
                  icon: Icons.check_circle,
                  color: Color(0xff2f9e44),
                  text: 'Finalize launch messaging',
                ),
                const _TaskRow(
                  icon: Icons.radio_button_checked,
                  color: Color(0xff147d92),
                  text: 'Review onboarding flow',
                ),
                const _TaskRow(
                  icon: Icons.radio_button_unchecked,
                  color: Color(0xffbcccdc),
                  text: 'Share customer research',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: RfsExampleShowcase._ink,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: RfsExampleShowcase._muted,
          ),
        ),
      ],
    ),
  );
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: RfsExampleShowcase._muted,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

class _LogoRow extends StatelessWidget {
  const _LogoRow({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    spacing: wide ? 56 : 24,
    runSpacing: 16,
    children: const [
      Text(
        'northstar',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff829ab1)),
      ),
      Text(
        'MOTION',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
          color: Color(0xff829ab1),
        ),
      ),
      Text(
        'CIRRUS',
        style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xff829ab1)),
      ),
      Text(
        'verve',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff829ab1)),
      ),
    ],
  );
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({
    required this.width,
    required this.wide,
    required this.radius,
  });

  final double width;
  final bool wide;
  final double radius;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        'Everything your team needs to move forward',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: RfsExampleShowcase._ink,
          fontSize: Rfs.value(34, width: width, min: 26),
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
      ),
      SizedBox(
        height: Rfs.value(
          16,
          width: width,
          min: 12,
          config: RfsExampleShowcase._smallSpacingConfig,
        ),
      ),
      const Text(
        'Simple enough to start today. Powerful enough to grow with you.',
        textAlign: TextAlign.center,
        style: TextStyle(color: RfsExampleShowcase._muted),
      ),
      SizedBox(height: Rfs.value(40, width: width, min: 24)),
      if (wide)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FeatureCard(
                icon: Icons.view_kanban_outlined,
                title: 'See the whole picture',
                text:
                    'Bring projects, docs, and decisions into one clear view.',
                radius: radius,
                width: width,
              ),
            ),
            SizedBox(
              width: Rfs.value(
                20,
                width: width,
                min: 12,
                config: RfsExampleShowcase._smallSpacingConfig,
              ),
            ),
            Expanded(
              child: _FeatureCard(
                icon: Icons.forum_outlined,
                title: 'Keep context close',
                text:
                    'Turn scattered conversations into knowledge your team can use.',
                radius: radius,
                width: width,
              ),
            ),
            SizedBox(
              width: Rfs.value(
                20,
                width: width,
                min: 12,
                config: RfsExampleShowcase._smallSpacingConfig,
              ),
            ),
            Expanded(
              child: _FeatureCard(
                icon: Icons.auto_awesome_outlined,
                title: 'Make momentum visible',
                text: 'Know what matters next without another status meeting.',
                radius: radius,
                width: width,
              ),
            ),
          ],
        )
      else
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FeatureCard(
              icon: Icons.view_kanban_outlined,
              title: 'See the whole picture',
              text: 'Bring projects, docs, and decisions into one clear view.',
              radius: radius,
              width: width,
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.forum_outlined,
              title: 'Keep context close',
              text:
                  'Turn scattered conversations into knowledge your team can use.',
              radius: radius,
              width: width,
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.auto_awesome_outlined,
              title: 'Make momentum visible',
              text: 'Know what matters next without another status meeting.',
              radius: radius,
              width: width,
            ),
          ],
        ),
    ],
  );
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.radius,
    required this.width,
  });

  final IconData icon;
  final String title;
  final String text;
  final double radius;
  final double width;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(Rfs.value(28, width: width, min: 20)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: const Color(0xffe6eef2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: RfsExampleShowcase._blue, size: 28),
        SizedBox(height: Rfs.value(24, width: width, min: 16)),
        Text(
          title,
          style: const TextStyle(
            color: RfsExampleShowcase._ink,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: RfsExampleShowcase._muted,
            height: 1.45,
          ),
        ),
      ],
    ),
  );
}

class _LabTeaser extends StatelessWidget {
  const _LabTeaser({required this.width, required this.onOpen});

  final double width;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('lab-teaser'),
    width: double.infinity,
    padding: EdgeInsets.all(Rfs.value(32, width: width, min: 20)),
    decoration: BoxDecoration(
      color: RfsExampleShowcase._ink,
      borderRadius: BorderRadius.circular(Rfs.value(28, width: width, min: 16)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Curious how the numbers work?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'The RFS laboratory lets you simulate viewport sizes, tune the '
          'configuration, and watch one value resolve in real time.',
          style: TextStyle(color: Color(0xffbcccdc)),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const ValueKey('open-lab-button'),
          onPressed: onOpen,
          icon: const Icon(Icons.science_outlined, size: 18),
          label: const Text('Open the laboratory'),
        ),
      ],
    ),
  );
}

/// A dedicated page for the interactive RFS laboratory.
class RfsLaboratoryPage extends StatelessWidget {
  const RfsLaboratoryPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xfff7fafc),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Rfs.value(48, width: width, min: 16),
              vertical: Rfs.value(32, width: width, min: 16),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1360),
                child: _RfsLab(width: width),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _RfsLab extends StatefulWidget {
  const _RfsLab({required this.width});

  final double width;

  @override
  State<_RfsLab> createState() => _RfsLabState();
}

const double _labMinSimulatedExtent = 320;
const double _labMaxSimulatedWidth = 1440;
const double _labMaxSimulatedHeight = 1200;

class _ViewportPreset {
  const _ViewportPreset(this.id, this.label, this.size);

  final String id;
  final String label;
  final Size size;
}

const _viewportPresets = [
  _ViewportPreset('phone', 'Phone', Size(390, 844)),
  _ViewportPreset('phone-landscape', 'Phone landscape', Size(844, 390)),
  _ViewportPreset('tablet', 'Tablet', Size(834, 1194)),
  _ViewportPreset('laptop', 'Laptop', Size(1366, 768)),
  _ViewportPreset('desktop', 'Desktop', Size(1440, 1200)),
];

class _RfsLabState extends State<_RfsLab> {
  static const _maxValue = 72.0;
  double _baseValue = 20;
  double _breakpoint = 1200;
  double _factor = 10;
  double _simulatedWidth = 760;
  double _simulatedHeight = 500;
  bool _enabled = true;
  RfsDimension _dimension = RfsDimension.width;

  @override
  Widget build(BuildContext context) {
    final config = RfsConfig(
      baseValue: _baseValue,
      breakpoint: _breakpoint,
      factor: _factor,
      enabled: _enabled,
    );
    final size = Size(_simulatedWidth, _simulatedHeight);
    final extent = _dimension == RfsDimension.width
        ? size.width
        : size.width < size.height
        ? size.width
        : size.height;
    final resolved = Rfs.valueForSize(
      _maxValue,
      size: size,
      config: config,
      dimension: _dimension,
    );
    final derivedMinimum =
        config.baseValue + (_maxValue - config.baseValue) / config.factor;
    final previewPadding = RfsEdgeInsets.all(
      RfsValue(max: 32),
    ).resolveForSize(size: size, dimension: _dimension, config: config);
    final previewRadius = const RfsBorderRadius(
      topLeft: RfsRadius(RfsValue(max: 28)),
      topRight: RfsRadius(RfsValue(max: 28)),
      bottomRight: RfsRadius(RfsValue(max: 28)),
      bottomLeft: RfsRadius(RfsValue(max: 28)),
    ).resolveForSize(size: size, dimension: _dimension, config: config);
    final previewShadow = const RfsBoxShadow(
      color: Color(0x66000000),
      offset: RfsOffset(dx: RfsValue(max: 16), dy: RfsValue(max: 12)),
      blurRadius: RfsValue(max: 24),
      spreadRadius: RfsValue(max: 4),
    ).resolveForSize(size: size, dimension: _dimension, config: config);

    final controls = _LabControls(
      simulatedWidth: _simulatedWidth,
      simulatedHeight: _simulatedHeight,
      baseValue: _baseValue,
      breakpoint: _breakpoint,
      factor: _factor,
      enabled: _enabled,
      dimension: _dimension,
      resolved: resolved,
      size: size,
      extent: extent,
      onWidthChanged: (value) => setState(() => _simulatedWidth = value),
      onHeightChanged: (value) => setState(() => _simulatedHeight = value),
      onBaseChanged: (value) => setState(() => _baseValue = value),
      onBreakpointChanged: (value) => setState(() => _breakpoint = value),
      onFactorChanged: (value) => setState(() => _factor = value),
      onEnabledChanged: (value) => setState(() => _enabled = value),
      onDimensionChanged: (value) => setState(() => _dimension = value),
    );
    final preview = _LabPreview(
      fontSize: resolved,
      padding: previewPadding,
      radius: previewRadius,
      shadow: previewShadow,
    );
    final details = _LabDetails(
      maxValue: _maxValue,
      minimum: derivedMinimum,
      extent: extent,
      breakpoint: _breakpoint,
      resolved: resolved,
      size: size,
      dimension: _dimension,
      enabled: _enabled,
    );

    return Container(
      key: const ValueKey('rfs-lab'),
      padding: EdgeInsets.all(Rfs.value(32, width: widget.width, min: 20)),
      decoration: BoxDecoration(
        color: const Color(0xff102a43),
        borderRadius: BorderRadius.circular(
          Rfs.value(28, width: widget.width, min: 16),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RFS laboratory',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tune one responsive value and see the calculation and preview update together.',
                style: TextStyle(color: Color(0xffbcccdc)),
              ),
              const SizedBox(height: 20),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: controls),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          details,
                          const SizedBox(height: 16),
                          preview,
                        ],
                      ),
                    ),
                  ],
                )
              else ...[
                controls,
                const SizedBox(height: 16),
                preview,
                const SizedBox(height: 16),
                details,
              ],
            ],
          );
        },
      ),
    );
  }
}

class _LabControls extends StatelessWidget {
  const _LabControls({
    required this.simulatedWidth,
    required this.simulatedHeight,
    required this.baseValue,
    required this.breakpoint,
    required this.factor,
    required this.enabled,
    required this.dimension,
    required this.resolved,
    required this.size,
    required this.extent,
    required this.onWidthChanged,
    required this.onHeightChanged,
    required this.onBaseChanged,
    required this.onBreakpointChanged,
    required this.onFactorChanged,
    required this.onEnabledChanged,
    required this.onDimensionChanged,
  });

  final double simulatedWidth;
  final double simulatedHeight;
  final double baseValue;
  final double breakpoint;
  final double factor;
  final bool enabled;
  final RfsDimension dimension;
  final double resolved;
  final Size size;
  final double extent;
  final ValueChanged<double> onWidthChanged;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onBaseChanged;
  final ValueChanged<double> onBreakpointChanged;
  final ValueChanged<double> onFactorChanged;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<RfsDimension> onDimensionChanged;

  bool get _widthDrives =>
      dimension == RfsDimension.width || size.width <= size.height;

  bool get _heightDrives =>
      dimension == RfsDimension.shortestSide && size.height < size.width;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Value driven by', style: TextStyle(color: Colors.white)),
          SegmentedButton<RfsDimension>(
            key: const ValueKey('lab-dimension-selector'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? const Color(0xffd9f0f2)
                    : Colors.transparent,
              ),
              foregroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? RfsExampleShowcase._ink
                    : const Color(0xffd9e2ec),
              ),
              side: const WidgetStatePropertyAll(
                BorderSide(color: Color(0xff627d98)),
              ),
            ),
            segments: const [
              ButtonSegment(value: RfsDimension.width, label: Text('Width')),
              ButtonSegment(
                value: RfsDimension.shortestSide,
                label: Text('Shortest'),
              ),
            ],
            selected: {dimension},
            onSelectionChanged: (value) => onDimensionChanged(value.first),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('RFS enabled', style: TextStyle(color: Colors.white)),
              Switch(
                key: const ValueKey('lab-enabled-switch'),
                value: enabled,
                onChanged: onEnabledChanged,
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 16),
      const _LabGroupLabel('Simulated viewport'),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final preset in _viewportPresets)
            ChoiceChip(
              key: ValueKey('lab-preset-${preset.id}'),
              label: Text(preset.label),
              visualDensity: VisualDensity.compact,
              selected: size == preset.size,
              onSelected: (_) {
                onWidthChanged(preset.size.width);
                onHeightChanged(preset.size.height);
              },
            ),
        ],
      ),
      const SizedBox(height: 8),
      _LabSlider(
        key: const ValueKey('lab-width-slider'),
        label: 'Width',
        value: simulatedWidth,
        min: _labMinSimulatedExtent,
        max: _labMaxSimulatedWidth,
        resolved: resolved,
        feedbackKey: const ValueKey('lab-width-feedback'),
        drives: _widthDrives,
        onChanged: onWidthChanged,
      ),
      _LabSlider(
        key: const ValueKey('lab-height-slider'),
        label: 'Height',
        value: simulatedHeight,
        min: _labMinSimulatedExtent,
        max: _labMaxSimulatedHeight,
        resolved: resolved,
        feedbackKey: const ValueKey('lab-height-feedback'),
        drives: _heightDrives,
        onChanged: onHeightChanged,
      ),
      const SizedBox(height: 4),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ViewportThumbnail(size: size, widthDrives: _widthDrives),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${size.width.toStringAsFixed(0)} × ${size.height.toStringAsFixed(0)}',
                  key: const ValueKey('lab-preview-size'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _dimensionExplanation,
                  key: const ValueKey('lab-dimension-explanation'),
                  style: const TextStyle(
                    color: Color(0xffd9e2ec),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const _LabGroupLabel('RFS settings'),
      _LabSlider(
        key: const ValueKey('lab-base-slider'),
        label: 'Base',
        value: baseValue,
        min: 4,
        max: 32,
        resolved: resolved,
        feedbackKey: const ValueKey('lab-base-feedback'),
        onChanged: onBaseChanged,
      ),
      _LabSlider(
        key: const ValueKey('lab-breakpoint-slider'),
        label: 'Breakpoint',
        value: breakpoint,
        min: 400,
        max: 1600,
        resolved: resolved,
        feedbackKey: const ValueKey('lab-breakpoint-feedback'),
        onChanged: onBreakpointChanged,
      ),
      _LabSlider(
        key: const ValueKey('lab-factor-slider'),
        label: 'Factor',
        value: factor,
        min: 2,
        max: 20,
        resolved: resolved,
        feedbackKey: const ValueKey('lab-factor-feedback'),
        onChanged: onFactorChanged,
      ),
    ],
  );

  String get _dimensionExplanation {
    final clamped = extent >= breakpoint;
    final driver = _widthDrives ? 'Width' : 'Height';
    final suffix = clamped ? ' The value is clamped at the breakpoint.' : '';
    if (dimension == RfsDimension.width) {
      return 'Width drives the value; height only changes the viewport shape.$suffix';
    }
    return 'Shortest side wins: $driver drives the value right now.$suffix';
  }
}

class _LabGroupLabel extends StatelessWidget {
  const _LabGroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Color(0xff829ab1),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    ),
  );
}

class _ViewportThumbnail extends StatelessWidget {
  const _ViewportThumbnail({required this.size, required this.widthDrives});

  static const _accent = Color(0xff6fd6e8);
  static const _scale = 100 / _labMaxSimulatedWidth;

  final Size size;
  final bool widthDrives;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('lab-viewport-thumbnail'),
    width: size.width * _scale,
    height: size.height * _scale,
    decoration: BoxDecoration(
      color: const Color(0x1ad9f0f2),
      border: Border.all(color: const Color(0xff627d98)),
      borderRadius: BorderRadius.circular(3),
    ),
    child: Align(
      alignment: widthDrives ? Alignment.bottomCenter : Alignment.centerLeft,
      child: Container(
        width: widthDrives ? double.infinity : 3,
        height: widthDrives ? 3 : double.infinity,
        color: _accent,
      ),
    ),
  );
}

class _LabDetails extends StatelessWidget {
  const _LabDetails({
    required this.maxValue,
    required this.minimum,
    required this.extent,
    required this.breakpoint,
    required this.resolved,
    required this.size,
    required this.dimension,
    required this.enabled,
  });

  final double maxValue;
  final double minimum;
  final double extent;
  final double breakpoint;
  final double resolved;
  final Size size;
  final RfsDimension dimension;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('lab-details'),
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xff1d405d),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${maxValue.toStringAsFixed(0)} → ${resolved.toStringAsFixed(1)} logical px',
          key: const ValueKey('lab-resolved-value'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            _LabStat('max', maxValue),
            _LabStat('derived min', minimum),
            _LabStat('extent', extent, key: const ValueKey('lab-stat-extent')),
            _LabStat('breakpoint', breakpoint),
            _LabStat(
              'size',
              '${size.width.toStringAsFixed(0)} × ${size.height.toStringAsFixed(0)}',
            ),
            _LabStat(
              'mode',
              dimension == RfsDimension.width ? 'Width' : 'Shortest',
            ),
            _LabStat('state', enabled ? 'Enabled' : 'Disabled'),
          ],
        ),
      ],
    ),
  );
}

class _LabStat extends StatelessWidget {
  const _LabStat(this.label, this.value, {super.key});

  final String label;
  final Object value;

  @override
  Widget build(BuildContext context) => Text(
    '$label: ${value is num ? (value as num).toStringAsFixed(1) : value}',
    style: const TextStyle(color: Color(0xffd9e2ec), fontSize: 12),
  );
}

class _LabPreview extends StatelessWidget {
  const _LabPreview({
    required this.fontSize,
    required this.padding,
    required this.radius,
    required this.shadow,
  });

  final double fontSize;
  final EdgeInsets padding;
  final BorderRadius radius;
  final BoxShadow shadow;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        key: const ValueKey('lab-preview'),
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          boxShadow: [shadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: fontSize * 1.05,
                  height: fontSize * 1.05,
                  decoration: const BoxDecoration(
                    color: Color(0xffd9f0f2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.waves_rounded,
                    color: RfsExampleShowcase._blue,
                    size: fontSize * 0.55,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.more_horiz_rounded,
                  color: const Color(0xffbcccdc),
                  size: (fontSize * 0.4).clamp(16, 26),
                ),
              ],
            ),
            SizedBox(height: fontSize * 0.35),
            Text(
              'Inbox',
              key: const ValueKey('lab-preview-text'),
              maxLines: 1,
              style: TextStyle(
                color: RfsExampleShowcase._ink,
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                height: 1.0,
              ),
            ),
            SizedBox(height: (fontSize * 0.2).clamp(6, 14)),
            Text(
              'Every size on this card — type, avatar, gaps, corners, shadow — follows the resolved value.',
              style: TextStyle(
                color: RfsExampleShowcase._muted,
                fontSize: (fontSize / 3).clamp(12, 17),
                height: 1.4,
              ),
            ),
            SizedBox(height: (fontSize * 0.35).clamp(10, 24)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip('Font ${fontSize.toStringAsFixed(1)}px', filled: true),
                _chip('Inset ${padding.left.toStringAsFixed(1)}px'),
                _chip('Corners ${radius.topLeft.x.toStringAsFixed(1)}px'),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Rendered at 1:1 — nothing on the card is scaled down.',
        style: TextStyle(color: Color(0xffbcccdc), fontSize: 12),
      ),
    ],
  );

  Widget _chip(String label, {bool filled = false}) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: (fontSize * 0.35).clamp(10, 20),
      vertical: (fontSize * 0.18).clamp(5, 11),
    ),
    decoration: BoxDecoration(
      color: filled ? RfsExampleShowcase._blue : Colors.white,
      border: filled ? null : Border.all(color: const Color(0xffbcccdc)),
      borderRadius: BorderRadius.circular(radius.topLeft.x * 0.55 + 2),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: filled ? Colors.white : RfsExampleShowcase._muted,
        fontSize: (fontSize / 4).clamp(11, 14),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _ApiShowcase extends StatefulWidget {
  const _ApiShowcase({required this.width});

  final double width;

  @override
  State<_ApiShowcase> createState() => _ApiShowcaseState();
}

class _ApiShowcaseState extends State<_ApiShowcase> {
  bool _rtl = false;
  bool _largeText = false;

  @override
  Widget build(BuildContext context) {
    final theme = const RfsTypography(
      dimension: RfsDimension.shortestSide,
    ).textTheme(width: widget.width, height: MediaQuery.sizeOf(context).height);
    final content = RfsBox(
      directionalPadding: const RfsEdgeInsetsDirectional(
        start: RfsValue(max: 28, min: 18),
        end: RfsValue(max: 20, min: 12),
        top: RfsValue(max: 24, min: 16),
        bottom: RfsValue(max: 24, min: 16),
      ),
      directionalBorderRadius: const RfsBorderRadiusDirectional(
        topStart: RfsRadius(RfsValue(max: 28, min: 16)),
        bottomEnd: RfsRadius(RfsValue(max: 28, min: 16)),
      ),
      boxShadows: const [
        RfsBoxShadow(
          offset: RfsOffset(dx: RfsValue(max: 12), dy: RfsValue(max: 10)),
          blurRadius: RfsValue(max: 28, min: 12),
          spreadRadius: RfsValue(max: 1),
        ),
        RfsBoxShadow(
          color: Color(0x1400a6a6),
          blurRadius: RfsValue(max: 48, min: 20),
        ),
      ],
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Typed Flutter API', style: theme.titleLarge),
          const SizedBox(height: 8),
          RfsText.rich(
            const TextSpan(
              text: 'Directional spacing, ',
              children: [
                TextSpan(
                  text: 'rich text',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ', and multiple shadows.'),
              ],
            ),
            maxFontSize: 22,
            minFontSize: 16,
            semanticsIdentifier: 'api-showcase-copy',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Chip(label: Text(_rtl ? 'RTL corners' : 'LTR corners')),
              Chip(
                label: Text(_largeText ? 'Text scale 1.3×' : 'Ambient scale'),
              ),
              Chip(label: Text('shortest-side theme')),
            ],
          ),
        ],
      ),
    );
    final scaled = MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(_largeText ? 1.3 : 1)),
      child: content,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Build once, adapt everywhere',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            FilterChip(
              label: Text(_rtl ? 'RTL' : 'LTR'),
              selected: _rtl,
              onSelected: (value) => setState(() => _rtl = value),
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('A11y'),
              selected: _largeText,
              onSelected: (value) => setState(() => _largeText = value),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Directionality(
          textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
          child: scaled,
        ),
      ],
    );
  }
}

class _LabSlider extends StatelessWidget {
  const _LabSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.resolved,
    required this.feedbackKey,
    this.drives = true,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final double resolved;
  final Key feedbackKey;
  final bool drives;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 128,
        child: Text(
          '$label ${value.toStringAsFixed(0)}',
          style: TextStyle(
            color: drives ? Colors.white : const Color(0xff829ab1),
          ),
        ),
      ),
      Expanded(
        child: Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          semanticFormatterCallback: (value) =>
              '$label ${value.toStringAsFixed(0)}; resolved ${resolved.toStringAsFixed(1)}',
        ),
      ),
      SizedBox(
        width: 56,
        child: Text(
          drives ? '→${resolved.toStringAsFixed(1)}' : '',
          key: feedbackKey,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Color(0xffd9e2ec), fontSize: 11),
        ),
      ),
    ],
  );
}
