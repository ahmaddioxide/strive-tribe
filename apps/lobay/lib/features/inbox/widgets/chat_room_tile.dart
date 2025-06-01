import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lobay/features/inbox/presentation/screens/chat_screen.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:intl/intl.dart' as intl;

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
        backgroundImage: CachedNetworkImageProvider(profileImage),
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
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
            (() {
              final messageDate = DateTime.parse(lastMessageTime);
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final yesterday = today.subtract(const Duration(days: 1));
              final messageDay = DateTime(
                  messageDate.year, messageDate.month, messageDate.day);

              if (messageDay == today) {
                return 'Today, ${intl.DateFormat('h:mm a').format(messageDate)}';
              } else if (messageDay == yesterday) {
                return 'Yesterday, ${intl.DateFormat('h:mm a').format(messageDate)}';
              } else {
                return intl.DateFormat('MMM d, h:mm a').format(messageDate);
              }
            })(),
            style: TextUtils.getStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey),
          ),
          SizedBox(height: height * 0.005),
          if (unreadCount > 0)
            Container(
              width: width * 0.06,
              height: width * 0.06,
              decoration: BoxDecoration(
                color: AppColors.black,
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
