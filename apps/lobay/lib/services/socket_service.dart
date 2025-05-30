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
      print('Socket connected');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      print('Socket disconnected');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });

    socket.onConnectError((error) {
      print('Connection error: $error');
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
    } else {
      print('Socket is not connected');
    }
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void off(String event) {
    socket.off(event);
  }

  bool get isConnected => _isConnected;
}
