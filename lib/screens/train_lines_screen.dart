import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';

class TrainLine {
  final String id;
  final String name;
  final Color color;
  final String icon;
  final List<String> stations;

  const TrainLine({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.stations,
  });
}

class TrainLinesScreen extends StatefulWidget {
  final ValueChanged<NavTab> onNavigate;

  const TrainLinesScreen({super.key, required this.onNavigate});

  @override
  State<TrainLinesScreen> createState() => _TrainLinesScreenState();
}

class _TrainLinesScreenState extends State<TrainLinesScreen> {
  static const _lines = <TrainLine>[
    TrainLine(
      id: 'line1',
      name: 'Line 1 — Cairo / Benha',
      color: Color(0xFF4A90E2),
      icon: '🏙️',
      stations: ['Cairo', 'Qalyub', 'Banha'],
    ),
    TrainLine(
      id: 'line2',
      name: 'Line 2 — Tanta / Benha',
      color: Color(0xFFE53935),
      icon: '🚜',
      stations: ['Tanta', 'Shebin', 'Banha'],
    ),
    TrainLine(
      id: 'line3',
      name: 'Line 3 — Mansoura / Benha',
      color: Color(0xFF43A047),
      icon: '🌾',
      stations: ['Mansoura', 'Zagazig', 'Banha'],
    ),
    TrainLine(
      id: 'line4',
      name: 'Line 4 — Minya / Benha',
      color: Color(0xFFFB8C00),
      icon: '⛰️',
      stations: ['Minya', 'Beni Suef', 'Cairo', 'Banha'],
    ),
    TrainLine(
      id: 'line5',
      name: 'Line 5 — Alexandria / Benha',
      color: Color(0xFF8E24AA),
      icon: '🌊',
      stations: ['Alexandria', 'Damanhur', 'Tanta', 'Banha'],
    ),
  ];

  static const _cities = [
    {'name': 'Assiut - Benha',       'line': 'line1'},
    {'name': 'Alexandria - Benha',   'line': 'line5'},
    {'name': 'Ismailia - Benha',     'line': 'line1'},
    {'name': 'Luxor - Benha',        'line': 'line4'},
    {'name': 'Beheira - Benha',      'line': 'line5'},
    {'name': 'Zagazig - Benha',      'line': 'line3'},
    {'name': 'Suez - Benha',         'line': 'line1'},
    {'name': 'Fayoum - Benha',       'line': 'line4'},
    {'name': 'Cairo - Benha',        'line': 'line1'},
    {'name': 'Mansoura - Benha',     'line': 'line3'},
    {'name': 'Minya - Benha',        'line': 'line4'},
    {'name': 'Sohag - Benha',        'line': 'line4'},
    {'name': 'Tanta - Benha',        'line': 'line2'},
    {'name': 'Damietta - Benha',     'line': 'line3'},
    {'name': 'Matrouh - Benha',      'line': 'line5'},
  ];

  TrainLine? _selectedLine;

  TrainLine _findLine(String id) => _lines.firstWhere((l) => l.id == id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOut,
                    child: _selectedLine == null
                        ? _buildPicker()
                        : _buildDetails(_selectedLine!),
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
              active: NavTab.trainLines,
              onTap: widget.onNavigate,
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────
  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.trainLines,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.journeyToBenhaStartsHere,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (_selectedLine != null)
            GestureDetector(
              onTap: () => setState(() => _selectedLine = null),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      l10n.backToSelection,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Picker View ─────────────────────────────────────────────
  Widget _buildPicker() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey('picker'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Map Card ──────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.trainMap,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFullMap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.zoom_in,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            l10n.tapToZoom,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showFullMap,
                child: AspectRatio(
                  aspectRatio: 21 / 7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/map.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // ── City Chips Grid ──────────────────────────────────
        Text(
          l10n.chooseYourRoute,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        ..._cities.map(
          (city) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RouteCard(
              name: city['name']!,
              onTap: () => setState(
                () => _selectedLine = _findLine(city['line']!),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Details View ─────────────────────────────────────────────
  Widget _buildDetails(TrainLine line) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      key: ValueKey(line.id),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Colored Header ───────────────────────────────
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: line.color,
            ),
            child: Stack(
              children: [
                // Glow circle decoration
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(line.icon,
                        style: const TextStyle(fontSize: 48)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            line.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.allTripsEndAtBenha,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Destination badge
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      l10n.destinationBenha,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Stations ─────────────────────────────────────
          Padding(
            padding:
            const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(
              children: [
                ...List.generate(line.stations.length, (i) {
                  final isLast = i == line.stations.length - 1;
                  return _StationRow(
                    station: line.stations[i],
                    index: i,
                    isLast: isLast,
                    showConnector: i < line.stations.length - 1,
                    color: line.color,
                  );
                }),
                const SizedBox(height: 28),

                // ── Book Button ───────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () => widget.onNavigate(NavTab.home),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black38,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.getRoutes,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Full Map Dialog ──────────────────────────────────────────
  void _showFullMap() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (_) => Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 8,
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.4),
                      Colors.purple.withValues(alpha: 0.3),
                    ],
                  ),
                ),
                width: 600,
                height: 400,
                alignment: Alignment.center,
                // ✅ Replace with Image.asset when train map image is ready
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/map.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Route Card ────────────────────────────────────────────────────
class _RouteCard extends StatefulWidget {
  final String name;
  final VoidCallback onTap;

  const _RouteCard({required this.name, required this.onTap});

  @override
  State<_RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<_RouteCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // ── استخرج المدينة الأولى من "X - بنها"
    final city = widget.name.split(' - ').first.trim();

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _pressed ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _pressed ? AppColors.primary : const Color(0xFFF3F4F6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _pressed
                    ? AppColors.primary
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.train,
                color: _pressed ? Colors.white : AppColors.primary,
                size: 22,
              ),
            ),

            const SizedBox(width: 16),

            // Route text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.startingFrom(city),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _pressed
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: _pressed ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Station Row ──────────────────────────────────────────────────
class _StationRow extends StatelessWidget {
  final String station;
  final int index;
  final bool isLast;
  final bool showConnector;
  final Color color;

  const _StationRow({
    required this.station,
    required this.index,
    required this.isLast,
    required this.showConnector,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left track column ──────────────────────────
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isLast ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isLast
                      ? Border.all(
                      color: Colors.green.shade100, width: 6)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: isLast
                    ? const Icon(Icons.location_on,
                    color: Colors.white, size: 26)
                    : Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ),
              if (showConnector)
                Expanded(
                  child: Container(
                    width: 4,
                    color: const Color(0xFFF3F4F6),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 20),

          // ── Station info ────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isLast
                                ? Colors.green
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isLast
                              ? l10n.finalArrival
                              : l10n.stationNumber(index + 1),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLast)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.liveBadge,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
