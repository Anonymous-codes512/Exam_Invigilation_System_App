import 'package:flutter/material.dart';
import 'package:eis/presentation/widgets/education_loader.dart';

class LoaderService {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context, {String? message}) {
    if (_overlayEntry != null) {
      return;
    }

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: EducationLoader(
            message: message,
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
