import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shopease/constants/colors.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).cardTheme.shadowColor ??
                Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
        elevation: 0,
        indicatorColor: AppColors.primary.withValues(alpha: 0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.home),
            selectedIcon: Icon(LucideIcons.home, color: AppColors.primary),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.shoppingBag),
            selectedIcon: Icon(
              LucideIcons.shoppingBag,
              color: AppColors.primary,
            ),
            label: 'Panier',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.heart),
            selectedIcon: Icon(LucideIcons.heart, color: AppColors.primary),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.clipboardList),
            selectedIcon: Icon(
              LucideIcons.clipboardList,
              color: AppColors.primary,
            ),
            label: 'Commandes',
          ),
        ],
      ),
    );
  }
}
