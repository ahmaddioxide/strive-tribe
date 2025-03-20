import 'package:flutter/material.dart';
import 'package:lobay/features/home/widgets/activities_tile.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: 20,
        itemBuilder: (context, index) {
      return ActivitiesTile(
        title: 'Activity $index',
        subtitle: 'Subtitle $index',
        date: DateTime.now(),
      );
    });
  }
}
