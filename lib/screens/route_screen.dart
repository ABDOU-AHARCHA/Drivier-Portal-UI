import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get bottom safe area padding
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Active Trip'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Map with route
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8F4F8),
                  Color(0xFFF0F9FF),
                ],
              ),
            ),
            child: CustomPaint(
              painter: RoutePainter(),
              child: Container(),
            ),
          ),

          // Trip info card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Passenger info
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.person_rounded,
                            color: AppColors.primary, size: 24),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MockData.passengerName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.directions_car_rounded,
                                    color: AppColors.success, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  MockData.eta,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Divider(height: 1),
                  SizedBox(height: 20),

                  // Route
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_rounded,
                          color: AppColors.textGray, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${MockData.pickupAddress} → ${MockData.destinationAddress}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textGray,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Price - FIXED: Removed duplicate $ icon
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          MockData.tripPrice,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(Fixed)',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.08)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Position markers HIGHER on screen
    final pickupPoint = Offset(size.width * 0.3, size.height * 0.25);
    final destPoint = Offset(size.width * 0.7, size.height * 0.4);

    // Draw route line
    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    _drawDashedLine(canvas, pickupPoint, destPoint, linePaint);

    // Draw markers
    _drawMarker(canvas, pickupPoint, AppColors.success, 'A');
    _drawMarker(canvas, destPoint, AppColors.primary, 'B');
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 12;
    const dashSpace = 6;
    double distance = (end - start).distance;
    double dashCount = distance / (dashWidth + dashSpace);

    for (int i = 0; i < dashCount; i++) {
      double ratio1 = (i * (dashWidth + dashSpace)) / distance;
      double ratio2 = ((i * (dashWidth + dashSpace)) + dashWidth) / distance;

      Offset start1 = Offset(
        start.dx + (end.dx - start.dx) * ratio1,
        start.dy + (end.dy - start.dy) * ratio1,
      );
      Offset end1 = Offset(
        start.dx + (end.dx - start.dx) * ratio2,
        start.dy + (end.dy - start.dy) * ratio2,
      );

      canvas.drawLine(start1, end1, paint);
    }
  }

  void _drawMarker(Canvas canvas, Offset position, Color color, String label) {
    // Shadow
    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.2);
    canvas.drawCircle(position + Offset(2, 2), 24, shadowPaint);

    // Marker circle
    final markerPaint = Paint()..color = color;
    canvas.drawCircle(position, 24, markerPaint);

    // White inner circle
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(position, 18, innerPaint);

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}