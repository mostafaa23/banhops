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
  // ✅ All 20 JSON lines structured and merged into 6 main core tracks
  List<TrainLine> _getLines(AppLocalizations l10n) => [
    TrainLine(
      id: 'TRAIN_CAIRO_GIZA_BENHA',
      name: l10n.trainLineCairoGiza,
      color: const Color(0xFF4A90E2), // Tito's Signature Blue
      icon: '🏙️',
      stations: const ['Giza', 'Cairo', 'Shobra El-Kheima', 'Qalyoub', 'Qaha', 'Benha'],
    ),
    TrainLine(
      id: 'TRAIN_ALEX_SIDI_BENHA',
      name: l10n.trainLineAlexandria,
      color: const Color(0xFF8E24AA),
      icon: '🌊',
      stations: const ['Alexandria', 'Sidi Gaber', 'Kafr El-Dawar', 'Damanhour', 'Itay El-Baroud', 'Kafr El-Zayat', 'Tanta', 'Birket El-Sab', 'Quesna', 'Toukh', 'Benha'],
    ),
    TrainLine(
      id: 'TRAIN_MANSOURA_DOMIAT_BENHA',
      name: l10n.trainLineDamietta,
      color: const Color(0xFF43A047),
      icon: '🌾',
      stations: const ['Damietta', 'Kafr Saad', 'Sherbin', 'Talkha', 'Mansoura', 'Samannoud', 'Mahallat Rouh', 'Tanta', 'Birket El-Sab', 'Quesna', 'Toukh', 'Benha'],
    ),
    TrainLine(
      id: 'TRAIN_MENOUF_TANTA_BENHA',
      name: l10n.trainLineCentralDelta,
      color: const Color(0xFF00ACC1),
      icon: '🌳',
      stations: const ['Menouf', 'Sers El-Lyan', 'Kafr Shobra Zangi', 'Jarwan', 'El-Bagour', 'Sobk El-Dahak', 'Mit El-Wasta', 'Estanha', 'Tanta', 'Birket El-Sab', 'Quesna', 'Toukh', 'Kafr Bata', 'Benha'],
    ),
    TrainLine(
      id: 'TRAIN_EAST_CANAL_BENHA',
      name: l10n.trainLineCanal,
      color: const Color(0xFFFB8C00),
      icon: '🚢',
      stations: const [
        'Suez', 'Ismailia', 'Moaskar El-Jalaa', 'Nafisha', 'El-Wasfeya', 'Abu Suweir', 'Abu Jreish',
        'Mohamed Baghdadi', 'El-Mahsama', 'El-Qassassin', 'El-Baalwa', 'El-Tell El-Kebir', 'Mahjar Abu Hammad',
        'Abu Hammad', 'El-Sowa', 'Safat El-Henna', 'El-Shabanat', 'Zagazig', 'El-Zankaloun', 'El-Qaraqra',
        'El-Jadida', 'Minya El-Qamh', 'Mit Yazid', 'Koum Hallin', 'El-Azizia', 'Sheblanga', 'Minyet El-Seba', 'Kafr El-Gazzar', 'Benha'
      ],
    ),
    TrainLine(
      id: 'TRAIN_UPPER_EGYPT_BENHA',
      name: l10n.trainLineUpperEgypt,
      color: const Color(0xFFE53935),
      icon: '⛰️',
      stations: const ['Aswan', 'Luxor', 'Qena', 'Sohag', 'Assiut', 'Minya', 'Beni Suef', 'El-Wasta', 'El-Ayyat', 'Giza', 'Cairo', 'Benha'],
    ),
  ];

  // ✅ Mapping the 20 customizable start cities to their respective Seeder route_ids
  static const _cities = [
    {'name': 'Cairo - Benha',       'line': 'TRAIN_CAIRO_GIZA_BENHA', 'route_id': 'TRAIN_CAIRO_BENHA'},
    {'name': 'Giza - Benha',        'line': 'TRAIN_CAIRO_GIZA_BENHA', 'route_id': 'TRAIN_GIZA_BENHA'},
    {'name': 'Alexandria - Benha',   'line': 'TRAIN_ALEX_SIDI_BENHA',  'route_id': 'TRAIN_ALEX_BENHA'},
    {'name': 'Sidi Gaber - Benha',    'line': 'TRAIN_ALEX_SIDI_BENHA',  'route_id': 'TRAIN_SIDIGABER_BENHA'},
    {'name': 'Damanhour - Benha',      'line': 'TRAIN_ALEX_SIDI_BENHA',  'route_id': 'TRAIN_DAMANHOUR_BENHA'},
    {'name': 'Damietta - Benha',       'line': 'TRAIN_MANSOURA_DOMIAT_BENHA', 'route_id': 'TRAIN_DOMIAT_BENHA'},
    {'name': 'Mansoura - Benha',     'line': 'TRAIN_MANSOURA_DOMIAT_BENHA', 'route_id': 'TRAIN_MANSOURA_BENHA'},
    {'name': 'Tanta - Benha',        'line': 'TRAIN_MENOUF_TANTA_BENHA', 'route_id': 'TRAIN_TANTA_BENHA'},
    {'name': 'Menouf - Benha',        'line': 'TRAIN_MENOUF_TANTA_BENHA', 'route_id': 'TRAIN_MENOUF_BENHA'},
    {'name': 'Zagazig - Benha',     'line': 'TRAIN_EAST_CANAL_BENHA', 'route_id': 'TRAIN_ZAGAZIG_BENHA'},
    {'name': 'Ismailia - Benha',   'line': 'TRAIN_EAST_CANAL_BENHA', 'route_id': 'TRAIN_ISMAILIA_BENHA'},
    {'name': 'Suez - Benha',       'line': 'TRAIN_EAST_CANAL_BENHA', 'route_id': 'TRAIN_SUEZ_BENHA'},
    {'name': 'Beni Suef - Benha',     'line': 'TRAIN_UPPER_EGYPT_BENHA', 'route_id': 'TRAIN_BENISUEF_BENHA'},
    {'name': 'Minya - Benha',        'line': 'TRAIN_UPPER_EGYPT_BENHA', 'route_id': 'TRAIN_MINYA_BENHA'},
    {'name': 'Assiut - Benha',       'line': 'TRAIN_UPPER_EGYPT_BENHA', 'route_id': 'TRAIN_ASSIUT_BENHA'},
    {'name': 'Sohag - Benha',       'line': 'TRAIN_UPPER_EGYPT_BENHA', 'route_id': 'TRAIN_SOHAG_BENHA'},
    {'name': 'Qena - Benha',         'line': 'TRAIN_UPPER_EGYPT_BENHA', 'route_id': 'TRAIN_QENA_BENHA'},
    {'name': 'Luxor - Benha',       'line': 'TRAIN_UPPER_EGYPT_BENHA', 'route_id': 'TRAIN_LUXOR_BENHA'},
    {'name': 'Aswan - Benha',       'line': 'TRAIN_UPPER_EGYPT_BENHA', 'route_id': 'TRAIN_ASWAN_BENHA'},
  ];

  TrainLine? _selectedLine;
  String? _filterRouteId;
  late List<TrainLine> _lines;

  TrainLine _findLine(String id) => _lines.firstWhere((l) => l.id == id);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _lines = _getLines(l10n);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(l10n),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOut,
                    child: _selectedLine == null
                        ? _buildPicker()
                        : _buildDetails(_selectedLine!, _filterRouteId!),
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
  Widget _buildHeader(AppLocalizations l10n) {
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
                    fontFamily: 'Cairo',
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
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          if (_selectedLine != null)
            GestureDetector(
              onTap: () => setState(() {
                _selectedLine = null;
                _filterRouteId = null;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        fontFamily: 'Cairo',
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
                color: Colors.black.withOpacity(0.05),
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
                  const Expanded(
                    child: Text(
                      'Railway Map',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Cairo',
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFullMap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.zoom_in, size: 16, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'Tap to Zoom',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              fontFamily: 'Cairo',
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

        const Text(
          'Choose Your Route',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            fontFamily: 'Cairo',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        ..._cities.map(
              (city) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RouteCard(
              name: city['name']!,
              onTap: () => setState(() {
                _selectedLine = _findLine(city['line']!);
                _filterRouteId = city['route_id'];
              }),
            ),
          ),
        ),
      ],
    );
  }

  // ── Details View ─────────────────────────────────────────────
  Widget _buildDetails(TrainLine line, String routeId) {
    // Dynamic filter logic cutting off prior stations depending on chosen JSON route
    final startStationName = _cities.firstWhere((c) => c['route_id'] == routeId)['name']!.split(' - ').first.trim();
    final startIndex = line.stations.indexOf(startStationName);
    final filteredStations = startIndex != -1 ? line.stations.sublist(startIndex) : line.stations;

    return Container(
      key: ValueKey(routeId),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Station Line Gradient/Colored Block
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: line.color),
            child: Stack(
              children: [
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.10),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(line.icon, style: const TextStyle(fontSize: 48)),
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
                              fontFamily: 'Cairo',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'All trips terminate at Benha Station',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
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

          // Benha Destination Badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, size: 16, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text(
                      'Destination: Benha',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Stations Stepper Pipeline
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(
              children: [
                ...List.generate(filteredStations.length, (i) {
                  final isLast = i == filteredStations.length - 1;
                  return _StationRow(
                    station: filteredStations[i],
                    index: i,
                    isLast: isLast,
                    showConnector: i < filteredStations.length - 1,
                    color: line.color,
                  );
                }),
                const SizedBox(height: 28),

                // Navigation trigger button
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Find Live Trips',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.arrow_forward, size: 20),
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
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (_) => Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 8,
              child: Container(
                margin: const EdgeInsets.all(24),
                width: 600,
                height: 400,
                alignment: Alignment.center,
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
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
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
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _pressed ? AppColors.primary : const Color(0xFFEFF6FF),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Cairo',
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Starting from $city',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _pressed ? AppColors.primary.withOpacity(0.15) : const Color(0xFFF8FAFC),
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
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isLast ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isLast ? Border.all(color: Colors.green.shade100, width: 6) : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: isLast
                    ? const Icon(Icons.location_on, color: Colors.white, size: 26)
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
                            fontFamily: 'Cairo',
                            color: isLast ? Colors.green : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isLast ? 'FINAL ARRIVAL' : 'STATION ${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            letterSpacing: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLast)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Cairo',
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