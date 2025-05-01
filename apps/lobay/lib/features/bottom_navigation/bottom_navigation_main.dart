import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/features/create_activity/create_activity_screen.dart';
import 'package:lobay/features/home/home_screen.dart';
import 'package:lobay/features/inbox/inbox_screen.dart';
import 'package:lobay/features/notifications/notifications_screen.dart';
import 'package:lobay/features/players/players_screen.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';
import 'bottom_navigation_controller.dart';

class BottomNavigationScreen extends StatelessWidget {
  BottomNavigationScreen({super.key});

  final BottomNavigationController _controller =
      Get.put(BottomNavigationController());

  final List<Widget> _pages = [
    HomeScreen(),
    PlayersScreen(),
    InboxScreen(),
    NotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[_controller.currentIndex.value]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateActivityScreen());
        },
        shape: CircleBorder(),
        backgroundColor: AppColors.primaryLight,
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            color: Colors.black,
          ),
          Obx(
            () => BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 30,
              currentIndex: _controller.currentIndex.value,
              onTap: _controller.changePage,
              selectedLabelStyle: TextUtils.getStyle(
                color: AppColors.black,
              ),
              backgroundColor: AppColors.white,
              fixedColor: AppColors.black,
              items: [
                _buildBottomNavigationBarItem(
                  index: 0,
                  iconPath: Assets.svgsHomeIcon,
                  label: 'Home',
                ),
                _buildBottomNavigationBarItem(
                  index: 1,
                  iconPath: Assets.svgsPlayersIcon,
                  label: 'Players',
                ),
                _buildBottomNavigationBarItem(
                  index: 2,
                  iconPath: Assets.svgsMessagesIcon,
                  label: 'Inbox',
                ),
                _buildBottomNavigationBarItem(
                  index: 3,
                  iconPath: Assets.svgsNotificationIcon,
                  label: 'Notifications',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImageWidget(
            height: Get.height * 0.023,
            width: Get.width * 0.023,
            imagePathOrURL: iconPath,
            colorSVG: _controller.currentIndex.value == index
                ? AppColors.primaryLight
                : AppColors.grey,
          ),
          Text(
            label,
            style: TextUtils.getStyle(
              color: _controller.currentIndex.value == index
                  ? AppColors.black
                  : AppColors.grey,
            ),
          ),
          if (_controller.currentIndex.value == index)
            Container(
              height: 2,
              width: Get.width * 0.2, // Adjust the width as needed
              color: AppColors.primaryLight,
            ),
        ],
      ),
      label: '',
    );
  }
}
