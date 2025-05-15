// data/countries.dart
class EuropeanCountry {
  final String name;
  final bool isSchengen;
  // Potentially country codes, etc.

  EuropeanCountry({required this.name, this.isSchengen = true});
}

final List<EuropeanCountry> europeanCountries = [
  EuropeanCountry(name: "Albania", isSchengen: false), // Example, verify Schengen status
  EuropeanCountry(name: "Andorra", isSchengen: false), // De facto Schengen
  EuropeanCountry(name: "Austria"),
  EuropeanCountry(name: "Belarus", isSchengen: false),
  EuropeanCountry(name: "Belgium"),
  EuropeanCountry(name: "Bosnia and Herzegovina", isSchengen: false),
  EuropeanCountry(name: "Bulgaria", isSchengen: false), // Schengen candidate
  EuropeanCountry(name: "Croatia"),
  EuropeanCountry(name: "Cyprus", isSchengen: false), // EU, but not fully Schengen
  EuropeanCountry(name: "Czech Republic"),
  EuropeanCountry(name: "Denmark"),
  EuropeanCountry(name: "Estonia"),
  EuropeanCountry(name: "Finland"),
  EuropeanCountry(name: "France"),
  EuropeanCountry(name: "Germany"),
  EuropeanCountry(name: "Greece"),
  EuropeanCountry(name: "Hungary"),
  EuropeanCountry(name: "Iceland"), // Schengen, not EU
  EuropeanCountry(name: "Ireland", isSchengen: false), // EU, not Schengen
  EuropeanCountry(name: "Italy"),
  EuropeanCountry(name: "Kosovo", isSchengen: false),
  EuropeanCountry(name: "Latvia"),
  EuropeanCountry(name: "Liechtenstein"), // Schengen, not EU
  EuropeanCountry(name: "Lithuania"),
  EuropeanCountry(name: "Luxembourg"),
  EuropeanCountry(name: "Malta"),
  EuropeanCountry(name: "Moldova", isSchengen: false),
  EuropeanCountry(name: "Monaco", isSchengen: false), // De facto Schengen
  EuropeanCountry(name: "Montenegro", isSchengen: false),
  EuropeanCountry(name: "Netherlands"),
  EuropeanCountry(name: "North Macedonia", isSchengen: false),
  EuropeanCountry(name: "Norway"), // Schengen, not EU
  EuropeanCountry(name: "Poland"),
  EuropeanCountry(name: "Portugal"),
  EuropeanCountry(name: "Romania", isSchengen: false), // Schengen candidate
  EuropeanCountry(name: "Russia", isSchengen: false),
  EuropeanCountry(name: "San Marino", isSchengen: false), // De facto Schengen
  EuropeanCountry(name: "Serbia", isSchengen: false),
  EuropeanCountry(name: "Slovakia"),
  EuropeanCountry(name: "Slovenia"),
  EuropeanCountry(name: "Spain"),
  EuropeanCountry(name: "Sweden"),
  EuropeanCountry(name: "Switzerland"), // Schengen, not EU
  EuropeanCountry(name: "Turkey", isSchengen: false),
  EuropeanCountry(name: "Ukraine", isSchengen: false),
  EuropeanCountry(name: "United Kingdom", isSchengen: false),
  EuropeanCountry(name: "Vatican City", isSchengen: false), // De facto Schengen
  // ... Add all European countries. Ensure Schengen status is accurate.
];