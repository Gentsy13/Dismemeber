import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MemeEntry {
  final String title;
  final String year;
  final String description;
  final String origin;
  final String impact;
  final IconData icon;
  final List<Color> gradient;

  const MemeEntry({
    required this.title,
    required this.year,
    required this.description,
    required this.origin,
    required this.impact,
    required this.icon,
    required this.gradient,
  });
}

class ViralMemesScreen extends StatefulWidget {
  const ViralMemesScreen({super.key});

  @override
  State<ViralMemesScreen> createState() => _ViralMemesScreenState();
}

class _ViralMemesScreenState extends State<ViralMemesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<MemeEntry> _memes = [
    MemeEntry(
      title: 'Rickroll',
      year: '2007',
      description:
          'A bait-and-switch prank where a link redirects to Rick Astley\'s "Never Gonna Give You Up" music video.',
      origin:
          'Started on 4chan as a variant of the "duckroll" prank. Users would disguise the link and trick others into watching the 1987 music video.',
      impact:
          'One of the longest-running internet memes ever. Rick Astley himself embraced it — the video hit 1 billion YouTube views in 2021.',
      icon: Icons.music_note_rounded,
      gradient: [Color(0xFFE94560), Color(0xFF533483)],
    ),
    MemeEntry(
      title: 'Distracted Boyfriend',
      year: '2017',
      description:
          'A man looks at another woman while his girlfriend stares in disbelief. Used to represent being tempted by something new.',
      origin:
          'The stock photo was taken by Antonio Guillem in 2015. It went viral in 2017 when someone labeled the three people.',
      impact:
          'Became the definitive "object labeling" meme template. Named one of the top memes of the decade by multiple outlets.',
      icon: Icons.people_rounded,
      gradient: [Color(0xFF00D4FF), Color(0xFF0F3460)],
    ),
    MemeEntry(
      title: 'Doge',
      year: '2013',
      description:
          'A Shiba Inu dog surrounded by colorful Comic Sans text like "such wow", "much amaze", "very cool".',
      origin:
          'Based on a 2010 photo of a Shiba Inu named Kabosu. The meme format with broken English emerged on Tumblr in 2013.',
      impact:
          'Inspired Dogecoin cryptocurrency. Became so iconic that Kabosu\'s face is recognized worldwide. Revived multiple times.',
      icon: Icons.pets_rounded,
      gradient: [Color(0xFFFFC107), Color(0xFFFF6F00)],
    ),
    MemeEntry(
      title: 'Woman Yelling at Cat',
      year: '2019',
      description:
          'Two-panel meme: Taylor Armstrong crying and pointing, next to Smudge the cat sitting at a dinner table looking confused.',
      origin:
          'Combines a 2011 Real Housewives of Beverly Hills screenshot with a 2018 photo of a cat named Smudge. Merged in May 2019.',
      impact:
          'Dominated meme culture throughout 2019. Used for absurd comparisons and arguments. Smudge became an Instagram celebrity.',
      icon: Icons.restaurant_rounded,
      gradient: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
    ),
    MemeEntry(
      title: 'Drake Hotline Bling',
      year: '2015',
      description:
          'Two panels of Drake: top panel rejecting something, bottom panel approving something else.',
      origin:
          'Taken from Drake\'s "Hotline Bling" music video. The dance moves were instantly memed when the video dropped in October 2015.',
      impact:
          'The ultimate preference/comparison template. Has been recreated with hundreds of characters and is still used daily.',
      icon: Icons.compare_arrows_rounded,
      gradient: [Color(0xFF9C27B0), Color(0xFF4A148C)],
    ),
    MemeEntry(
      title: 'Pepe the Frog',
      year: '2008',
      description:
          'A cartoon frog with a humanoid body. Originally just saying "feels good man." Evolved into countless variations.',
      origin:
          'Created by Matt Furie in his comic "Boy\'s Club" (2005). Became a meme on MySpace and 4chan around 2008.',
      impact:
          'One of the most versatile memes ever created. Spawned Rare Pepes, Sad Pepe, Smug Pepe, and even NFT collections.',
      icon: Icons.emoji_emotions_rounded,
      gradient: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
    ),
    MemeEntry(
      title: 'This Is Fine',
      year: '2013',
      description:
          'A cartoon dog sitting in a burning room, calmly saying "This is fine." Represents denial in chaotic situations.',
      origin:
          'From KC Green\'s webcomic "Gunshow" (2013). The two-panel version became the most shared format.',
      impact:
          'The go-to meme for expressing calm during disasters. Used heavily during every major crisis since 2016.',
      icon: Icons.local_fire_department_rounded,
      gradient: [Color(0xFFFF5722), Color(0xFFBF360C)],
    ),
    MemeEntry(
      title: 'Skibidi Toilet',
      year: '2023',
      description:
          'A surreal animated series featuring singing heads emerging from toilets, battling humanoids with speakers and cameras for heads.',
      origin:
          'Created by Alexey Gerasimov using Source Filmmaker. First episode uploaded to YouTube in February 2023.',
      impact:
          'Became the defining Gen Alpha meme. The series amassed billions of views and spawned an entire subculture of content.',
      icon: Icons.smart_display_rounded,
      gradient: [Color(0xFF00BCD4), Color(0xFF006064)],
    ),
    MemeEntry(
      title: 'Loss (| || || |_)',
      year: '2008',
      description:
          'An abstract minimalist meme derived from a serious webcomic strip. Reduced to just lines representing the four panels.',
      origin:
          'From the June 2008 Ctrl+Alt+Del comic about a miscarriage. The tonal shift was mocked, then abstracted into a pattern.',
      impact:
          'Became the ultimate "hidden in plain sight" meme. People find or create Loss references in architecture, art, and math.',
      icon: Icons.grid_view_rounded,
      gradient: [Color(0xFF607D8B), Color(0xFF37474F)],
    ),
    MemeEntry(
      title: 'Among Us / Amogus',
      year: '2020',
      description:
          'Everything looks "sus." The crewmate shape from Among Us is spotted everywhere — in everyday objects, logos, and art.',
      origin:
          'Among Us launched in 2018 but exploded during COVID lockdowns in 2020. "Amogus" emerged as an ironic shitpost variant.',
      impact:
          'Took over the internet for months. "Sus" entered mainstream vocabulary. People can\'t unsee the crewmate shape anywhere.',
      icon: Icons.visibility_rounded,
      gradient: [Color(0xFFF44336), Color(0xFFB71C1C)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Viral Memes'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentPage + 1} / ${_memes.length}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _memes.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (context, index) {
          final meme = _memes[index];
          return _MemeCard(meme: meme, index: index);
        },
      ),
    );
  }
}

