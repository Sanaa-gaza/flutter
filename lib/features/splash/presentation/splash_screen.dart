import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_images.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Total time includes a short hold on the final logo before moving on.
  static const Duration _duration = Duration(milliseconds: 2200);
  static const double _patternOpacity = 0.03;
  // Figma places the logo a little above the vertical center.
  static const Alignment _logoAlignment = Alignment(0, -0.07);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(() {
      if (mounted) context.go(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: _patternOpacity,
            child: Image.asset(AppImages.backgroundPattern, fit: BoxFit.cover),
          ),
          Align(
            alignment: _logoAlignment,
            child: Semantics(
              label: AppLocalizations.of(context).appTitle,
              image: true,
              child: _AnimatedLogo(animation: _controller),
            ),
          ),
        ],
      ),
    );
  }
}

/// The logo image split in two: the house mark on top and the word below.
/// The mark appears in the middle, moves up, then the word appears.
class _AnimatedLogo extends StatelessWidget {
  _AnimatedLogo({required Animation<double> animation})
    : _markIn = _curve(animation, 0, 0.32, Curves.easeOut),
      _markUp = _curve(animation, 0.32, 0.55, Curves.easeInOut),
      _wordIn = _curve(animation, 0.55, 0.77, Curves.easeOut);

  static const double _width = 102;
  // logo.png is 306x468.
  static const double _height = _width * 468 / 306;
  // The empty gap between the mark and the word sits at 63% of the height.
  static const double _splitFactor = 0.63;
  static const double _markHeight = _height * _splitFactor;
  // Moves the mark from the center of the logo box to its final place.
  static const double _markStartOffset = (_height - _markHeight) / 2;
  static const double _markStartScale = 0.85;
  static const double _wordStartOffset = 12;

  final Animation<double> _markIn;
  final Animation<double> _markUp;
  final Animation<double> _wordIn;

  static Animation<double> _curve(
    Animation<double> parent,
    double begin,
    double end,
    Curve curve,
  ) => CurvedAnimation(
    parent: parent,
    curve: Interval(begin, end, curve: curve),
  );

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(AppImages.logo, width: _width, height: _height);

    return AnimatedBuilder(
      animation: _markIn,
      builder: (context, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: _markIn.value,
            child: Transform.translate(
              offset: Offset(0, _markStartOffset * (1 - _markUp.value)),
              child: Transform.scale(
                scale: _markStartScale + (1 - _markStartScale) * _markIn.value,
                child: _LogoPart(
                  alignment: Alignment.topCenter,
                  heightFactor: _splitFactor,
                  child: image,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: _wordIn.value,
            child: Transform.translate(
              offset: Offset(0, _wordStartOffset * (1 - _wordIn.value)),
              child: _LogoPart(
                alignment: Alignment.bottomCenter,
                heightFactor: 1 - _splitFactor,
                child: image,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows only the top or bottom part of [child].
class _LogoPart extends StatelessWidget {
  const _LogoPart({
    required this.alignment,
    required this.heightFactor,
    required this.child,
  });

  final Alignment alignment;
  final double heightFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: alignment,
        heightFactor: heightFactor,
        child: child,
      ),
    );
  }
}
