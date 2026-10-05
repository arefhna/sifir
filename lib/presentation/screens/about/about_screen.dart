import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Haqqında'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
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
              const SizedBox(height: 16),
              Text('SIFIR', style: AppTypography.displayLarge),
              const SizedBox(height: 4),
              Text(
                'Sıfırdan başla. İmperiya qur.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 32),
              _Card(
                children: const [
                  _Row(label: 'Versiya', value: 'v1.0.0'),
                  _Row(label: 'Build', value: '1'),
                  _Row(label: 'Platforma', value: 'Android'),
                  _Row(label: 'Framework', value: 'Flutter 3.24.5'),
                ],
              ),
              const SizedBox(height: 20),
              _SectionText(
                title: 'Oyun haqqında',
                body:
                    'SIFIR — Azərbaycan bazarına uyğun mobil iqtisadi strategiya oyunudur. '
                    '0 ₼ kapital, 0 reputasiya və 0 biznes əlaqəsi ilə başlayırsan. '
                    'Ağıllı qərarlar, risk, investisiya, ticarət və strategiya ilə '
                    'öz iqtisadi imperiyanı qurursan.',
              ),
              const SizedBox(height: 16),
              _SectionText(
                title: 'Məqsəd',
                body:
                    'Sadəcə pul yığmaq deyil — kapital, reputasiya, əlaqələr, '
                    'risk, borc, biznes, aktivlər və bazar vəziyyətini birlikdə '
                    'idarə etməyi öyrənməkdir.',
              ),
              const SizedBox(height: 16),
              _SectionText(
                title: 'Gələcək',
                body:
                    'Yaxın gələcəkdə real Azərbaycan şirkətləri oyunda sponsor '
                    'kimi görünəcək. Backend inteqrasiyası ilə cloud save, '
                    'leaderboard və gündəlik hadisələr əlavə olunacaq.',
              ),
              const SizedBox(height: 32),
              Text(
                '© 2026 SIFIR | codestack.az studio',
                style: AppTypography.caption,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySecondary),
          Text(
            value,
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  const _SectionText({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.title),
          const SizedBox(height: 8),
          Text(body, style: AppTypography.bodySecondary),
        ],
      ),
    );
  }
}
