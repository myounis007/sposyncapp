import 'package:flutter/material.dart';
import 'package:soccer_app/services/league_services.dart';

import '../models/createleague_model.dart';

class LeagueDetailsPopup extends StatefulWidget {
  final Createleague league;

  const LeagueDetailsPopup({super.key, required this.league});

  @override
  State<LeagueDetailsPopup> createState() => _LeagueDetailsPopupState();
}

class _LeagueDetailsPopupState extends State<LeagueDetailsPopup> {
  final LeagueServices _deleteLeague = LeagueServices();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.league.league ?? '',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('venue: ${widget.league.venue ?? 'N/A'}'),
                      Text('player: ${widget.league.player ?? 'N/A'}'),
                      Text('role: ${widget.league.role ?? 'N/A'}'),
                      Text('Duration: ${widget.league.duration ?? ''}'),
                      Text('league: ${widget.league.league ?? 'N/A'}'),
                      Text('time: ${widget.league.time ?? 'N/A'}'),
                      Text('teams: ${widget.league.teams ?? 'N/A'}'),
                      const SizedBox(height: 10),
                      widget.league.image1 != null
                          ? Image.network(widget.league.image1!)
                          : Container(),
                      const SizedBox(height: 10),
                      widget.league.image2 != null
                          ? Image.network(widget.league.image2!)
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                const Column(
                  children: [],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          const Color.fromARGB(255, 247, 134, 134)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () async {
                    await _deleteLeague.deleteLeague(widget.league, context);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
