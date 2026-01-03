import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UIConstants.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spaceSm,
            vertical: UIConstants.spaceSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.apartment_outlined,
                activeIcon: Icons.apartment_rounded,
                label: 'Rent',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.leaderboard_outlined,
                activeIcon: Icons.leaderboard_rounded,
                label: 'Budget',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.verified_user_outlined,
                activeIcon: Icons.verified_user_rounded,
                label: 'Insurance',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Account',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: UIConstants.animFast,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? UIConstants.spaceMd : UIConstants.spaceSm,
          vertical: UIConstants.spaceSm,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? UIConstants.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: UIConstants.borderRadiusMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color:
                  isActive ? UIConstants.primaryColor : UIConstants.mutedColor,
              size: 22,
            ),
            const SizedBox(height: UIConstants.spaceXs),
            Text(
              label,
              style: TextStyle(
                fontSize: isActive ? 11 : 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? UIConstants.primaryColor
                    : UIConstants.mutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
