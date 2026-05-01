import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<NavTab> onNavigate;
  final void Function(String from, String to) onShowRouteDetails;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.onShowRouteDetails,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _fromCtrl =
  TextEditingController(text: 'Your current location');
  String? _selectedDestination;

  // ✅ إحداثيات كل وجهة
  static const Map<String, Map<String, double>> _destinationCoords = {
    'el vell':      {'lat': 30.4634, 'lng': 31.1790},
    'mokf':         {'lat': 30.4612, 'lng': 31.1820},
    'west balad':   {'lat': 30.4650, 'lng': 31.1800},
    'el mansia':    {'lat': 30.4670, 'lng': 31.1760},
    // Colleges
    'Faculty of Commerce':          {'lat': 30.4677, 'lng': 31.1838},
    'Faculty of Arts':              {'lat': 30.4680, 'lng': 31.1842},
    'Faculty of Education':         {'lat': 30.4683, 'lng': 31.1845},
    'Faculty of Specific Education':{'lat': 30.4685, 'lng': 31.1848},
    'Faculty of Physical Education':{'lat': 30.4688, 'lng': 31.1851},
    'Faculty of Law':               {'lat': 30.4690, 'lng': 31.1854},
    'Faculty of Applied Arts':      {'lat': 30.4692, 'lng': 31.1857},
  };

  static const _destinations = [
    {'ar': 'الفلل',    'en': 'el vell'},
    {'ar': 'الموقف',   'en': 'mokf'},
    {'ar': 'وسط البلد','en': 'west balad'},
    {'ar': 'المنشية',  'en': 'el mansia'},
  ];

  static const _colleges = [
    'Faculty of Commerce',
    'Faculty of Arts',
    'Faculty of Education',
    'Faculty of Specific Education',
    'Faculty of Physical Education',
    'Faculty of Law',
    'Faculty of Applied Arts',
  ];

  // ✅ فتح Google Maps
  Future<void> _openGoogleMaps(String destination) async {
    final coords = _destinationCoords[destination];
    if (coords == null) return;

    final lat = coords['lat']!;
    final lng = coords['lng']!;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    super.dispose();
  }

  void _openDestinationPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DestinationSheet(
        title: 'Select Destination',
        items: _destinations.map((e) => e['en']!).toList(),
        accent: AppColors.primary,
        icon: Icons.location_on,
      ),
    );
    if (result != null) setState(() => _selectedDestination = result);
  }

  void _openCollegePicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DestinationSheet(
        title: 'Select College',
        subtitle: 'Benha University Colleges',
        items: _colleges,
        accent: Colors.orange,
        icon: Icons.school_outlined,
      ),
    );
    if (result != null) setState(() => _selectedDestination = result);
  }

  void _handleGetRoutes() {
    if (_selectedDestination == null) return;
    widget.onShowRouteDetails(_fromCtrl.text, _selectedDestination!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Column(
            children: [
              const _BlueHeader(),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SearchCard(
                            fromController: _fromCtrl,
                            selectedDestination: _selectedDestination,
                            onTapTo: _openDestinationPicker,
                          ),

                          const SizedBox(height: 12),

                          // ✅ زرار Google Maps يظهر لما يختار وجهة
                          if (_selectedDestination != null)
                            _GoogleMapsButton(
                              destination: _selectedDestination!,
                              onTap: () => _openGoogleMaps(_selectedDestination!),
                            ),

                          const SizedBox(height: 12),

                          _GetRoutesButton(
                            enabled: _selectedDestination != null,
                            onPressed: _handleGetRoutes,
                          ),

                          const SizedBox(height: 32),

                          const Text(
                            'Popular Zones',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.1,
                            children: [
                              _ZoneCard(
                                label: 'University',
                                emoji: '🎓',
                                bgColor: const Color(0xFFFFF7ED),
                                onTap: _openCollegePicker,
                              ),
                              _ZoneCard(
                                label: 'Hospital',
                                emoji: '🏥',
                                bgColor: const Color(0xFFFEF2F2),
                                onTap: () {},
                              ),
                              _ZoneCard(
                                label: 'Restaurants',
                                emoji: '🍕',
                                bgColor: const Color(0xFFF0FDF4),
                                onTap: () {},
                              ),
                              _ZoneCard(
                                label: 'Cafés',
                                emoji: '☕',
                                bgColor: const Color(0xFFFFFBEB),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              active: NavTab.home,
              onTap: widget.onNavigate,
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ زرار Google Maps
class _GoogleMapsButton extends StatelessWidget {
  final String destination;
  final VoidCallback onTap;

  const _GoogleMapsButton({
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F4FD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF4A90E2).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.map_outlined,
                color: Color(0xFF4A90E2),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'View on Google Maps',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    destination,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4A90E2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFF4A90E2),
            ),
          ],
        ),
      ),
    );
  }
}

// ── باقي الكلاسات زي ما هي بدون تغيير ───────────────────

class _BlueHeader extends StatelessWidget {
  const _BlueHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'BanHops',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      top: -5,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  final TextEditingController fromController;
  final String? selectedDestination;
  final VoidCallback onTapTo;

  const _SearchCard({
    required this.fromController,
    required this.selectedDestination,
    required this.onTapTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FROM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: fromController,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                            ),
                            decoration: const InputDecoration(
                              filled: false,
                              isDense: true,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEFF6FF),
                          ),
                          child: const Icon(
                            Icons.search,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 13),
            child: Row(
              children: [
                _DottedLine(),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: onTapTo,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedDestination ?? 'Search destination',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: selectedDestination != null
                              ? AppColors.textPrimary
                              : AppColors.textPlaceholder,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DottedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2,
      height: 32,
      child: CustomPaint(painter: _DottedLinePainter()),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 2;
    const dashHeight = 4.0;
    const gap = 3.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + dashHeight),
        paint,
      );
      y += dashHeight + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GetRoutesButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _GetRoutesButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: enabled
                ? const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF2563EB)],
            )
                : null,
          ),
          child: Container(
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Get Routes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.arrow_forward, color: Colors.white, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final String label;
  final String emoji;
  final Color bgColor;
  final VoidCallback onTap;

  const _ZoneCard({
    required this.label,
    required this.emoji,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String> items;
  final Color accent;
  final IconData icon;

  const _DestinationSheet({
    required this.title,
    this.subtitle,
    required this.items,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => Navigator.of(context).pop(item),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Icon(icon, color: accent),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}