import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/local/game_storage.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  bool _hasSave = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final storage = const GameStorage();
    final has = await storage.hasSave();
    if (!mounted) return;
    setState(() => _hasSave = has);
  }

  Future<void> _continueGame() async {
    context.go(AppRouter.dashboard);
  }

  Future<void> _newGame() async {
    context.go(AppRouter.newGame);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      '0',
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text('SIFIR', style: AppTypography.displayLarge),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Azərbaycan bazarı üçün iqtisadi strategiya',
                  style: AppTypography.bodySecondary,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 3),
              if (_hasSave) ...[
                PrimaryButton(
                  label: 'Davam et',
                  onPressed: _continueGame,
                ),
                const SizedBox(height: 12),
              ],
              SecondaryButton(
                label: _hasSave ? 'Yeni oyun' : 'Yeni oyun',
                onPressed: _newGame,
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'v1.0.0',
                  style: AppTypography.caption,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
