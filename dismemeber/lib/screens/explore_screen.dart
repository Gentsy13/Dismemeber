import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/meme_service.dart';
import '../models/meme_result.dart';
import '../widgets/meme_card.dart';
import 'result_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final MemeService _memeService = MemeService();
  final TextEditingController _searchController = TextEditingController();
  List<MemeResult>? _results;
  bool _isLoading = true;
  String _filter = 'all'; // 'all', 'image', 'audio'

  @override
  void initState() {
    super.initState();
    _loadMemes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMemes() async {
    setState(() => _isLoading = true);
    final results = await _memeService.getRelatedMemes('');
    if (mounted) {
      setState(() {
        _results = results;
        _isLoading = false;
      });
    }
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      _loadMemes();
      return;
    }
    setState(() => _isLoading = true);
    final results = await _memeService.searchMemes(query);
    if (mounted) {
      setState(() {
        _results = results;
        _isLoading = false;
      });
    }
  }

  List<MemeResult> get _filteredResults {
    if (_results == null) return [];
    if (_filter == 'all') return _results!;
    return _results!.where((m) => m.category == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Memes'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _search,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search memes...',
                hintStyle:
                    TextStyle(color: AppColors.textSecondary.withAlpha(120)),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Images',
                  isSelected: _filter == 'image',
                  onTap: () => setState(() => _filter = 'image'),
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Audio',
                  isSelected: _filter == 'audio',
                  onTap: () => setState(() => _filter = 'audio'),
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : _filteredResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: AppColors.textSecondary.withAlpha(80),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No memes found',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        itemCount: _filteredResults.length,
                        itemBuilder: (context, index) {
                          final meme = _filteredResults[index];
                          return MemeCard(
                            meme: meme,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResultScreen(result: meme),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? chipColor : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
