import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLanguageToggle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLanguageToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isHindi = state.currentLanguage == 'hi';

    return AppBar(
      title: Text(title),
      backgroundColor: AppColors.primary,
      actions: [
        if (showLanguageToggle)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () {
                state.setLanguage(isHindi ? 'en' : 'hi');
              },
              icon: const Icon(Icons.language, color: Colors.white, size: 18),
              label: Text(
                isHindi ? 'EN' : 'हिन्दी',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
