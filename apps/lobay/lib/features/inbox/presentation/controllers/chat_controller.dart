import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart'
    show PreferencesManager;
import 'package:lobay/features/inbox/inbox_controller.dart';
import 'package:lobay/services/socket_service.dart';

class ChatController extends GetxController {
  final SocketService socketService = SocketService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  late StreamController<Map<String, dynamic>> messageStreamController;
  late Stream<Map<String, dynamic>> messageStream;
  StreamSubscription? _messageSubscription;

  final String recipientId;
  final String recipientName;
  final String recipientImage;
  // final String roomId;
  RxString currentUserId = ''.obs;

  ChatController({
    required this.recipientId,
    required this.recipientName,
    required this.recipientImage,
    // required this.roomId,
  }) {
    messageStreamController =
        StreamController<Map<String, dynamic>>.broadcast();
    messageStream = messageStreamController.stream;
  }

  @override
  void onInit() {
    super.onInit();
    _setupSocketListeners();
    _requestChatHistory();
    _listenToMessageStream();
  }

  void _listenToMessageStream() {
    _messageSubscription = messageStream.listen((message) {
      log('New message received in stream: $message');
      if (message['recipientId'] == recipientId ||
          message['senderId'] == recipientId ||
          message['senderId'] == currentUserId.value ||
          message['recipientId'] == currentUserId.value) {
        messages.add(message);
        messages.refresh();
        _scrollToBottom();
      }
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    currentUserId.value = await getcurrentUserId() ?? '';
    log('Current User ID: ${currentUserId.value}');
  }

  void _requestChatHistory() {
    log('Requesting chat history for recipientId: $recipientId');
    socketService.emit('getAllChat', {'recipientId': recipientId});
  }

  Future<String?> getcurrentUserId() async =>
      await PreferencesManager.getInstance().getStringValue('userId', '');

  void _setupSocketListeners() {
    // Listen for chat history
    socketService.on('historyMessage', (data) {
      log('historyMessage received in chat controller: $data');
      if (data['success'] == true && data['messages'] != null) {
        final List<dynamic> historyMessages = data['messages'];
        messages.clear(); // Clear existing messages
        messages.addAll(historyMessages
            .map((msg) => {
                  'content': msg['content'],
                  'senderId': msg['senderId'],
                  'recipientId': msg['recipientId'],
                  'timestamp': DateTime.parse(msg['timestamp']),
                  'read': msg['read'],
                  'roomId': msg['roomId'],
                })
            .toList());
        log('History messages loaded: ${messages.length} messages');
        // Force UI update
        messages.refresh();
        // Add a small delay to ensure UI is ready
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollToBottom();
        });
      }
    });

    // Listen for new messages
    socketService.on('receiveMessage', (data) {
      log('receiveMessage received in chat controller: $data');
      log('Current messages count before adding: ${messages.length}');

      if (!messageStreamController.isClosed) {
        final newMessage = {
          'content': data['content'],
          'senderId': data['senderId'],
          'recipientId': data['recipientId'],
          'timestamp': DateTime.parse(data['timestamp']),
          'read': data['read'],
          'roomId': data['roomId'],
        };

        // Add message to stream
        messageStreamController.add(newMessage);
      }
    });

    // Listen for chat rooms update
    socketService.on('chatRooms', (data) {
      log('chatRooms event received: $data');
      // Update inbox controller if it exists
      if (Get.isRegistered<InboxController>()) {
        final inboxController = Get.find<InboxController>();
        if (data['success'] == true && data['rooms'] != null) {
          inboxController.chatRooms.value =
              List<Map<String, dynamic>>.from(data['rooms']);
        }
      }
    });
  }

  // void _loadSampleMessages() {
  //   messages.addAll([
  //     {
  //       'content': 'Hello! How are you?',
  //       'isMe': true,
  //       'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
  //     },
  //     {
  //       'content': 'Hi! I\'m good, thanks for asking. How about you?',
  //       'isMe': false,
  //       'timestamp': DateTime.now().subtract(const Duration(minutes: 4)),
  //     },
  //     {
  //       'content': 'I\'m doing great! Just working on some new features.',
  //       'isMe': true,
  //       'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
  //     },
  //   ]);
  // }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final message = {
      'recipientId': recipientId,
      'content': messageController.text,
      'senderId': currentUserId.value,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
      'roomId': recipientId, // Using recipientId as roomId for sent messages
    };

    log('Sending message: $message');
    // if (!messageStreamController.isClosed) {
    //   messageStreamController.add(message);
    // }
    socketService.sendMessage(recipientId, messageController.text);
    _scrollToBottom();
    messageController.clear();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    if (!messageStreamController.isClosed) {
      messageStreamController.close();
    }
    super.onClose();
  }
}
