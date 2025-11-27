import 'package:flutter/material.dart';

class ModalService {
  static final ModalService _instance = ModalService._internal();
  factory ModalService() => _instance;
  ModalService._internal();

  final List<BuildContext> _activeModalContexts = [];

  void registerModal(BuildContext context) {
    _activeModalContexts.add(context);
  }

  void unregisterModal(BuildContext context) {
    _activeModalContexts.remove(context);
  }

  void closeAllModals() {
    // Create a copy to avoid concurrent modification
    final contexts = List<BuildContext>.from(_activeModalContexts);
    for (final context in contexts) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
    _activeModalContexts.clear();
  }
}