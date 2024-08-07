class Createleague {
  String? id;
  String? league;
  String? venue;
  String? player;
  String? role;
  dynamic duration;
  String? time;
  String? teams;
  String? umpires;
  String? image1;
  String? image2;

  Createleague({
    this.id,
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

  Map<String, dynamic> toJson() {
    return {
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

  factory Createleague.fromJson(
    Map<String, dynamic> json, String id
  ) {
    return Createleague(
      id: id,
      league: json['league'],
      venue: json['venue'],
      player: json['player'],
      role: json['role'],
      duration: json['duration'],
      time: json['time'],
      teams: json['teams'],
      umpires: json['umpires'],
      image1: json['image1'],
      image2: json['image2'],
    );
  }
}
