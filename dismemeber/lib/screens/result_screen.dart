import 'package:flutter/material.dart';
import '../models/meme_result.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final MemeResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meme Identified'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meme identity header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: result.category == 'image'
                      ? [
                          const Color(0xFF0F3460),
                          const Color(0xFF1A1A3E),
                        ]
                      : [
                          const Color(0xFF3E1A1A),
                          const Color(0xFF60200F),
                        ],
                ),
                border: Border.all(
                  color: (result.category == 'image'
                          ? AppColors.primary
                          : AppColors.secondary)
                      .withAlpha(60),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (result.category == 'image'
                              ? AppColors.primary
                              : AppColors.secondary)
                          .withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      result.category == 'image'
                          ? Icons.image_rounded
                          : Icons.music_note_rounded,
                      size: 48,
                      color: result.category == 'image'
                          ? AppColors.primary
                          : AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    result.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(60),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Origin: ${result.year}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Description
            _SectionTitle(title: 'What is it?'),
            const SizedBox(height: 8),
            Text(
              result.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            // Origin
            _SectionTitle(title: 'Origin & History'),
            const SizedBox(height: 8),
            Text(
              result.origin,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            // Viral Context
            _SectionTitle(title: 'Viral Context'),
            const SizedBox(height: 8),
            Text(
              result.viralContext,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            // Variations
            _SectionTitle(title: 'Popular Variations'),
            const SizedBox(height: 12),
            ...result.variations.map(
              (v) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        v,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Related memes
            _SectionTitle(title: 'Related Memes'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.relatedMemes.map((name) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Try again button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Scan Another'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
