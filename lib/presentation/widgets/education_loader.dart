import 'package:flutter/material.dart';

class EducationLoader extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final double size;
  final Widget? icon;
  final String? message;

  const EducationLoader({
    super.key,
    this.primaryColor = const Color(0xFF1565C0),
    this.secondaryColor = const Color(0xFFE3F2FD),
    this.size = 60.0,
    this.icon,
    this.message,
  });

  @override
  State<EducationLoader> createState() => _EducationLoaderState();
}

class _EducationLoaderState extends State<EducationLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotationTransition(
            turns: _animation,
            child: Container(
              width: widget.size,
              height: widget.size,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: widget.secondaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: widget.icon ??
                  Icon(
                    Icons.school,
                    color: widget.primaryColor,
                    size: widget.size * 0.6,
                  ),
            ),
          ),
          if (widget.message != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                widget.message!,
                style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
