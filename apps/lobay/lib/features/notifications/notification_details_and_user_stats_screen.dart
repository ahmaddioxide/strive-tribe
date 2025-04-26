import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/features/notifications/user_stat_controller.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';

class NotificationAndUserStatsScreen extends StatelessWidget
    with DeviceSizeUtil {
  final String userId;
  final String sport;

  const NotificationAndUserStatsScreen(
      {super.key, required this.userId, required this.sport});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final UserStatController _userStatController =
        Get.put(UserStatController());
    _userStatController.userId.value = userId;
    return Scaffold(
      body: Obx(
        () {
          if (_userStatController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (_userStatController.userStatsResponseModel.value == null) {
            return Center(child: Text('No data available'));
          } else {
            return Column(
              children: [
                Image.network(
                  height: height * 0.3,
                  width: width,
                  _userStatController.userStatsResponseModel.value!.data
                      .basicInfo.profileImage,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: height * 0.02),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          _userStatController.userStatsResponseModel.value!.data
                              .basicInfo.name,
                          style: TextStyle(
                            fontSize: height * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                      ],
                    )
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
}
