import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({required this.child, super.key});

  final Widget child;

  static const _destinations = [
    _Dest(icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, label: 'Dashboard', path: '/'),
    _Dest(icon: Icons.storage_outlined, selectedIcon: Icons.storage, label: 'Data Pipeline', path: '/pipeline'),
    _Dest(icon: Icons.rate_review_outlined, selectedIcon: Icons.rate_review, label: 'Review', path: '/review'),
    _Dest(icon: Icons.search_outlined, selectedIcon: Icons.search, label: 'Browser', path: '/browser'),
    _Dest(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Settings', path: '/settings'),
  ];

  static const _disabledIndices = {2, 3, 4};

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (var i = 0; i < _destinations.length; i++) {
      if (_destinations[i].path == location) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedIndex = _selectedIndex(context);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              if (_disabledIndices.contains(index)) return;
              context.go(_destinations[index].path);
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (var i = 0; i < _destinations.length; i++)
                NavigationRailDestination(
                  icon: Icon(
                    _destinations[i].icon,
                    color: _disabledIndices.contains(i)
                        ? colorScheme.onSurface.withValues(alpha: 0.38)
                        : null,
                  ),
                  selectedIcon: Icon(_destinations[i].selectedIcon),
                  label: Text(
                    _destinations[i].label,
                    style: _disabledIndices.contains(i)
                        ? TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.38))
                        : null,
                  ),
                ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Dest {
  const _Dest({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.path,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;
}
