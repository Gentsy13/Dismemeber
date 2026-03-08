import 'package:flutter/material.dart';
import '../models/meme_result.dart';
import '../theme/app_theme.dart';

class MemeCard extends StatelessWidget {
  final MemeResult meme;
  final VoidCallback onTap;

  const MemeCard({
    super.key,
    required this.meme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: meme.category == 'image'
                    ? AppColors.primary.withAlpha(30)
                    : AppColors.secondary.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                meme.category == 'image'
                    ? Icons.image_rounded
                    : Icons.music_note_rounded,
                color: meme.category == 'image'
                    ? AppColors.primary
                    : AppColors.secondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meme.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meme.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(40),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      meme.year,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
