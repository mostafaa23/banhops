import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class RouteOption {
  final String name;
  final String time;
  final String cost;
  final IconData icon;
  final bool isBest;
  final String description;
  final String pros;
  final String cons;

  const RouteOption({
    required this.name,
    required this.time,
    required this.cost,
    required this.icon,
    required this.isBest,
    required this.description,
    required this.pros,
    required this.cons,
  });
}

class RouteDetailsScreen extends StatelessWidget {
  final String from;
  final String to;
  final VoidCallback onBack;
  final VoidCallback onOpenChat;

  const RouteDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.onBack,
    required this.onOpenChat,
  });

  static const _options = [
    RouteOption(
      name: 'Direct Microbus (Moassasa)',
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
      name: 'Train (Nearby Station)',
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      body: Stack(
        children: [
          // ── Background radial glows ────────────────────
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4A90E2).withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 260,
            right: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7C3AED).withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Content ────────────────────────────────────
          Column(
            children: [
              _ModernHeader(from: from, to: to, onBack: onBack, l10n: l10n),
              Expanded(
                child: SingleChildScrollView(
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
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF4A90E2),
                                  Color(0xFF2563EB),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.transportationOptions.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4A90E2),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Route option cards
                      ..._options.map(
                            (o) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _ModernOptionCard(option: o, l10n: l10n),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Floating bottom button ─────────────────────
          Positioned(
            left: 20,
            right: 20,
            bottom: 32,
            child: _FloatingChatButton(onTap: onOpenChat, l10n: l10n),
          ),
        ],
      ),
    );
  }
}

// ── Modern Header ─────────────────────────────────────────────────
class _ModernHeader extends StatelessWidget {
  final String from;
  final String to;
  final VoidCallback onBack;
  final AppLocalizations l10n;

  const _ModernHeader({
    required this.from,
    required this.to,
    required this.onBack,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Row: سهم + العنوان جنب بعض
            Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
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

            const SizedBox(height: 10),

            // From → To pill
            Center(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // FROM
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2).withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color:
                          const Color(0xFF4A90E2).withValues(alpha: 0.28),
                        ),
                      ),
                      child: Text(
                        from,
                        style: const TextStyle(
                          color: Color(0xFF93C5FD),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.30),
                      ),
                    ),
                    // TO
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        to,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
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

// ── Modern Option Card ────────────────────────────────────────────
class _ModernOptionCard extends StatefulWidget {
  final RouteOption option;
  final AppLocalizations l10n;

  const _ModernOptionCard({required this.option, required this.l10n});

  @override
  State<_ModernOptionCard> createState() => _ModernOptionCardState();
}

class _ModernOptionCardState extends State<_ModernOptionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isBest = widget.option.isBest;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: Matrix4.identity()
          ..translate(0.0, _pressed ? 2.0 : 0.0),
        decoration: BoxDecoration(
          color: isBest ? const Color(0xFF141E35) : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isBest
                ? const Color(0xFF4A90E2).withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.06),
            width: isBest ? 1.5 : 1,
          ),
          boxShadow: isBest
              ? [
            BoxShadow(
              color: const Color(0xFF4A90E2).withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Gradient tint for best card
            if (isBest)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF4A90E2).withValues(alpha: 0.07),
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
                  // ── Top row ─────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Transport icon
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: isBest
                              ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF4A90E2),
                              Color(0xFF2563EB),
                            ],
                          )
                              : null,
                          color: isBest
                              ? null
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isBest
                              ? [
                            BoxShadow(
                              color: const Color(0xFF4A90E2)
                                  .withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ]
                              : null,
                        ),
                        child: Icon(
                          widget.option.icon,
                          color: isBest
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.35),
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.option.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: isBest
                                    ? Colors.white
                                    : Colors.white
                                    .withValues(alpha: 0.75),
                                letterSpacing: -0.2,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              children: [
                                _StatChip(
                                  icon: Icons.schedule_rounded,
                                  label: widget.option.time,
                                  color: const Color(0xFFFB923C),
                                ),
                                _StatChip(
                                  icon: Icons.payments_rounded,
                                  label: widget.option.cost,
                                  color: const Color(0xFF34D399),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),

                  const SizedBox(height: 16),

                  // Divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.10),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Description
                  Text(
                    widget.option.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.50),
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Pros & Cons
                  _InlineTag(
                    icon: Icons.check_rounded,
                    label: widget.option.pros,
                    isPositive: true,
                  ),
                  const SizedBox(height: 8),
                  _InlineTag(
                    icon: Icons.close_rounded,
                    label: widget.option.cons,
                    isPositive: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat Chip ─────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Inline Pros/Cons Tag ──────────────────────────────────────────
class _InlineTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPositive;

  const _InlineTag({
    required this.icon,
    required this.label,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color =
    isPositive ? const Color(0xFF34D399) : const Color(0xFFFC8181);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 12, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.55),
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Floating Chat Button ──────────────────────────────────────────
class _FloatingChatButton extends StatefulWidget {
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _FloatingChatButton({required this.onTap, required this.l10n});

  @override
  State<_FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<_FloatingChatButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_pressed ? 0.96 : 1.0),
        transformAlignment: Alignment.center,
        padding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A90E2), Color(0xFF2563EB)],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withValues(alpha: 0.45),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Text
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
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    widget.l10n.readyToHelp,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow box
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(11),
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