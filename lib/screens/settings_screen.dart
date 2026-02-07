import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  final TextEditingController _basePriceController =
  TextEditingController(text: '15.00');
  final TextEditingController _perMileController =
  TextEditingController(text: '2.50');
  final TextEditingController _perMinuteController =
  TextEditingController(text: '0.50');

  bool _isSavePressed = false;

  // Animation controllers for entrance animations
  late AnimationController _headerAnimationController;
  late AnimationController _priceCardAnimationController;
  late AnimationController _saveButtonAnimationController;
  late AnimationController _infoCardAnimationController;

  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  late Animation<double> _priceCardFadeAnimation;
  late Animation<Offset> _priceCardSlideAnimation;

  late Animation<double> _saveButtonFadeAnimation;
  late Animation<Offset> _saveButtonSlideAnimation;

  late Animation<double> _infoCardFadeAnimation;
  late Animation<Offset> _infoCardSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Header animation
    _headerAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOut),
    );
    _headerSlideAnimation = Tween<Offset>(
      begin: Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOutCubic));

    // Price card animation
    _priceCardAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _priceCardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _priceCardAnimationController, curve: Curves.easeOut),
    );
    _priceCardSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _priceCardAnimationController, curve: Curves.easeOutCubic));

    // Save button animation
    _saveButtonAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _saveButtonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _saveButtonAnimationController, curve: Curves.easeOut),
    );
    _saveButtonSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _saveButtonAnimationController, curve: Curves.easeOutCubic));

    // Info card animation
    _infoCardAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _infoCardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _infoCardAnimationController, curve: Curves.easeOut),
    );
    _infoCardSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _infoCardAnimationController, curve: Curves.easeOutCubic));

    // Start animations with cascading delays
    _startAnimations();
  }

  void _startAnimations() {
    _headerAnimationController.forward();

    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) _priceCardAnimationController.forward();
    });

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) _saveButtonAnimationController.forward();
    });

    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _infoCardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _priceCardAnimationController.dispose();
    _saveButtonAnimationController.dispose();
    _infoCardAnimationController.dispose();
    _basePriceController.dispose();
    _perMileController.dispose();
    _perMinuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card - ANIMATED
            SlideTransition(
              position: _headerSlideAnimation,
              child: FadeTransition(
                opacity: _headerFadeAnimation,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price Configuration',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Adjust your pricing settings',
                              style: TextStyle(
                                fontSize: 13,
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
            ),

            SizedBox(height: 24),

            // Price fields card - ANIMATED
            SlideTransition(
              position: _priceCardSlideAnimation,
              child: FadeTransition(
                opacity: _priceCardFadeAnimation,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInputField(
                        'Base Price',
                        _basePriceController,
                        Icons.attach_money_rounded,
                      ),
                      SizedBox(height: 20),
                      Divider(height: 1, color: Colors.grey[200]),
                      SizedBox(height: 20),
                      _buildInputField(
                        'Per Mile Rate',
                        _perMileController,
                        Icons.route_rounded,
                      ),
                      SizedBox(height: 20),
                      Divider(height: 1, color: Colors.grey[200]),
                      SizedBox(height: 20),
                      _buildInputField(
                        'Per Minute Rate',
                        _perMinuteController,
                        Icons.schedule_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 32),

            // Save button - ANIMATED
            SlideTransition(
              position: _saveButtonSlideAnimation,
              child: FadeTransition(
                opacity: _saveButtonFadeAnimation,
                child: GestureDetector(
                  onTapDown: (_) {
                    HapticFeedback.lightImpact();
                    setState(() => _isSavePressed = true);
                  },
                  onTapUp: (_) => setState(() => _isSavePressed = false),
                  onTapCancel: () => setState(() => _isSavePressed = false),
                  child: AnimatedScale(
                    scale: _isSavePressed ? 0.97 : 1.0,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text(
                                    'Settings saved successfully!',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.all(16),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Future.delayed(Duration(milliseconds: 800), () {
                            if (mounted) Navigator.pop(context);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_rounded, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Info card - ANIMATED
            SlideTransition(
              position: _infoCardSlideAnimation,
              child: FadeTransition(
                opacity: _infoCardFadeAnimation,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Prices are fixed per trip and for display only',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textGray,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      TextEditingController controller,
      IconData icon,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onTap: () => HapticFeedback.selectionClick(),
          ),
        ),
      ],
    );
  }
}