import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/meme_result.dart';
import '../config/api_keys.dart';

class MemeService {
  static const String _apiKey = geminiApiKey;

  /// Analyze an image using Google Gemini Vision API.
  Future<MemeResult> analyzeImage(Uint8List imageBytes) async {
    final base64Image = base64Encode(imageBytes);

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey',
    );

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text': 'Identify this meme. Reply with ONLY a short JSON object: {"name":"...","description":"one sentence","origin":"one sentence","year":"YYYY","viral_context":"one sentence","variations":["v1","v2"],"related_memes":["m1","m2"]}. Keep every value under 50 words. No markdown.'
            },
            {
              'inline_data': {
                'mime_type': 'image/png',
                'data': base64Image,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.3,
        'maxOutputTokens': 2048,
        'responseMimeType': 'application/json',
      }
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API error (${response.statusCode}): ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final text = json['candidates'][0]['content']['parts'][0]['text'] as String;

    // Strip markdown code fences if present
    final cleaned = text
        .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
        .trim();

    Map<String, dynamic> memeJson;
    try {
      memeJson = jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (_) {
      // If JSON is truncated, try to salvage what we can
      var patched = cleaned;
      // Close any open strings and objects
      if (!patched.endsWith('}')) {
        patched = '$patched"}]}';
      }
      try {
        memeJson = jsonDecode(patched) as Map<String, dynamic>;
      } catch (_) {
        // Last resort: extract name from partial JSON
        final nameMatch = RegExp(r'"name"\s*:\s*"([^"]*)"').firstMatch(cleaned);
        memeJson = {
          'name': nameMatch?.group(1) ?? 'Identified Meme',
          'description': 'The meme was identified but the full details could not be parsed.',
        };
      }
    }

    return MemeResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: memeJson['name'] as String? ?? 'Unknown Meme',
      description: memeJson['description'] as String? ?? '',
      origin: memeJson['origin'] as String? ?? '',
      year: memeJson['year'] as String? ?? 'Unknown',
      viralContext: memeJson['viral_context'] as String? ?? '',
      variations: List<String>.from(memeJson['variations'] as List? ?? []),
      relatedMemes: List<String>.from(memeJson['related_memes'] as List? ?? []),
      category: 'image',
    );
  }

  /// Analyze audio using Google Gemini API.
  Future<MemeResult> analyzeAudio(Uint8List audioBytes) async {
    final base64Audio = base64Encode(audioBytes);

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey',
    );

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text': 'Identify this audio meme or viral sound. Reply with ONLY a short JSON object: {"name":"...","description":"one sentence","origin":"one sentence","year":"YYYY","viral_context":"one sentence","variations":["v1","v2"],"related_memes":["m1","m2"]}. Keep every value under 50 words. No markdown.'
            },
            {
              'inline_data': {
                'mime_type': 'audio/webm',
                'data': base64Audio,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.3,
        'maxOutputTokens': 2048,
        'responseMimeType': 'application/json',
      }
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API error (${response.statusCode}): ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final text = json['candidates'][0]['content']['parts'][0]['text'] as String;

    final cleaned = text
        .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
        .trim();

    Map<String, dynamic> memeJson;
    try {
      memeJson = jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (_) {
      final nameMatch = RegExp(r'"name"\s*:\s*"([^"]*)"').firstMatch(cleaned);
      memeJson = {
        'name': nameMatch?.group(1) ?? 'Identified Sound',
        'description': 'The audio was identified but full details could not be parsed.',
      };
    }

    return MemeResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: memeJson['name'] as String? ?? 'Unknown Sound',
      description: memeJson['description'] as String? ?? '',
      origin: memeJson['origin'] as String? ?? '',
      year: memeJson['year'] as String? ?? 'Unknown',
      viralContext: memeJson['viral_context'] as String? ?? '',
      variations: List<String>.from(memeJson['variations'] as List? ?? []),
      relatedMemes: List<String>.from(memeJson['related_memes'] as List? ?? []),
      category: 'audio',
    );
  }

  /// Get related memes for exploration.
  Future<List<MemeResult>> getRelatedMemes(String memeId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _getMockExploreResults();
  }

  /// Search memes by text query.
  Future<List<MemeResult>> searchMemes(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    return _getMockExploreResults();
  }

  List<MemeResult> _getMockExploreResults() {
    return const [
      MemeResult(
        id: '3',
        name: 'Woman Yelling at Cat',
        description: 'A two-panel meme combining Taylor Armstrong from RHOBH and a confused cat named Smudge.',
        origin: 'Combination of two separate images that went viral together in 2019.',
        year: '2019',
        viralContext: 'One of the most popular memes of 2019, used for absurd comparison humor.',
        variations: ['Debate format', 'Argument memes', 'Food disagreements'],
        relatedMemes: ['Distracted Boyfriend', 'Drake Hotline Bling'],
        category: 'image',
      ),
      MemeResult(
        id: '4',
        name: 'Drake Hotline Bling',
        description: 'Two-panel image of Drake rejecting one thing and approving another.',
        origin: 'Screenshots from Drake\'s "Hotline Bling" music video (2015).',
        year: '2015',
        viralContext: 'The go-to template for preference comparisons across all social media platforms.',
        variations: ['Preference comparisons', 'Product reviews', 'Life choices'],
        relatedMemes: ['Distracted Boyfriend', 'Expanding Brain'],
        category: 'image',
      ),
    ];
  }
}
