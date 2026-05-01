import 'package:flutter/material.dart';
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
    {'name': 'Cairo', 'line': 'line1'},
    {'name': 'Tanta', 'line': 'line2'},
    {'name': 'Mansoura', 'line': 'line3'},
    {'name': 'Minya', 'line': 'line4'},
    {'name': 'Alexandria', 'line': 'line5'},
    {'name': 'Zagazig', 'line': 'line3'},
    {'name': 'Shebin', 'line': 'line2'},
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

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Train Lines',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your journey to Benha starts here',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_selectedLine != null)
            IconButton(
              onPressed: () => setState(() => _selectedLine = null),
              icon: const Icon(Icons.arrow_back),
            ),
        ],
      ),
    );
  }

  Widget _buildPicker() {
    return Column(
      key: const ValueKey('picker'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Map preview placeholder card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
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
                      'Train Map',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.zoom_in, size: 16, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Tap to zoom',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showFullMap,
                child: AspectRatio(
                  aspectRatio: 21 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.15),
                          Colors.purple.withOpacity(0.1),
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Text(
          'Where are you coming from?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _cities.map((city) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 64) / 2,
              child: GestureDetector(
                onTap: () => setState(
                  () => _selectedLine = _findLine(city['line']!),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        child: const Text('📍',
                            style: TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        city['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),
        const Text(
          'Or select a line directly',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ..._lines.map((line) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedLine = line),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
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
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(line.icon,
                          style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            line.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${line.stations.length} STATIONS',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF6FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDetails(TrainLine line) {
    return Container(
      key: ValueKey(line.id),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: line.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
            ),
            child: Row(
              children: [
                Text(line.icon, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'All trips end at Benha Station',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => widget.onNavigate(NavTab.home),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Book Ticket Now',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
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

  void _showFullMap() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (_) => Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 6,
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.4),
                      Colors.purple.withOpacity(0.3),
                    ],
                  ),
                ),
                width: 600,
                height: 400,
                alignment: Alignment.center,
                child: const Text(
                  '🚆 Train Map',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isLast ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    ? const Icon(Icons.location_on,
                        color: Colors.white, size: 24)
                    : Container(
                        width: 16,
                        height: 16,
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
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
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
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLast)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              margin: const EdgeInsets.only(top: 12),
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
                ),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
