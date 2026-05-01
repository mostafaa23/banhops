import 'package:flutter/material.dart';

enum NavTab { home, trainLines, chat, history, profile }

class BottomNavBar extends StatelessWidget {
  final NavTab active;
  final ValueChanged<NavTab> onTap;

  const BottomNavBar({super.key, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.explore_outlined,
              label: "Explore",
              isSelected: active == NavTab.home,
              onPressed: () => onTap(NavTab.home),
            ),
            _buildNavItem(
              icon: Icons.train_outlined,
              label: "Train Lines",
              isSelected: active == NavTab.trainLines,
              onPressed: () => onTap(NavTab.trainLines),
            ),
            _buildNavItem(
              icon: Icons.chat_bubble_outline,
              label: "Chat",
              isSelected: active == NavTab.chat,
              onPressed: () => onTap(NavTab.chat),
            ),
            _buildNavItem(
              icon: Icons.history,
              label: "History",
              isSelected: active == NavTab.history,
              onPressed: () => onTap(NavTab.history),
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              label: "Profile",
              isSelected: active == NavTab.profile,
              onPressed: () => onTap(NavTab.profile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFC0DDFF) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF6A7282),
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF6A7282),
            ),
          ),
        ],
      ),
    );
  }
}
