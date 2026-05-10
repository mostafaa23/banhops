import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../main.dart';
import '../l10n/app_localizations.dart';

// ✅ HistoryService — استبدل الـ URL بالـ backend بتاعك
class HistoryService {
  static Future<List<dynamic>> fetchHistory() async {
    // TODO: استبدل بـ http call حقيقي
    // مثال:
    // final response = await http.get(Uri.parse('https://your-api.com/history'));
    // if (response.statusCode == 200) return jsonDecode(response.body) as List;
    // throw Exception('Failed to load history');
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}

class HistoryScreen extends StatefulWidget {
  final ValueChanged<NavTab> onNavigate;
  final List<TripHistoryItem> trips;
  final VoidCallback onClearHistory;

  const HistoryScreen({
    super.key,
    required this.onNavigate,
    required this.trips,
    required this.onClearHistory,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  // ✅ initState
  @override
  void initState() {
    super.initState();

    HistoryService.fetchHistory()
        .then((data) {
      print("DATA FROM BACKEND:");
      print(data);
    })
        .catchError((e) {
      print("ERROR:");
      print(e);
    });
  }

  String _formatDate(DateTime d) => '${d.month}/${d.day}/${d.year}';

  void _confirmClear() async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l10n.clearHistory,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Text(l10n.clearHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.clear,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (ok == true) widget.onClearHistory();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Column(
            children: [
              // ── Header ──────────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.tripHistory,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.myTrips,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (widget.trips.isNotEmpty)
                      GestureDetector(
                        onTap: _confirmClear,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFFEE2E2),
                            ),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Color(0xFFEF4444),
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Content ──────────────────────────────────
              Expanded(
                child: widget.trips.isEmpty
                    ? _emptyState(l10n)
                    : _tripList(),
              ),
            ],
          ),

          // ── Bottom Nav ───────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              active: NavTab.history,
              onTap: widget.onNavigate,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────
  Widget _emptyState(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history,
                size: 80,
                color: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.noTripsYet,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.startPlanning,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Trip List ────────────────────────────────────────────
  Widget _tripList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
      itemCount: widget.trips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _TripCard(
        trip: widget.trips[i],
        formatDate: _formatDate,
      ),
    );
  }
}

// ── Trip Card ────────────────────────────────────────────────
class _TripCard extends StatefulWidget {
  final TripHistoryItem trip;
  final String Function(DateTime) formatDate;

  const _TripCard({required this.trip, required this.formatDate});

  @override
  State<_TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<_TripCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: _hovered ? 0.10 : 0.04,
              ),
              blurRadius: _hovered ? 20 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Column(
            children: [
              // ── Card Content ──────────────────────────
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [

                    // FROM → TO Row
                    Row(
                      children: [
                        // FROM
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.from.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textMuted,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.trip.from,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Arrow
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _hovered
                                ? AppColors.primary
                                : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: _hovered ? Colors.white : AppColors.primary,
                            size: 22,
                          ),
                        ),

                        // TO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                l10n.to.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textMuted,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.trip.to,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Line + Date Row
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Row(
                        children: [
                          // Train icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.train,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Line info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.line.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textMuted,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.trip.line,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Date badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.grey.shade100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.formatDate(widget.trip.date),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Gradient bottom accent
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 6,
                decoration: BoxDecoration(
                  gradient: _hovered
                      ? const LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF2563EB)],
                  )
                      : const LinearGradient(
                    colors: [Colors.transparent, Colors.transparent],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}