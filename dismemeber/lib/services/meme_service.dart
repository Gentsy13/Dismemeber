import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/meme_result.dart';

class MemeService {
  static const String _apiKey = 'AIzaSyCW04nIzNEDpeGMrqIkBFiTLia5oVjrTZ8';

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
              'text': '''Analyze this image and identify the meme. Respond ONLY with valid JSON in this exact format, no markdown, no code fences:
{
  "name": "Meme name",
  "description": "What the meme is and how it's used",
  "origin": "Where and when it originated",
  "year": "Year it went viral (e.g. 2019)",
  "viral_context": "How it spread and became popular on social media",
  "variations": ["variation 1", "variation 2", "variation 3"],
  "related_memes": ["related meme 1", "related meme 2", "related meme 3"]
}

If this is not a recognizable meme, still try your best to describe what the image shows and any potential meme-like qualities.'''
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
        'maxOutputTokens': 1024,
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

    final memeJson = jsonDecode(cleaned) as Map<String, dynamic>;

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

  /// Analyze audio – still mock for now (requires ACRCloud or similar).
  Future<MemeResult> analyzeAudio(String audioPath) async {
    await Future.delayed(const Duration(seconds: 2));
    return const MemeResult(
      id: '2',
      name: 'Audio Recognition Coming Soon',
      description: 'Audio meme recognition requires an audio fingerprinting service like ACRCloud. This feature is under development.',
      origin: 'N/A',
      year: 'N/A',
      viralContext: 'Audio recognition will support phonk tracks, viral TikTok sounds, and classic meme audio clips.',
      variations: ['Coming soon'],
      relatedMemes: ['Coming soon'],
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
