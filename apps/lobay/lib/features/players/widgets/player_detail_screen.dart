import 'package:flutter/material.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';

class PlayerDetailScreen extends StatelessWidget with DeviceSizeUtil {
  const PlayerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();

    return Scaffold(
      
    );
  }
}
