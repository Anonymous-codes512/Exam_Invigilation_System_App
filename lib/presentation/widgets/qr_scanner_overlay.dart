import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'qr_scanner_widget.dart';

class QRScannerOverlay extends StatelessWidget {
  final QRScanType scanType;

  const QRScannerOverlay({
    super.key,
    required this.scanType,
  });

  @override
  Widget build(BuildContext context) {
    final scanAreaSize = MediaQuery.of(context).size.width * 0.7;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Custom scan overlay
              Container(
                width: scanAreaSize,
                height: scanAreaSize,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: scanType == QRScanType.teacher
                        ? Colors.blue
                        : Colors.green,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Stack(
                  children: [
                    // Top-left corner
                    Positioned(
                      top: 0,
                      left: 0,
                      child: _buildCorner(scanType == QRScanType.teacher
                          ? Colors.blue
                          : Colors.green),
                    ),
                    // Top-right corner
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.rotate(
                        angle: Math.pi / 2,
                        child: _buildCorner(scanType == QRScanType.teacher
                            ? Colors.blue
                            : Colors.green),
                      ),
                    ),
                    // Bottom-right corner
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Transform.rotate(
                        angle: Math.pi,
                        child: _buildCorner(scanType == QRScanType.teacher
                            ? Colors.blue
                            : Colors.green),
                      ),
                    ),
                    // Bottom-left corner
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Transform.rotate(
                        angle: -Math.pi / 2,
                        child: _buildCorner(scanType == QRScanType.teacher
                            ? Colors.blue
                            : Colors.green),
                      ),
                    ),
                  ],
                ),
              ),

              // Instruction text
              Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  scanType == QRScanType.teacher
                      ? 'Scan teacher QR code to mark attendance'
                      : 'Scan student QR code to mark attendance',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color, width: 5),
          left: BorderSide(color: color, width: 5),
        ),
      ),
    );
  }
}
