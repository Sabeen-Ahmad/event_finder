import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _dotPulse;

  static const _primaryColor = Color(0xFF0D0D0D);
  static const _splashDuration = Duration(milliseconds: 3200);

  @override
  void initState() {
    super.initState();
    _setStatusBar();
    _initAnimations();
    _startSequence();
  }

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  void _initAnimations() {
    // Logo: scale + fade in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text: fade + slide up
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // Loading dots pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _dotPulse = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
    _pulseController.repeat(reverse: true);
  }

  void _startSequence() {
    _logoController.forward().then((_) => _textController.forward());

    Future.delayed(_splashDuration, _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildCenter()),
            _buildLoadingDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildCenter() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(),
          const SizedBox(height: 30),
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (_, __) => Opacity(
        opacity: _logoOpacity.value,
        child: Transform.scale(
          scale: _logoScale.value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 36,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const _LogoIcon(),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (_, __) => FadeTransition(
        opacity: _textOpacity,
        child: SlideTransition(
          position: _textSlide,
          child: Column(
            children: [
              const Text(
                'EventFinder',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: _primaryColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: _taglineOpacity,
                child: _buildTagline(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dividerLine(),
        const SizedBox(width: 8),
        Text(
          'Discover events near you',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 8),
        _dividerLine(),
      ],
    );
  }

  Widget _dividerLine() => Container(
    width: 18,
    height: 1,
    color: Colors.grey.shade400,
  );

  Widget _buildLoadingDots() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 52),
      child: AnimatedBuilder(
        animation: _dotPulse,
        builder: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            // Stagger each dot by offset in pulse cycle
            final staggerOffset = i * 0.33;
            final rawValue = (_pulseController.value - staggerOffset).clamp(0.0, 1.0);
            // Map to a 0→1→0 bounce
            final bounce = rawValue < 0.5 ? rawValue * 2 : 2 - (rawValue * 2);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: 0.6 + (bounce * 0.8),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == 1 ? _primaryColor : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Extracted logo widget (single responsibility) ─────────────
class _LogoIcon extends StatelessWidget {
  const _LogoIcon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.location_on, color: Colors.white, size: 42),
        Positioned(
          top: 29,
          child: Container(
            width: 16,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 10,
            ),
          ),
        ),
      ],
    );
  }
}