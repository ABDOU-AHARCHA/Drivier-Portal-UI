import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/ride_offer_card.dart';
import '../widgets/shopify_bottom_nav.dart';
import 'route_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isOnline = false;
  bool showRideOffer = false;
  bool isLoading = false;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  // Animation controller for drawer + bottom nav sync
  late AnimationController _drawerAnimationController;
  late Animation<double> _bottomNavScaleAnimation;
  late Animation<double> _bottomNavOpacityAnimation;
  late Animation<double> _drawerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _loadingAnimation = CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeOutCubic,
    );

    // Drawer animation controller
    _drawerAnimationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    // Bottom nav shrinks from 1.0 to 0.7 (70% size)
    _bottomNavScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));

    // Bottom nav fades from 1.0 to 0.3
    _bottomNavOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));

    // Drawer slides in (this controls the inverse animation)
    _drawerSlideAnimation = CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _drawerAnimationController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    HapticFeedback.selectionClick();
    if (index == 3) {
      // Open drawer with animation
      _drawerAnimationController.forward();
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Handle drawer close
  void _onDrawerClose() {
    _drawerAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 60 + 16 + bottomPadding;

    // Actual card height from screenshot
    final rideCardHeight = 430.0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFE8F4F8),
      extendBody: true,
      drawerScrimColor: Colors.transparent,
      endDrawerEnableOpenDragGesture: false,
      onEndDrawerChanged: (isOpened) {
        // Reverse animation when drawer closes
        if (!isOpened) {
          _onDrawerClose();
        }
      },
      endDrawer: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1.0, 0.0), // Start off-screen right
          end: Offset.zero, // End on-screen
        ).animate(_drawerSlideAnimation),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Drawer(
            backgroundColor: Color(0xFF1A1A1A),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      children: [
                        _buildDrawerItem(
                          icon: Icons.settings_rounded,
                          title: 'Settings',
                          onTap: () {
                            // Reset animation immediately before closing drawer
                            _drawerAnimationController.reset();
                            Navigator.pop(context);
                            Future.delayed(Duration(milliseconds: 300), () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      SettingsScreen(),
                                  transitionsBuilder:
                                      (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOutCubic;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 400),
                                ),
                              );
                            });
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.history_rounded,
                          title: 'History',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            // Reset animation before closing
                            _drawerAnimationController.reset();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.close_rounded, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Close',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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
      ),
      body: Stack(
        children: [
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
            child: Stack(
              children: [
                CustomPaint(
                  painter: MapGridPainter(),
                  size: Size.infinite,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.navigation_rounded,
                          size: 60, color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        isOnline ? 'Online - Ready for rides' : 'Offline',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Loading indicator with animation
          if (isOnline && isLoading)
            Positioned(
              left: 0,
              right: 0,
              bottom: navBarHeight + 80,
              child: Center(
                child: ScaleTransition(
                  scale: _loadingAnimation,
                  child: FadeTransition(
                    opacity: _loadingAnimation,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 3,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Searching for rides...',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Ride offer card
          if (isOnline)
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              left: 0,
              right: 0,
              bottom: showRideOffer ? navBarHeight + 20 : -500,
              child: RideOfferCard(
                onAccept: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                      const RouteScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.easeOutCubic;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                    ),
                  );
                },
                onDecline: () {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    showRideOffer = false;
                  });
                },
              ),
            ),

          // Online/Offline toggle - SAME ANIMATION AS CARD
          AnimatedPositioned(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOutCubic, // CHANGED: Same smooth animation as card
            left: 24,
            // Positioned ABOVE the entire card with proper spacing
            bottom: showRideOffer
                ? navBarHeight + 20 + rideCardHeight + 20  // Position well above the card
                : navBarHeight + 20, // Original position when card is hidden
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isOnline ? 'ONLINE' : 'OFFLINE',
                    style: TextStyle(
                      color: isOnline ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 12),
                  Switch(
                    value: isOnline,
                    onChanged: (value) {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        isOnline = value;
                        if (isOnline) {
                          isLoading = true;
                          _loadingController.forward();
                          Future.delayed(Duration(seconds: 2), () {
                            if (mounted && isOnline) {
                              setState(() {
                                isLoading = false;
                                showRideOffer = true;
                                _loadingController.reset();
                              });
                            }
                          });
                        } else {
                          showRideOffer = false;
                          isLoading = false;
                          _loadingController.reset();
                        }
                      });
                    },
                    activeColor: AppColors.success,
                    inactiveThumbColor: AppColors.error,
                    inactiveTrackColor: AppColors.error.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _drawerAnimationController,
        builder: (context, child) {
          return ShopifyBottomNav(
            selectedIndex: _selectedIndex,
            onTap: _onNavTap,
            scale: _bottomNavScaleAnimation.value,
            opacity: _bottomNavOpacityAnimation.value,
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.5), size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.08)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}