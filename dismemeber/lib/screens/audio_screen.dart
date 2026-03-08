import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/app_theme.dart';
import '../services/meme_service.dart';
import 'result_screen.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  final MemeService _memeService = MemeService();
  bool _isRecording = false;
  bool _isAnalyzing = false;
  String? _recordedPath;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) return;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/meme_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _recordedPath = null;
    });
    _pulseController.repeat(reverse: true);
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    _pulseController.stop();
    _pulseController.reset();

    setState(() {
      _isRecording = false;
      _recordedPath = path;
    });
  }

  Future<void> _analyzeAudio() async {
    if (_recordedPath == null) return;

    setState(() => _isAnalyzing = true);

    try {
      final result = await _memeService.analyzeAudio(_recordedPath!);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing audio: $e')),
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
        title: const Text('Audio Recognition'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Instructions
              Text(
                _isRecording
                    ? 'Listening...'
                    : _recordedPath != null
                        ? 'Audio recorded!'
                        : 'Tap the mic to start',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isRecording
                    ? 'Play the meme sound near your device'
                    : _recordedPath != null
                        ? 'Ready to identify the sound'
                        : 'Record a meme sound or viral audio clip',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 48),

              // Mic button with pulse animation
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 180 + (_pulseController.value * 40),
                    height: 180 + (_pulseController.value * 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (_isRecording
                              ? AppColors.secondary
                              : AppColors.primary)
                          .withAlpha(
                        (20 + _pulseController.value * 20).toInt(),
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _isAnalyzing ? null : _toggleRecording,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _isRecording
                                  ? [
                                      AppColors.secondary,
                                      AppColors.secondary.withAlpha(180),
                                    ]
                                  : [
                                      AppColors.primary,
                                      AppColors.accent,
                                    ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_isRecording
                                        ? AppColors.secondary
                                        : AppColors.primary)
                                    .withAlpha(80),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isRecording
                                ? Icons.stop_rounded
                                : Icons.mic_rounded,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Analyze button
              if (_recordedPath != null && !_isRecording) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _analyzeAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.search_rounded),
                    label: Text(
                        _isAnalyzing ? 'Analyzing...' : 'Identify Sound'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => setState(() => _recordedPath = null),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Record Again'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
