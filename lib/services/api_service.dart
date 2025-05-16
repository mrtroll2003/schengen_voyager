// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip_plan.dart'; // Adjust path if needed

class ApiService {
  static const String _geminiApiBaseUrlEnvVar = 'GEMINI_API_KEY';
  final String _geminiApiKey = const String.fromEnvironment(
    _geminiApiBaseUrlEnvVar, defaultValue: 'bug', 
  );
  static const String _pexelsApiBaseUrlEnvVar = 'PEXELS_API_KEY';
  final String _pexelsApiKey = const String.fromEnvironment(
    _pexelsApiBaseUrlEnvVar, defaultValue: 'bug', 
  );
  final String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent'; // Check latest Gemini API endpoint

  Future<List<CountryVisit>> getTripRoute({
    required String startCountry,
    required int numberOfCountries,
    required String customPromptText, // For user customization
  }) async {
    // --- Customizable Gemini Prompt ---
    String prompt = """
    You are a helpful travel planning assistant.
    A user wants to plan a trip in Europe starting from $startCountry and visiting $numberOfCountries countries in total (including the starting country).
    Please provide a logical travel route. For each country, suggest a recommended number of days to stay and list 2-3 key landmarks with a very short, engaging description (max 10-15 words per landmark).
    Ensure the total number of countries in your response is exactly $numberOfCountries.
    Prioritize countries that are geographically sensible to visit in a sequence from the starting country.
    If $startCountry is not in the Schengen area, try to make the first country in the Schengen area the next logical stop if possible, or at least make the route flow well.

    $customPromptText // User's custom additions to the prompt

    Format your response as a JSON array of objects. Each object represents a country and should have the following structure:
    {
        "countryId": "A unique sequential ID for the country in the route (e.g., 1, 2, 3...)",
        "countryName": "Name of the country",
        "recDayStayed": "Recommended number of days to stay (integer)",
        "landmarks": [
            {
                "landmarkId": "A unique sequential ID for the landmark within this country (e.g., 1, 2...)",
                "landmarkName": "Name of the landmark",
                "landmarkDesc": "A short, engaging description of the landmark (max 15 words)"
            }
        ]
    }
    Example for one country object:
    {
        "countryId": 1,
        "countryName": "France",
        "recDayStayed": 3,
        "landmarks": [
            {"landmarkId": 1, "landmarkName": "Eiffel Tower", "landmarkDesc": "Iconic iron lattice tower, Parisian views."},
            {"landmarkId": 2, "landmarkName": "Louvre Museum", "landmarkDesc": "World's largest art museum, Mona Lisa."}
        ]
    }
    Make sure the entire response is a valid JSON array.
    """;

    try {
      final response = await http.post(
        Uri.parse('$_geminiApiUrl?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{'parts': [{'text': prompt}]}]
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // Gemini API response structure can be nested. You need to extract the actual content.
        // This is a common structure, but verify with Gemini's documentation for "gemini-pro"
        final String content = responseBody['candidates'][0]['content']['parts'][0]['text'];

        // The content itself is expected to be a JSON string representing List<CountryVisit>
        final List<dynamic> parsedJson = jsonDecode(content);
        return parsedJson.map((jsonItem) => CountryVisit.fromJson(jsonItem)).toList();
      } else {
        //print(_geminiApiKey);
        //print(_pexelsApiKey);
        print('Gemini API Error: ${response.statusCode}');
        print('Gemini API Body: ${response.body}');
        throw Exception('Failed to load trip route from Gemini API: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error calling Gemini API: $e');
      throw Exception('Error calling Gemini API: $e');
    }
  }

  Future<String?> getLandmarkImage(String landmarkName) async {
    final query = Uri.encodeComponent(landmarkName);
    final url = Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=1');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': _pexelsApiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['photos'] != null && (data['photos'] as List).isNotEmpty) {
          return data['photos'][0]['src']['medium']; // Or 'large', 'original' etc.
        }
        return null; // No image found
      } else {
        print('Pexels API Error: ${response.statusCode} for $landmarkName');
        return null;
      }
    } catch (e) {
      print('Error calling Pexels API for $landmarkName: $e');
      return null;
    }
  }
}