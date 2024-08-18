class Createleague {
  final String id; // Make this required
  final String? league;
  final String? venue;
  final String? player;
  final String? role;
  final dynamic duration; // Consider using a specific type if possible
  final String? time;
  final String? teams;
  final String? umpires;
  final String? image1;
  final String? image2;

  Createleague({
    required this.id, // Make id required
    this.league,
    this.venue,
    this.player,
    this.role,
    this.duration,
    this.time,
    this.teams,
    this.umpires,
    this.image1,
    this.image2,
  });

  // Convert Createleague instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include id in the JSON representation
      'league': league,
      'venue': venue,
      'player': player,
      'role': role,
      'duration': duration,
      'time': time,
      'teams': teams,
      'umpires': umpires,
      'image1': image1,
      'image2': image2,
    };
  }

  // Create Createleague instance from JSON map
  factory Createleague.fromJson(Map<String, dynamic> json) {
    return Createleague(
      id: json['id'] as String,
      league: json['league'] as String?,
      venue: json['venue'] as String?,
      player: json['player'] as String?,
      role: json['role'] as String?,
      duration: json['duration'], // Keep dynamic if duration can vary
      time: json['time'] as String?,
      teams: json['teams'] as String?,
      umpires: json['umpires'] as String?,
      image1: json['image1'] as String?,
      image2: json['image2'] as String?,
    );
  }

  // Create Createleague instance from a Map (e.g., Firestore document)
  factory Createleague.fromMap(Map<String, dynamic> data, String id) {
    return Createleague(
      id: id,
      league: data['league'] as String?,
      venue: data['venue'] as String?,
      player: data['player'] as String?,
      role: data['role'] as String?,
      duration: data['duration'], // Keep dynamic if duration can vary
      time: data['time'] as String?,
      teams: data['teams'] as String?,
      umpires: data['umpires'] as String?,
      image1: data['image1'] as String?,
      image2: data['image2'] as String?,
    );
  }
}
