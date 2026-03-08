import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
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
  Uint8List? _audioBytes;
  String? _audioName;
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
    try {
      if (!await _recorder.hasPermission()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission denied')),
          );
        }
        return;
      }

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.opus),
        path: '',
      );

      setState(() {
        _isRecording = true;
        _audioBytes = null;
        _audioName = null;
      });
      _pulseController.repeat(reverse: true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start recording: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      _pulseController.stop();
      _pulseController.reset();

      if (path != null) {
        // On web, path is a blob URL — fetch the bytes
        final response = await http.get(Uri.parse(path));
        setState(() {
          _isRecording = false;
          _audioBytes = response.bodyBytes;
          _audioName = 'Recording';
        });
      } else {
        setState(() => _isRecording = false);
      }
    } catch (e) {
      _pulseController.stop();
      _pulseController.reset();
      setState(() => _isRecording = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to stop recording: $e')),
        );
      }
    }
  }

  Future<void> _pickAudioFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          setState(() {
            _audioBytes = file.bytes!;
            _audioName = file.name;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e')),
        );
      }
    }
  }

  Future<void> _analyzeAudio() async {
    if (_audioBytes == null) return;

    setState(() => _isAnalyzing = true);

    try {
      final result = await _memeService.analyzeAudio(_audioBytes!);
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
                    : _audioBytes != null
                        ? (_audioName ?? 'Audio ready!')
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
                    : _audioBytes != null
                        ? 'Ready to identify the sound'
                        : 'Record or upload a meme sound',
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
              // Upload file button
              if (_audioBytes == null && !_isRecording) ...[                OutlinedButton.icon(
                  onPressed: _pickAudioFile,
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Upload Audio File'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (_audioBytes != null && !_isRecording) ...[
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
                  onPressed: () => setState(() {
                    _audioBytes = null;
                    _audioName = null;
                  }),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
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
