// models/trip_plan.dart
class Landmark {
  final int landmarkId; // Or String if Gemini provides it as such
  final String landmarkName;
  final String landmarkDesc;
  String? imageUrl; // To be populated by Pexels

  Landmark({
    required this.landmarkId,
    required this.landmarkName,
    required this.landmarkDesc,
    this.imageUrl,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      landmarkId: json['landmarkId'] as int, // Adjust type if needed
      landmarkName: json['landmarkName'] as String,
      landmarkDesc: json['landmarkDesc'] as String,
    );
  }
}

class CountryVisit {
  final int countryId; // Or String
  final String countryName;
  final int recDayStayed;
  final List<Landmark> landmarks;

  CountryVisit({
    required this.countryId,
    required this.countryName,
    required this.recDayStayed,
    required this.landmarks,
  });

  factory CountryVisit.fromJson(Map<String, dynamic> json) {
    var landmarksList = json['landmarks'] as List;
    List<Landmark> parsedLandmarks = landmarksList.map((i) => Landmark.fromJson(i)).toList();

    return CountryVisit(
      countryId: json['countryId'] as int, // Adjust type if needed
      countryName: json['countryName'] as String,
      recDayStayed: json['recDayStayed'] as int,
      landmarks: parsedLandmarks,
    );
  }
}

// The overall route will be a List<CountryVisit>