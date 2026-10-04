import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/local/game_storage.dart';
import '../../data/models/player_state_model.dart';
import '../widgets/primary_button.dart';

class NewGameScreen extends ConsumerStatefulWidget {
  const NewGameScreen({super.key});

  @override
  ConsumerState<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends ConsumerState<NewGameScreen> {
  final TextEditingController _controller =
      TextEditingController(text: 'Oyunçu');
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startGame() async {
    final name = _controller.text.trim().isEmpty
        ? 'Oyunçu'
        : _controller.text.trim();
    setState(() => _saving = true);
    final storage = const GameStorage();
    await storage.deleteSave();
    final state = PlayerState.initial(name);
    await storage.savePlayer(state);
    if (!mounted) return;
    setState(() => _saving = false);
    context.go(AppRouter.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.mainMenu),
        ),
        title: const Text('Yeni oyun'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text('Adını seç', style: AppTypography.headline),
              const SizedBox(height: 8),
              const Text(
                'Bu ad oyun boyunca səninlə qalacaq.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                maxLength: 20,
                style: AppTypography.body,
                decoration: const InputDecoration(
                  hintText: 'Oyunçu adı',
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.info_outline,
                            color: AppColors.accent, size: 20),
                        SizedBox(width: 8),
                        Text('Başlanğıc şərtləri',
                            style: AppTypography.title),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _row('Kapital', '0 ₼'),
                    _row('Reputasiya', '0 / 100'),
                    _row('Risk', '10 / 100'),
                    _row('Borc', '0 ₼'),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: _saving ? 'Yaradılır...' : 'Oyuna başla',
                onPressed: _saving ? null : _startGame,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySecondary),
          Text(value, style: AppTypography.body),
        ],
      ),
    );
  }
}
