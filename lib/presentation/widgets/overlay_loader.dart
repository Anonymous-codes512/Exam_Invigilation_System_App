import 'package:flutter/material.dart';
import 'education_loader.dart';

class OverlayLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const OverlayLoader({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: EducationLoader(
              message: message ?? 'Loading...',
            ),
          ),
      ],
    );
  }
}
