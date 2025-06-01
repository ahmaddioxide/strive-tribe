import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lobay/features/inbox/presentation/controllers/chat_controller.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

import '../../../../utilities/mixins/device_size_util.dart';

class ChatScreen extends StatelessWidget with DeviceSizeUtil {
  final String recipientId;
  final String recipientName;
  final String recipientImage;
  // final String roomId;

  ChatScreen({
    super.key,
    required this.recipientId,
    required this.recipientName,
    required this.recipientImage,
    // required this.roomId,
  }) {
    Get.put(ChatController(
      recipientId: recipientId,
      recipientName: recipientName,
      recipientImage: recipientImage,
      // roomId: roomId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final height = getDeviceHeight();
    final width = getDeviceWidth();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(recipientImage),
              radius: width * 0.05,
            ),
            SizedBox(width: 10),
            Text(
              recipientName,
              style: TextUtils.getStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return StreamBuilder<Map<String, dynamic>>(
                stream: controller.messageStream,
                initialData: null,
                builder: (context, snapshot) {
                  return ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      final isMe =
                          message['senderId'] == controller.currentUserId.value;

                      // Add date separator if needed
                      Widget? dateSeparator;
                      if (index == 0 ||
                          !_isSameDay(
                            _parseTimestamp(
                                controller.messages[index - 1]['timestamp']),
                            _parseTimestamp(message['timestamp']),
                          )) {
                        dateSeparator = Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getDateSeparator(
                                    _parseTimestamp(message['timestamp'])),
                                style: TextUtils.getStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryLight,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          if (dateSeparator != null) dateSeparator,
                          Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? AppColors.primaryLight
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['content'],
                                    style: TextUtils.getStyle(
                                      fontSize: 16,
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTimestamp(message['timestamp']),
                                    style: TextUtils.getStyle(
                                      fontSize: 12,
                                      color: isMe
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }),
          ),
          Container(
            width: width,
            height: height * 0.1,
            padding: EdgeInsets.only(
                left: width * 0.05,
                right: width * 0.05,
                bottom: height * 0.03,
                top: height * 0.01),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(20),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  iconSize: 30,
                  onPressed: controller.sendMessage,
                  icon: const Icon(Icons.send),
                  color: AppColors.primaryLight,
                ),
              ],
            ),
          ),
          // SizedBox(height: height * 0.03),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is DateTime) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (timestamp is String) {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '';
  }

  String _getDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is DateTime) {
      return timestamp;
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return DateTime.now();
  }
}
