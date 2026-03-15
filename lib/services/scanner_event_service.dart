import 'dart:async';

import 'package:flutter/services.dart';

class ScannerEventService {
  static final ScannerEventService _instance = ScannerEventService._internal();
  factory ScannerEventService() => _instance;
  ScannerEventService._internal();

  static const EventChannel _eventChannel = EventChannel('scannerStream');
  StreamSubscription? _subscription;

  final List<void Function(String barcode)> _handlerStack = [];

  /// Register a scan handler. Only the most recently pushed handler receives events.
  void pushHandler(void Function(String barcode) handler) {
    _handlerStack.add(handler);
  }

  /// Remove a scan handler. When the top handler is removed, the previous one becomes active.
  void removeHandler(void Function(String barcode) handler) {
    _handlerStack.remove(handler);
  }

  void init() {
    if (_subscription != null) return;
    _subscription = _eventChannel.receiveBroadcastStream().listen((result) {
      if (result != null && result != '') {
        String barcode = result.toString();
        if (barcode.contains('\n')) {
          barcode = barcode.split('\n')[0];
        }
        if (barcode.contains(':')) {
          List<String> parts = barcode.split(':');
          if (parts.length >= 2) {
            barcode = parts[1];
          }
        }
        if (_handlerStack.isNotEmpty) {
          _handlerStack.last(barcode);
        }
      }
    }, onError: (error) {
      // Error from EventChannel
    });
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _handlerStack.clear();
  }
}
