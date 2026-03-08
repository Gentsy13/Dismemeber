import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/meme_service.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Uint8List? _imageBytes;
  bool _isAnalyzing = false;
  final ImagePicker _picker = ImagePicker();
  final MemeService _memeService = MemeService();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageBytes == null) return;

    setState(() => _isAnalyzing = true);

    try {
      final result = await _memeService.analyzeImage(_imageBytes!);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Meme'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Image preview area
              Expanded(
                child: GestureDetector(
                  onTap: () => _showPickerOptions(),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _imageBytes != null
                            ? AppColors.primary.withAlpha(80)
                            : AppColors.cardBorder,
                        width: 2,
                      ),
                    ),
                    child: _imageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.memory(
                              _imageBytes!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate_rounded,
                                  size: 64,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Tap to select an image',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Take a photo or choose from gallery',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              if (_imageBytes != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _analyzeImage,
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.background,
                            ),
                          )
                        : const Icon(Icons.search_rounded),
                    label: Text(
                        _isAnalyzing ? 'Analyzing...' : 'Identify Meme'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => setState(() => _imageBytes = null),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Choose Different Image'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: _PickerButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Camera',
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickerButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withAlpha(60),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded,
                  color: AppColors.primary),
              title: const Text('Take Photo',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: AppColors.secondary),
              title: const Text('Choose from Gallery',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
