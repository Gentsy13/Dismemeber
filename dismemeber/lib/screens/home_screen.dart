import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/feature_card.dart';
import 'scan_screen.dart';
import 'audio_screen.dart';
import 'explore_screen.dart';
import 'viral_memes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dismemeber',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Identify any meme instantly',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // Hero section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A1A3E),
                      Color(0xFF0F3460),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.primary.withAlpha(40),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'What meme is this?',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Scan an image or record audio to identify memes, viral sounds, and internet culture.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ScanScreen()),
                            ),
                            icon: const Icon(Icons.camera_alt_rounded),
                            label: const Text('Scan'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AudioScreen()),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                            ),
                            icon: const Icon(Icons.mic_rounded),
                            label: const Text('Listen'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Features
              const Text(
                'Features',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  FeatureCard(
                    icon: Icons.image_search_rounded,
                    title: 'Image Scan',
                    subtitle: 'Identify memes from photos or screenshots',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanScreen()),
                    ),
                  ),
                  FeatureCard(
                    icon: Icons.graphic_eq_rounded,
                    title: 'Audio ID',
                    subtitle: 'Recognize meme sounds & viral clips',
                    iconColor: AppColors.secondary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AudioScreen()),
                    ),
                  ),
                  FeatureCard(
                    icon: Icons.history_edu_rounded,
                    title: 'Meme Origins',
                    subtitle: 'Learn the history behind every meme',
                    iconColor: const Color(0xFFFFC107),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ViralMemesScreen()),
                    ),
                  ),
                  FeatureCard(
                    icon: Icons.explore_rounded,
                    title: 'Explore',
                    subtitle: 'Discover related memes & variations',
                    iconColor: const Color(0xFF4CAF50),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExploreScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
