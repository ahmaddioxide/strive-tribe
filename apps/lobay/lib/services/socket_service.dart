import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../core/shared_preferences/shared_pref.dart';

class SocketService {
  late IO.Socket socket;
  final String _baseUrl = 'http://localhost:3000';
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
    socket.onConnect((_) {
      _isConnected = true;
      log('Socket connected');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      log('Socket disconnected');
    });

    socket.onError((error) {
      log('Socket error: $error');
    });

    socket.onConnectError((error) {
      log('Connection error: $error');
    });

    // Add chat rooms event listener
    socket.on('chatRooms', (data) {
      log('\n=== Received Chat Rooms Data ===');
      if (data['success'] == true && data['rooms'] != null) {
        final rooms = data['rooms'] as List;
        log('Total rooms: ${rooms.length}');

        for (var room in rooms) {
          log('\nRoom ID: ${room['_id']}');
          log('Last Message: ${room['lastMessage']}');
          log('Last Message Time: ${room['lastMessageTimestamp']}');
          log('Unread Count: ${room['unreadCount']}');

          if (room['recipient'] != null) {
            final recipient = room['recipient'];
            log('Recipient:');
            log('  - ID: ${recipient['_id']}');
            log('  - User ID: ${recipient['userId']}');
            log('  - Name: ${recipient['name']}');
            log('  - Profile Image: ${recipient['profileImage']}');
          }
          log('----------------------------------------');
        }
      } else {
        log('Error: Invalid data format or unsuccessful response');
        log('Raw data: $data');
      }
      log('========================================\n');
    });

    // Add new message event listener
    socket.on('newMessage', (data) {
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
    socket.on('historyMessage', (data) {
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
  }

  void connect() {
    if (!_isConnected) {
      socket.connect();
    }
  }

  void disconnect() {
    if (_isConnected) {
      socket.disconnect();
    }
  }

  void emit(String event, dynamic data) {
    if (_isConnected) {
      socket.emit(event, data);
      log('Emitting $event event with data: $data');
    } else {
      log('Socket is not connected');
    }
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void off(String event) {
    socket.off(event);
  }

  bool get isConnected => _isConnected;

  /// Emits getAllChat event to fetch all chat rooms for a recipient
  void getAllChat(String recipientId) {
    log('getAllChat: $recipientId');
    if (_isConnected) {
      final data = {
        'recipientId': recipientId,
      };
      log('Emitting getAllChat event with data: $data');
      socket.emit('getAllChat', data);
    } else {
      log('Socket is not connected');
    }
  }

  void getAllRooms() {
    if (_isConnected) {
      log('getAllRooms emitting');
      socket.emit('getAllRooms');
      log('getAllRooms emitted');
    } else {
      log('Socket is not connected');
    }
  }
}
