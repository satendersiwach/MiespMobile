import 'dart:async';

import 'package:flutter/foundation.dart';
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
      debugPrint('[ScannerEvent] raw=${result?.toString()}');
      if (result != null && result != '') {
        String barcode = parseBarcode(result.toString());
        debugPrint('[ScannerEvent] parsed="$barcode" handlers=${_handlerStack.length}');
        if (barcode.isNotEmpty && _handlerStack.isNotEmpty) {
          _handlerStack.last(barcode);
        }
      }
    }, onError: (error) {
      debugPrint('[ScannerEvent] error=$error');
    });
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _handlerStack.clear();
  }
}

/// Known scanner symbology prefixes. Only strip the prefix when it matches one
/// of these — this prevents raw barcodes whose values happen to contain a colon
/// from being incorrectly parsed.
const _knownSymbologies = {
  'CODE128', 'CODE39', 'CODE93', 'CODE11',
  'EAN13', 'EAN8', 'EAN128', 'EAN',
  'UPCA', 'UPCE', 'UPC',
  'QR', 'QRCODE', 'DATAMATRIX', 'PDF417', 'AZTEC',
  'ITF', 'ITF14', 'CODABAR', 'MSI', 'RSS14',
  'GS1', 'GS1_128',
};

/// Parses the raw string from the hardware scanner.
///
/// Handles two formats:
///   - Plain barcode value with no symbology info: returned as-is.
///   - `SYMBOLOGY:data:length` (some scanners prefix the symbology and append
///     the data length): only the `data` portion is returned.
///
/// The symbology-stripping only fires when the first segment is a recognised
/// symbology name AND the last segment is a pure integer — this avoids
/// corrupting barcode values that legitimately contain colons (e.g. batch
/// numbers like "LOT:20240101" or QR codes with URLs).
String parseBarcode(String raw) {
  String value = raw.trim();

  // Some scanners append a newline after each scan; take only the first line.
  if (value.contains('\n')) {
    value = value.split('\n')[0].trim();
  }

  if (value.contains(':')) {
    final parts = value.split(':');

    // Guard: need at least 3 parts for the symbology:data:length pattern.
    if (parts.length >= 3) {
      final prefix = parts.first.toUpperCase().replaceAll(RegExp(r'\s+'), '');
      final suffix = parts.last;
      final suffixIsNumeric = RegExp(r'^\d+$').hasMatch(suffix);

      if (_knownSymbologies.contains(prefix) && suffixIsNumeric) {
        // Strip the leading symbology and the trailing length counter.
        return parts.sublist(1, parts.length - 1).join(':').trim();
      }
    } else if (parts.length == 2) {
      final prefix = parts.first.toUpperCase().replaceAll(RegExp(r'\s+'), '');
      if (_knownSymbologies.contains(prefix)) {
        // Format: "SYMBOLOGY:data" without a length field.
        return parts[1].trim();
      }
    }
    // Colon is part of the actual barcode value — return unchanged.
  }

  return value;
}
