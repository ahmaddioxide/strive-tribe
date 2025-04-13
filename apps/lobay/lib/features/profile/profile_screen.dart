import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/features/profile/edit_profile/edit_profile_controller.dart';
import 'package:lobay/features/profile/edit_profile/edit_profile_screen.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import '../../generated/assets.dart';
import '../../utilities/theme_utils/app_colors.dart';

class ProfileScreen extends StatelessWidget with DeviceSizeUtil {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final editProfileController = Get.find<EditProfileController>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Profile',
                style: TextUtils.getStyle(
                  color: AppColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.01),
              Obx(() {
                if (editProfileController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final bool ifImageExists =
                    editProfileController.userModel.value == null ||
                        (editProfileController
                                    .userModel.value!.user.profileImage ==
                                null ||
                            editProfileController
                                .userModel.value!.user.profileImage.isEmpty);
                return Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: height * 0.06,
                        backgroundColor: AppColors.grey,
                        child: ClipOval(
                          child: AppImageWidget(
                            networkImage: !ifImageExists,
                            imagePathOrURL: !ifImageExists
                                ? editProfileController
                                    .userModel.value!.user.profileImage
                                : Assets.imagesPlaceholderPerson,
                            height: height * 0.11,
                            width: height * 0.11,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        editProfileController
                                .userModel.value?.user.gamesPlayed.length
                                .toString() ??
                            '0',
                        style: TextUtils.getStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Games Played',
                        style: TextUtils.getStyle(
                          color: AppColors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: height * 0.01),
              Text(
                'Account',
                style: TextUtils.getStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height * 0.01),
              Card(
                color: AppColors.border,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_outline_rounded),
                      title: Text(
                        'Edit Profile',
                        style: TextUtils.getStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: AppColors.grey),
                      onTap: () {
                        Get.to(
                          () => EditProfileScreen(),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.hourglass_empty_rounded),
                      title: Text(
                        'Scheduled Activities',
                        style: TextUtils.getStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: AppColors.grey),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.sports_tennis_outlined),
                      title: Text(
                        'My Activities',
                        style: TextUtils.getStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: AppColors.grey),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'Support & About',
                style: TextUtils.getStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height * 0.01),
              Card(
                color: AppColors.border,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.flag_outlined),
                      title: Text(
                        'Report a problem',
                        style: TextUtils.getStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: AppColors.grey),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.format_align_justify_rounded),
                      title: Text(
                        'Terms and Policies',
                        style: TextUtils.getStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: AppColors.grey),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              Card(
                color: AppColors.border,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.logout_rounded, color: AppColors.red),
                      title: Text(
                        'Logout',
                        style: TextUtils.getStyle(
                          color: AppColors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: AppColors.red),
                      onTap: () {
                        editProfileController.showLogoutAlert(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