class _MemeCard extends StatelessWidget {
  final MemeEntry meme;
  final int index;

  const _MemeCard({required this.meme, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            meme.gradient[0].withAlpha(40),
            AppColors.background,
            AppColors.background,
            meme.gradient[1].withAlpha(30),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              // Icon + Year badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: meme.gradient),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: meme.gradient[0].withAlpha(80),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(meme.icon, size: 36, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: meme.gradient[0].withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: meme.gradient[0].withAlpha(60)),
                    ),
                    child: Text(
                      meme.year,
                      style: TextStyle(
                        color: meme.gradient[0],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                meme.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                meme.description,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 28),

              // Origin section
              _InfoSection(
                label: 'ORIGIN',
                text: meme.origin,
                color: meme.gradient[0],
              ),

              const SizedBox(height: 20),

              // Impact section
              _InfoSection(
                label: 'IMPACT',
                text: meme.impact,
                color: meme.gradient[1],
              ),

              const Spacer(flex: 3),

              // Swipe hint
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: AppColors.textSecondary.withAlpha(100),
                      size: 28,
                    ),
                    Text(
                      'Swipe up for next',
                      style: TextStyle(
                        color: AppColors.textSecondary.withAlpha(100),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String label;
  final String text;
  final Color color;

  const _InfoSection({
    required this.label,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
