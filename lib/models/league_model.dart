// class League {
//   String name;
//   String venue;
//   String player;
//   String role;
//   String duration;
//   String time;
//   String team;
//   String umpire;
//   String? imagePath1;
//   String? imagePath2;

//   League({
//     required this.name,
//     required this.venue,
//     required this.player,
//     required this.role,
//     required this.duration,
//     required this.time,
//     required this.team,
//     required this.umpire,
//     this.imagePath1,
//     this.imagePath2,
//   });

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'venue': venue,
//         'player': player,
//         'role': role,
//         'duration': duration,
//         'time': time,
//         'team': team,
//         'umpire': umpire,
//         'imagePath1': imagePath1,
//         'imagePath2': imagePath2,
//       };

//   static League fromJson(Map<String, dynamic> json) => League(
//         name: json['name'],
//         venue: json['venue'],
//         player: json['player'],
//         role: json['role'],
//         duration: json['duration'],
//         time: json['time'],
//         team: json['team'],
//         umpire: json['umpire'],
//         imagePath1: json['imagePath1'],
//         imagePath2: json['imagePath2'],
//       );
// }