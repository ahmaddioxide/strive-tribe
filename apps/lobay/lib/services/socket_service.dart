import 'dart:developer';

import 'package:lobay/core/network/app_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../core/shared_preferences/shared_pref.dart';

class SocketService {
  IO.Socket? socket;
  final String _baseUrl = AppConfig.baseUrl;
  bool _isConnected = false;

  // Singleton pattern
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  Future<void> initialize() async {
    final token =
        await PreferencesManager.getInstance().getStringValue('token', '');
    if (token == null) {
      throw Exception('No authentication token found');
    }

    socket = IO.io(_baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'Authorization': 'Bearer $token'}
    });

    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    if (socket == null) return;

    socket!.onConnect((_) {
      _isConnected = true;
      log('Socket connected');
    });

    socket!.onDisconnect((_) {
      _isConnected = false;
      log('Socket disconnected');
    });

    socket!.onError((error) {
      log('Socket error: $error');
    });

    socket!.onConnectError((error) {
      log('Connection error: $error');
    });

    // Add chat rooms event listener
    socket!.on('chatRooms', (data) {
      log('\n=== Received Chat Rooms Data ===');
      log('Raw data type: ${data.runtimeType}');
      log('Raw data: $data');

      try {
        if (data is Map<String, dynamic>) {
          log('Data is Map<String, dynamic>');
          if (data['success'] == true && data['rooms'] != null) {
            final rooms = data['rooms'];
            log('Rooms type: ${rooms.runtimeType}');
            log('Rooms data: $rooms');

            if (rooms is List) {
              log('Total rooms: ${rooms.length}');
              for (var room in rooms) {
                log('Room type: ${room.runtimeType}');
                log('Room data: $room');
                if (room is Map<String, dynamic>) {
                  log('\nRoom ID: ${room['_id']}');
                  log('Last Message: ${room['lastMessage']}');
                  log('Last Message Time: ${room['lastMessageTimestamp']}');
                  log('Unread Count: ${room['unreadCount']}');

                  if (room['recipient'] != null &&
                      room['recipient'] is Map<String, dynamic>) {
                    final recipient = room['recipient'] as Map<String, dynamic>;
                    log('Recipient:');
                    log('  - ID: ${recipient['_id']}');
                    log('  - User ID: ${recipient['userId']}');
                    log('  - Name: ${recipient['name']}');
                    log('  - Profile Image: ${recipient['profileImage']}');
                  }
                  log('----------------------------------------');
                }
              }
            } else {
              log('Error: rooms is not a List');
            }
          } else {
            log('Error: Invalid data format or unsuccessful response');
          }
        } else {
          log('Error: data is not Map<String, dynamic>');
        }
      } catch (e, stackTrace) {
        log('Error processing chatRooms data: $e');
        log('Stack trace: $stackTrace');
      }
      log('========================================\n');
    });

    // Add new message event listener
    socket!.on('newMessage', (data) {
      log('\n=== Received New Message ===');
      log('Room ID: ${data['roomId']}');
      log('Sender ID: ${data['senderId']}');
      log('Recipient ID: ${data['recipientId']}');
      log('Content: ${data['content']}');
      log('Read Status: ${data['read']}');
      log('Message ID: ${data['_id']}');
      log('Timestamp: ${data['timestamp']}');
      log('========================================\n');
    });

    // Add message history event listener
    socket!.on('historyMessage', (data) {
      log('\n=== Received Message History ===');
      if (data['success'] == true && data['messages'] != null) {
        final messages = data['messages'] as List;
        log('Total messages: ${messages.length}');

        for (var message in messages) {
          log('\nMessage ID: ${message['_id']}');
          log('Room ID: ${message['roomId']}');
          log('Sender ID: ${message['senderId']}');
          log('Recipient ID: ${message['recipientId']}');
          log('Content: ${message['content']}');
          log('Read Status: ${message['read']}');
          log('Timestamp: ${message['timestamp']}');
          log('----------------------------------------');
        }
      } else {
        log('Error: Invalid data format or unsuccessful response');
        log('Raw data: $data');
      }
      log('========================================\n');
    });

    // Add receive message event listener
    socket!.on('receiveMessage', (data) {
      log('\n=== Received Message ===');
      log('Room ID: ${data['roomId']}');
      log('Sender ID: ${data['senderId']}');
      log('Recipient ID: ${data['recipientId']}');
      log('Content: ${data['content']}');
      log('Read Status: ${data['read']}');
      log('Message ID: ${data['_id']}');
      log('Timestamp: ${data['timestamp']}');
      log('========================================\n');
    });
  }

  void connect() {
    if (!_isConnected && socket != null) {
      socket!.connect();
    }
  }

  void disconnect() {
    if (_isConnected && socket != null) {
      socket!.disconnect();
    }
  }

  void emit(String event, dynamic data) {
    if (_isConnected && socket != null) {
      socket!.emit(event, data);
      log('Emitting $event event with data: $data');
    } else {
      log('Socket is not connected');
    }
  }

  void on(String event, Function(dynamic) callback) {
    if (socket != null) {
      socket!.on(event, callback);
    }
  }

  void off(String event) {
    if (socket != null) {
      socket!.off(event);
    }
  }

  bool get isConnected => _isConnected;

  /// Emits getAllChat event to fetch all chat rooms for a recipient
  void getAllChat(String recipientId) {
    if (_isConnected && socket != null) {
      final data = {
        'recipientId': recipientId,
      };
      log('Emitting getAllChat event with data: $data');
      socket!.emit('getAllChat', data);
    } else {
      log('Socket is not connected');
    }
  }

  void getAllRooms() {
    if (_isConnected && socket != null) {
      log('getAllRooms emitting');
      socket!.emit('getAllRoom');
      log('getAllRooms emitted');
    } else {
      log('Socket is not connected');
    }
  }

  /// Emits sendMessage event to send a message to a recipient
  void sendMessage(String recipientId, String content) {
    if (_isConnected && socket != null) {
      final data = {
        'recipientId': recipientId,
        'content': content,
      };
      log('Emitting sendMessage event with data: $data');
      socket!.emit('sendMessage', data);
    } else {
      log('Socket is not connected');
    }
  }

  /// Emits markAsRead event to mark messages as read for a recipient
  void markAsRead(String recipientId) {
    if (_isConnected && socket != null) {
      final data = {
        'recipientId': recipientId,
      };
      log('Emitting markAsRead event with data: $data');
      socket!.emit('markAsRead', data);
    } else {
      log('Socket is not connected');
    }
  }
}
