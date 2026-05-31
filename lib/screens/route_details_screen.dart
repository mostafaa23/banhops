import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class RouteOption {
  final int id;
  final String name;
  final String routeType; // 'microbus' or 'train'
  final String time;
  final String cost;
  final IconData icon;
  final bool isBest;
  final String description;
  final String pros;
  final String cons;

  const RouteOption({
    required this.id,
    required this.name,
    required this.routeType,
    required this.time,
    required this.cost,
    required this.icon,
    required this.isBest,
    required this.description,
    required this.pros,
    required this.cons,
  });
}

class RouteDetailsScreen extends StatefulWidget {
  final String from;
  final String to;
  final VoidCallback onBack;
  final void Function(String from, String to, String? routeType) onOpenChat;

  const RouteDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.onBack,
    required this.onOpenChat,
  });

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  int? _selectedRouteId;

  static const _options = [
    RouteOption(
      id: 1,
      name: 'Direct Microbus (Moassasa)',
      routeType: 'microbus',
      time: '45–60 min',
      cost: '15–20 EGP',
      icon: Icons.directions_bus_rounded,
      isBest: true,
      description:
      'From Moassasa station, you will find direct microbuses to Benha.',
      pros: 'Direct, cheap, and available all day.',
      cons: 'May be crowded during peak hours.',
    ),
    RouteOption(
      id: 2,
      name: 'Train (Nearby Station)',
      routeType: 'train',
      time: '50 min',
      cost: '50–120 EGP',
      icon: Icons.train_rounded,
      isBest: false,
      description:
      'Take the train from Ramses or Shubra El-Kheima to Benha.',
      pros: 'Comfortable and pleasant if you want to avoid crowds.',
      cons: 'You need to reach the station first, which adds time.',
    ),
  ];

  String? get _selectedRouteType => _options
      .where((o) => o.id == _selectedRouteId)
      .map((o) => o.routeType)
      .firstOrNull;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────
          _Header(from: widget.from, to: widget.to, onBack: widget.onBack, l10n: l10n),

          // ── Content ─────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section label
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.transportationOptions.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),

                      // Selection hint
                      if (_selectedRouteId == null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Tap a card to select your preferred route',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Route cards
                      ..._options.map(
                            (o) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _OptionCard(
                            option: o,
                            l10n: l10n,
                            isSelected: _selectedRouteId == o.id,
                            onTap: () => setState(() {
                              _selectedRouteId =
                              _selectedRouteId == o.id ? null : o.id;
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Floating Chat Button ─────────────────
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  child: _ChatButton(
                    onTap: () => widget.onOpenChat(
                      widget.from,
                      widget.to,
                      _selectedRouteType,
                    ),
                    l10n: l10n,
                    selectedRouteType: _selectedRouteType,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final String from;
  final String to;
  final VoidCallback onBack;
  final AppLocalizations l10n;

  const _Header({
    required this.from,
    required this.to,
    required this.onBack,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.routeDetails,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      from,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.70),
                      ),
                    ),
                    Text(
                      to,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

// ── Option Card ───────────────────────────────────────────────────
class _OptionCard extends StatelessWidget {
  final RouteOption option;
  final AppLocalizations l10n;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.option,
    required this.l10n,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBest = option.isBest;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEFF6FF)   // blue-50
              : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)  // blue-700
                : isBest
                ? AppColors.primary.withValues(alpha: 0.40)
                : const Color(0xFFF3F4F6),
            width: isSelected ? 2 : (isBest ? 1.5 : 1),
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: const Color(0xFFDBEAFE).withValues(alpha: 0.80),
              blurRadius: 0,
              offset: const Offset(0, 0),
              spreadRadius: 4,
            ),
          ]
              : [
            BoxShadow(
              color: isBest
                  ? AppColors.primary.withValues(alpha: 0.10)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isBest ? 24 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Best match tint
            if (isBest && !isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top spacing for badge
                  if (isBest) const SizedBox(height: 10),

                  // ── Icon + Name + Chips ─────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : isBest
                              ? AppColors.primary
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: (isBest || isSelected)
                              ? [
                            BoxShadow(
                              color: (isSelected
                                  ? const Color(0xFF2563EB)
                                  : AppColors.primary)
                                  .withValues(alpha: 0.30),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                              : null,
                        ),
                        child: Icon(
                          option.icon,
                          color: (isBest || isSelected)
                              ? Colors.white
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                _Chip(
                                  icon: Icons.schedule_rounded,
                                  label: option.time,
                                  bgColor: const Color(0xFFFFF7ED),
                                  textColor: const Color(0xFFEA580C),
                                ),
                                _Chip(
                                  icon: Icons.payments_rounded,
                                  label: option.cost,
                                  bgColor: const Color(0xFFF0FDF4),
                                  textColor: const Color(0xFF16A34A),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Selected checkmark
                      if (isSelected)
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 14),

                  // Description
                  Text(
                    option.description,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Pros
                  _ProsConsRow(
                    icon: Icons.check_circle_outline_rounded,
                    label: option.pros,
                    isPositive: true,
                  ),
                  const SizedBox(height: 8),

                  // Cons
                  _ProsConsRow(
                    icon: Icons.cancel_outlined,
                    label: option.cons,
                    isPositive: false,
                  ),
                ],
              ),
            ),

            // Best Match Badge
            if (isBest)
              Positioned(
                top: 0,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded,
                          color: Colors.white, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        l10n.bestMatch.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Chip ──────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color textColor;

  const _Chip({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pros/Cons Row ─────────────────────────────────────────────────
class _ProsConsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPositive;

  const _ProsConsRow({
    required this.icon,
    required this.label,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color =
    isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final bgColor =
    isPositive ? const Color(0xFFF0FDF4) : const Color(0xFFFFF1F2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 13, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Chat Button ───────────────────────────────────────────────────
class _ChatButton extends StatefulWidget {
  final VoidCallback onTap;
  final AppLocalizations l10n;
  final String? selectedRouteType;

  const _ChatButton({
    required this.onTap,
    required this.l10n,
    required this.selectedRouteType,
  });

  @override
  State<_ChatButton> createState() => _ChatButtonState();
}

class _ChatButtonState extends State<_ChatButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final hasRoute = widget.selectedRouteType != null;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF4A90E2), Color(0xFF2563EB)],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.l10n.chatWithAI,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    // ✅ hint تتغير حسب لو اتختار مسار
                    hasRoute
                        ? 'Get your step-by-step itinerary'
                        : widget.l10n.readyToHelp,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.70),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}