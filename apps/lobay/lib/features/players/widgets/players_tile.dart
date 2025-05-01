import 'package:flutter/material.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';

class PlayersTile extends StatelessWidget {
  const PlayersTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            'https://example.com/profile_image.jpg', // Replace with actual image URL
          ),
        ),
        title: Text(
          'Player Name',
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
              '10 games played]',
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
