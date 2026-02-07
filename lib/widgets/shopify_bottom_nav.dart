import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class ShopifyBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final double scale; // NEW: for shrinking animation
  final double opacity; // NEW: for fading animation

  const ShopifyBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.scale = 1.0, // Default full size
    this.opacity = 1.0, // Default full opacity
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 8,
            left: 50,
            right: 50,
            top: 8,
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home_rounded, 0),
                _buildNavItem(Icons.assessment_rounded, 1),
                _buildNavItem(Icons.history_rounded, 2),
                _buildNavItem(Icons.menu_rounded, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = selectedIndex == index;
    return _AnimatedNavItem(
      icon: icon,
      isSelected: isSelected,
      onTap: () => onTap(index),
    );
  }
}

class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimatedNavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();

    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted) widget.onTap();
    });
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: _isPressed ? 0.6 : 1.0,
            child: Icon(
              widget.icon,
              color: widget.isSelected ? AppColors.primary : Colors.grey[600],
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}