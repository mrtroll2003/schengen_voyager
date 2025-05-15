// screens/trip_planner_screen.dart
import 'package:flutter/material.dart';
import '../../data/countries.dart';
import '../models/trip_plan.dart';
import '../../services/api_service.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  EuropeanCountry? _selectedStartingCountry;
  int _numberOfCountries = 1; // Default
  List<CountryVisit>? _tripRoute;
  bool _isLoading = false;
  String? _errorMessage;
  final ApiService _apiService = ApiService();
  final TextEditingController _customPromptController = TextEditingController();

  // To store fetched Pexels images to avoid refetching on rebuild
  final Map<String, String?> _landmarkImageUrls = {};

  Future<void> _generateTripPlan() async {
    if (_selectedStartingCountry == null) {
      setState(() {
        _errorMessage = "Please select a starting country.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _tripRoute = null;
      _landmarkImageUrls.clear(); // Clear previous images
    });

    try {
      final route = await _apiService.getTripRoute(
        startCountry: _selectedStartingCountry!.name,
        numberOfCountries: _numberOfCountries,
        customPromptText: _customPromptController.text,
      );
      setState(() {
        _tripRoute = route;
      });
      // Pre-fetch images (optional, can also be done on-demand in list item)
      // _fetchLandmarkImages(route);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Optional: Pre-fetch all images after getting the route
  // Or fetch them individually when the landmark widget is built
  Future<void> _fetchLandmarkImages(List<CountryVisit> route) async {
    for (var countryVisit in route) {
      for (var landmark in countryVisit.landmarks) {
        if (!_landmarkImageUrls.containsKey(landmark.landmarkName)) {
          final imageUrl = await _apiService.getLandmarkImage(landmark.landmarkName);
          if (mounted) { // Check if widget is still in the tree
            setState(() {
              _landmarkImageUrls[landmark.landmarkName] = imageUrl;
              // Find the landmark in _tripRoute and update its imageUrl
              // This direct mutation is okay with setState, but for complex state,
              // you'd use a state management solution to rebuild with new data.
              final cIndex = _tripRoute!.indexWhere((c) => c.countryName == countryVisit.countryName);
              if (cIndex != -1) {
                final lIndex = _tripRoute![cIndex].landmarks.indexWhere((l) => l.landmarkName == landmark.landmarkName);
                if (lIndex != -1) {
                  _tripRoute![cIndex].landmarks[lIndex].imageUrl = imageUrl;
                }
              }
            });
          }
        }
      }
    }
  }


  Widget _buildLandmarkImage(Landmark landmark) {
    // This FutureBuilder fetches the image when the widget is built
    // if not already fetched and stored.
    if (_landmarkImageUrls.containsKey(landmark.landmarkName) && _landmarkImageUrls[landmark.landmarkName] != null) {
        return Image.network(
            _landmarkImageUrls[landmark.landmarkName]!,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
        );
    }

    return FutureBuilder<String?>(
      future: _landmarkImageUrls.containsKey(landmark.landmarkName)
          ? Future.value(_landmarkImageUrls[landmark.landmarkName]) // Use cached if present
          : _apiService.getLandmarkImage(landmark.landmarkName).then((url) {
              if (mounted) {
                setState(() {
                  _landmarkImageUrls[landmark.landmarkName] = url;
                  landmark.imageUrl = url; // Also update the model directly
                });
              }
              return url;
            }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !_landmarkImageUrls.containsKey(landmark.landmarkName)) {
          return Container(
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,)))
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
          );
        }
        return Image.network(
          snapshot.data!,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,)))
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schengen Trip Planner'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Starting Country Dropdown
            DropdownButtonFormField<EuropeanCountry>(
              decoration: InputDecoration(
                labelText: 'Choose Starting Country',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              value: _selectedStartingCountry,
              items: europeanCountries.map((EuropeanCountry country) {
                return DropdownMenuItem<EuropeanCountry>(
                  value: country,
                  child: Text(country.name),
                );
              }).toList(),
              onChanged: (EuropeanCountry? newValue) {
                setState(() {
                  _selectedStartingCountry = newValue;
                });
              },
              validator: (value) => value == null ? 'Please select a country' : null,
            ),
            const SizedBox(height: 16),

            // Number of Countries Dropdown
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Number of Countries to Visit',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              value: _numberOfCountries,
              items: List.generate(10, (index) => index + 1) // 1 to 10 countries
                  .map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _numberOfCountries = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Custom Prompt Area
            TextField(
              controller: _customPromptController,
              decoration: InputDecoration(
                labelText: 'Additional preferences for Gemini (optional)',
                hintText: 'e.g., "Focus on historical sites", "Include kid-friendly activities"',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Go Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : _generateTripPlan,
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                  : const Text('Plan My Trip!'),
            ),
            const SizedBox(height: 20),

            // Schengen Visa Reminder
            if (_selectedStartingCountry != null && !_selectedStartingCountry!.isSchengen)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  color: Colors.orange[100],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Reminder: ${_selectedStartingCountry!.name} is not in the Schengen Area. You may need to apply for a Schengen visa for other parts of your trip.',
                      style: TextStyle(color: Colors.orange[800]),
                    ),
                  ),
                ),
              ),

            // Error Message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  color: Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Error: $_errorMessage',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                ),
              ),

            // Trip Route Display
            if (_tripRoute != null)
              ListView.builder(
                shrinkWrap: true, // Important in a SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Disable its own scrolling
                itemCount: _tripRoute!.length,
                itemBuilder: (context, countryIndex) {
                  final countryVisit = _tripRoute![countryIndex];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${countryIndex + 1}. ${countryVisit.countryName}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                          Text('Recommended Stay: ${countryVisit.recDayStayed} days', style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(height: 10),
                          Text('Landmarks:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                          const SizedBox(height: 5),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: countryVisit.landmarks.length,
                            itemBuilder: (context, landmarkIndex) {
                              final landmark = countryVisit.landmarks[landmarkIndex];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: _buildLandmarkImage(landmark)
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(landmark.landmarkName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                          Text(landmark.landmarkDesc, style: TextStyle(color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}