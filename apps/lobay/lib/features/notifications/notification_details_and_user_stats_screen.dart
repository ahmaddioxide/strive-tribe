import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/features/notifications/user_stat_controller.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class NotificationAndUserStatsScreen extends StatelessWidget
    with DeviceSizeUtil {
  final String requestorId;
  final String activityId;
  final String participationId;
  final String notificationId;

  const NotificationAndUserStatsScreen(
      {super.key,
      required this.requestorId,
      required this.activityId,
      required this.participationId,
      required this.notificationId});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final UserStatController _userStatController =
        Get.put(UserStatController());
    _userStatController.requestorId.value = requestorId;
    _userStatController.activityId.value = activityId;
    _userStatController.participationId.value = participationId;
    _userStatController.notificationId.value = notificationId;

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
                          ?.basicInfo?.profileImage ??
                      '',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userStatController.userStatsResponseModel
                                        .value!.data?.basicInfo?.name ??
                                    '',
                                style: TextStyle(
                                  fontSize: height * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'Sport: ${_userStatController.userStatsResponseModel.value!.data?.activityDetails?.activity ?? ''}',
                                style: TextUtils.getStyle(
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.message_rounded,
                              color: AppColors.primaryLight,
                              size: height * 0.04,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primaryLight,
                            size: height * 0.03,
                          ),
                          SizedBox(width: width * 0.02),
                          Text(
                            '${_userStatController.userStatsResponseModel.value!.data?.basicInfo?.location?.placeName ?? ''}, ${_userStatController.userStatsResponseModel.value!.data?.basicInfo?.location?.state ?? ''}',
                            style: TextUtils.getStyle(
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Player Activities',
                        style: TextUtils.getStyle(
                          fontSize: height * 0.022,
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        color: AppColors.primaryLight,
                        thickness: 1,
                      ),
                      SizedBox(height: height * 0.01),
                      ListTile(
                        leading: Icon(
                          Icons.speed_rounded,
                          color: AppColors.primaryLight,
                          size: 45,
                        ),
                        title: Text(
                          'Player Level',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Beginner',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withAlpha(100),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      ListTile(
                        leading: Icon(
                          Icons.sports_baseball_rounded,
                          color: AppColors.primaryLight,
                          size: 45,
                        ),
                        title: Text(
                          'Activities',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${_userStatController.userStatsResponseModel.value!.data?.totalActivities ?? 0} total activities',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withAlpha(100),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      ListTile(
                        leading: Icon(
                          Icons.calendar_month,
                          color: AppColors.primaryLight,
                          size: 45,
                        ),
                        title: Text(
                          'Activities in the last 30 days',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${_userStatController.userStatsResponseModel.value!.data?.totalActivities ?? 0}  activities',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withAlpha(100),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      ListTile(
                        leading: Icon(
                          Icons.calendar_month,
                          color: AppColors.primaryLight,
                          size: 45,
                        ),
                        title: Text(
                          'Opponents',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${_userStatController.userStatsResponseModel.value!.data?.totalActivities ?? 0}  opponents',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withAlpha(100),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //rounded back button
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              onPressed: () {
                                Get.back();
                              },
                              color: AppColors.white,
                              iconSize: 30,
                            ),
                          ),

                          Obx(
                            () {
                              return ElevatedButton(
                                onPressed: () async {
                                  await _userStatController
                                      .acceptRequest(
                                          notificationId: notificationId,
                                          participationId: participationId)
                                      .then((value) {
                                    if (value) {
                                      Get.back();
                                      AppSnackbar.showSuccessSnackBar(
                                          message: 'Request accepted');
                                    } else {
                                      AppSnackbar.showErrorSnackBar(
                                          message: 'Failed to accept request');
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(width * 0.7, height * 0.07),
                                  backgroundColor: AppColors.primaryLight,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: _userStatController.isJoining.value
                                    ? CircularProgressIndicator()
                                    : Text(
                                        'Accept',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
