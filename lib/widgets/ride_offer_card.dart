import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class RideOfferCard extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const RideOfferCard({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<RideOfferCard> createState() => _RideOfferCardState();
}

class _RideOfferCardState extends State<RideOfferCard> {
  bool _isAcceptPressed = false;
  bool _isDeclinePressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth > 600 ? 80.0 : 24.0;

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        constraints: BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person_rounded,
                      color: AppColors.primary, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    MockData.passengerName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'New',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Pickup
            _buildLocationRow(
              Icons.circle,
              MockData.pickupAddress,
              AppColors.success,
            ),
            SizedBox(height: 12),

            // Destination
            _buildLocationRow(
              Icons.location_on_rounded,
              MockData.destinationAddress,
              AppColors.primary,
            ),

            SizedBox(height: 20),

            // Price
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
                  Spacer(),
                  Text(
                    'Fixed Price',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Buttons with animation
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) {
                      HapticFeedback.lightImpact();
                      setState(() => _isAcceptPressed = true);
                    },
                    onTapUp: (_) => setState(() => _isAcceptPressed = false),
                    onTapCancel: () => setState(() => _isAcceptPressed = false),
                    child: AnimatedScale(
                      scale: _isAcceptPressed ? 0.95 : 1.0,
                      duration: Duration(milliseconds: 100),
                      child: ElevatedButton(
                        onPressed: widget.onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Accept',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) {
                      HapticFeedback.lightImpact();
                      setState(() => _isDeclinePressed = true);
                    },
                    onTapUp: (_) => setState(() => _isDeclinePressed = false),
                    onTapCancel: () => setState(() => _isDeclinePressed = false),
                    child: AnimatedScale(
                      scale: _isDeclinePressed ? 0.95 : 1.0,
                      duration: Duration(milliseconds: 100),
                      child: OutlinedButton(
                        onPressed: widget.onDecline,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textDark,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel_rounded,
                                size: 20, color: AppColors.error),
                            SizedBox(width: 8),
                            Text(
                              'Decline',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String address, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            address,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textDark,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}