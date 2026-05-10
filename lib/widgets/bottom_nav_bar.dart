import 'package:flutter/material.dart';

enum NavTab { home, trainLines, chat, history, profile }

class BottomNavBar extends StatelessWidget {
  final NavTab active;
  final ValueChanged<NavTab> onTap;

  const BottomNavBar({
    super.key,
    required this.active,
    required this.onTap,
  });

  static const _tabs = [
    (tab: NavTab.home,       icon: Icons.explore_outlined,    activeIcon: Icons.explore),
    (tab: NavTab.trainLines, icon: Icons.location_on_outlined, activeIcon: Icons.location_on),
    (tab: NavTab.chat,       icon: Icons.smart_toy_outlined,   activeIcon: Icons.smart_toy),
    (tab: NavTab.history,    icon: Icons.access_time_outlined, activeIcon: Icons.access_time_filled),
    (tab: NavTab.profile,    icon: Icons.person_outline,       activeIcon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    if (isKeyboardOpen) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.20),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 50,
              offset: Offset(0, 20),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: _tabs.map((item) {
            final isActive = active == item.tab;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(item.tab),
                behavior: HitTestBehavior.opaque,
                child: _NavItem(
                  icon: item.icon,
                  activeIcon: item.activeIcon,
                  isActive: isActive,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: widget.isActive ? 1.0 : 0.0,
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
  }

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      widget.isActive ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ✅ Active pill — زي motion.div في React
          ScaleTransition(
            scale: _scale,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(24),
                boxShadow: widget.isActive
                    ? const [
                  BoxShadow(
                    color: Color(0x4D4A90E2),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ]
                    : null,
              ),
            ),
          ),

          // ✅ Icon
          Icon(
            widget.isActive ? widget.activeIcon : widget.icon,
            size: 24,
            color: widget.isActive
                ? Colors.white
                : const Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }
}