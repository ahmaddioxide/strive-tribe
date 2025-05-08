import 'package:flutter/material.dart';
import 'package:lobay/core/network/network_models/get_nearby_players_response_model.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';

class PlayersTile extends StatelessWidget {
  final Player player;
  const PlayersTile({super.key,required this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            player.profileImage, // Replace with actual image URL
          ),
        ),
        title: Text(
          player.name,
          style: TextUtils.getStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.bar_chart),
            SizedBox(width: 5),
            Text(
              '${player.gamesPlayed.toString()} games played',
              style: TextUtils.getStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
