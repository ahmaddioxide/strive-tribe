import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/features/inbox/presentation/screens/chat_screen.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';

import '../../../utilities/theme_utils/app_colors.dart';

class ChatRoomTile extends StatelessWidget with DeviceSizeUtil {
  final String roomId;
  final String recipientName;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final String profileImage;
  final String recipientId;

  const ChatRoomTile({
    super.key,
    required this.roomId,
    required this.recipientName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.profileImage,
    required this.recipientId,
  });

  void _navigateToChat() {
    Get.to(() => ChatScreen(
          recipientId: recipientId,
          recipientName: recipientName,
          recipientImage: profileImage,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return ListTile(
      onTap: _navigateToChat,
      leading: CircleAvatar(
        radius: width * 0.06,
        backgroundImage: NetworkImage(profileImage),
      ),
      title: Text(
        recipientName,
        style: TextUtils.getStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        lastMessage,
        style: TextUtils.getStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lastMessageTime,
            style: TextUtils.getStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey),
          ),
          SizedBox(height: height * 0.005),
          if (unreadCount > 0)
            Container(
              width: width * 0.05,
              height: width * 0.05,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  unreadCount.toString(),
                  style: TextUtils.getStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
