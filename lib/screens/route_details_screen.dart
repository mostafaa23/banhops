import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/route_service.dart';

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

  final void Function({
  required String from,
  required String to,
  String? transportMode,
  String? costMin,
  String? costMax,
  String? timeMin,
  String? timeMax,
  }) onOpenChat;

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
  List<RouteOption> _options = [];
  bool _isLoading = true; // 👈 علم لإدارة حالة الـ Loading بشكل أفضل

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  // ✅ الدالة المعدلة لتنفيذ الـ Fallback Mechanism ذكياً
  Future<void> _loadRoutes() async {
    try {
      setState(() => _isLoading = true);

      // ✅ نظّف الاسم قبل ما تبعته للـ API ليتوافق مع الـ DB العربي
      final cleanFrom = _cleanStationName(widget.from);
      final cleanTo = _cleanStationName(widget.to);

      final routes = await RouteService.getRoute(
        from: cleanFrom,
        to: cleanTo,
      );

      // 🚨 خطة الطوارئ (Fallback Mechanism) لو الـ BFS ملاقاش مسار
      if (routes.isEmpty) {
        if (!mounted) return;

        setState(() => _isLoading = false);

        // 1. إظهار رسالة تنبيه ذكية للمستخدم
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'عذراً، لم نجد مساراً مباشراً في قاعدة البيانات. جارٍ تحويلك للمساعد الذكي ليرشدك...',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF4A90E2), // لون الثيم الأساسي بتاعك
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );

        // 2. الانتقال التلقائي لشاشة الشات بوت بعد ثانيتين
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          widget.onOpenChat(
            from: widget.from,
            to: widget.to,
            transportMode: 'unknown', // بنعرف الـ AI إن الطريق مش متسيف في الـ DB
            costMin: '0',
            costMax: '0',
            timeMin: '0',
            timeMax: '0',
          );
        });
        return;
      }

      // لو الداتا راجعة تمام وفرش الكروت عادي
      setState(() {
        _isLoading = false;
        int counter = 1;
        _options = routes.map((r) {
          final isTrain = r.transportMode.toUpperCase() == "TRAIN";
          return RouteOption(
            id: counter++,
            name: isTrain ? 'قطار' : 'ميكروباص',
            routeType: r.transportMode.toLowerCase(),
            time: "${r.timeMin}-${r.timeMax} min",
            cost: "${r.costMin}-${r.costMax} EGP",
            icon: isTrain ? Icons.train_rounded : Icons.directions_bus_rounded,
            isBest: counter == 2,
            description: "${r.fromStation} → ${r.toStation}",
            pros: isTrain ? 'مريح وسريع' : 'رخيص ومتاح وسريع',
            cons: isTrain ? 'يحتاج محطة' : 'ممكن يكون مزدحم في أوقات الذروة',
          );
        }).toList();
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error loading routes: $e");
    }
  }

  // ✅ دالة تنظيف اسم المحطة وعمل Mapping من الإنجليزي للعربي المتوافق مع الـ Seeder
  String _cleanStationName(String name) {
    final Map<String, String> mapping = {
      'Your current location': 'القاهرة',
      'Shubra El Kheima, Qalyubia': 'شبرا الخيمة',
      'Ahmed Helmy, Cairo': 'القاهرة',
      'Smouha, Alexandria': 'الإسكندرية',
      'Benha University': 'بنها',
      'Faculty of Commerce': 'بنها',
      'Faculty of Arts': 'بنها',
      'Faculty of Education': 'بنها',
      'Faculty of Specific Education': 'بنها',
      'Faculty of Physical Education': 'بنها',
      'Faculty of Law': 'بنها',
      'Faculty of Applied Arts': 'بنها',
      'el vell': 'بنها',
      'mokf': 'بنها',
      'west balad': 'بنها',
      'el mansia': 'بنها',
    };

    for (var key in mapping.keys) {
      if (name.toLowerCase().contains(key.toLowerCase())) {
        return mapping[key]!;
      }
    }
    return mapping[name] ?? name;
  }

  RouteOption get _effectiveOption {
    final selected = _options.where((o) => o.id == _selectedRouteId).firstOrNull;
    if (selected != null) return selected;

    return _options.firstWhere((o) => o.isBest, orElse: () => _options.first);
  }

  String? get _selectedRouteType =>
      _options.where((o) => o.id == _selectedRouteId).firstOrNull?.routeType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _Header(from: widget.from, to: widget.to, onBack: widget.onBack, l10n: l10n),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      if (_selectedRouteId == null && _options.isNotEmpty) ...[
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
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_options.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text(
                              'No regular routes found.',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                          ),
                        )
                      else
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
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  child: _options.isEmpty
                      ? const SizedBox.shrink()
                      : _ChatButton(
                    onTap: () {
                      final opt = _effectiveOption;
                      String? costMin, costMax, timeMin, timeMax;

                      final costParts = opt.cost.replaceAll(RegExp(r'[^0-9–]'), '').split('–');
                      if (costParts.length == 2) {
                        costMin = costParts[0];
                        costMax = costParts[1];
                      } else if (costParts.isNotEmpty) {
                        costMin = costParts[0];
                        costMax = costParts[0];
                      }

                      final timeParts = opt.time.replaceAll(RegExp(r'[^0-9–]'), '').split('–');
                      if (timeParts.length == 2) {
                        timeMin = timeParts[0];
                        timeMax = timeParts[1];
                      } else if (timeParts.isNotEmpty) {
                        timeMin = timeParts[0];
                        timeMax = timeParts[0];
                      }

                      widget.onOpenChat(
                        from: widget.from,
                        to: widget.to,
                        transportMode: opt.routeType,
                        costMin: costMin,
                        costMax: costMax,
                        timeMin: timeMin,
                        timeMax: timeMax,
                      );
                    },
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
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
                  if (isBest) const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          color: (isBest || isSelected) ? Colors.white : AppColors.textSecondary,
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
                  if (option.description.isNotEmpty) ...[
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
                  ],
                  if (option.pros.isNotEmpty) ...[
                    _ProsConsRow(
                      icon: Icons.check_circle_outline_rounded,
                      label: option.pros,
                      isPositive: true,
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (option.cons.isNotEmpty)
                    _ProsConsRow(
                      icon: Icons.cancel_outlined,
                      label: option.cons,
                      isPositive: false,
                    ),
                ],
              ),
            ),
            if (isBest)
              Positioned(
                top: 0,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2563EB) : AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, color: Colors.white, size: 13),
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
    final color = isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final bgColor = isPositive ? const Color(0xFFF0FDF4) : const Color(0xFFFFF1F2);

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
                    hasRoute ? 'Get your step-by-step itinerary' : widget.l10n.readyToHelp,
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