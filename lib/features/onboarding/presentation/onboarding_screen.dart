import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_animations.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/outlined_app_button.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/onboarding/data/onboarding_storage.dart';
import 'package:flutter_sanaa_app/features/onboarding/presentation/widgets/onboarding_animation.dart';
import 'package:flutter_sanaa_app/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const List<String> _animations = [
    AppAnimations.onboarding1,
    AppAnimations.onboarding2,
    AppAnimations.onboarding3,
  ];
  static const Duration _pageDuration = Duration(milliseconds: 350);

  // Sizes from the Figma onboarding frames.
  static const EdgeInsets _cardMargin = EdgeInsets.fromLTRB(14, 21, 14, 0);
  static const double _cardHeight = 420;
  // The card keeps its Figma height and only shrinks when the screen is too
  // short. The large flex gives it the free space before the spacer gets any.
  static const int _cardFlex = 1000;
  static const double _cardToIndicator = 22;
  static const double _indicatorToTitle = 46;
  static const double _titleToBody = 2;
  static const double _bodyMinHeight = 67;
  static const double _bodyToButtons = 47;
  static const double _buttonsGap = 16;
  static const EdgeInsets _textPadding = EdgeInsets.symmetric(horizontal: 32);
  static const EdgeInsets _buttonsPadding = EdgeInsets.fromLTRB(32, 0, 32, 30);

  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _animations.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) => _pageController.animateToPage(
    page,
    duration: _pageDuration,
    curve: Curves.easeInOut,
  );

  Future<void> _finish() async {
    try {
      await ref.read(onboardingStorageProvider).markSeen();
    } on Exception {
      // Not saved: onboarding shows once more next time, nothing breaks.
    }
    if (mounted) context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titles = [
      l10n.onboardingTitle1,
      l10n.onboardingTitle2,
      l10n.onboardingTitle3,
    ];
    final bodies = [
      l10n.onboardingBody1,
      l10n.onboardingBody2,
      l10n.onboardingBody3,
    ];

    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Flexible(
                flex: _cardFlex,
                child: Padding(
                  padding: _cardMargin,
                  child: SizedBox(
                    height: _cardHeight,
                    child: _AnimationCard(
                      skipLabel: l10n.onboardingSkip,
                      onSkip: _finish,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _animations.length,
                        onPageChanged: (page) =>
                            setState(() => _currentPage = page),
                        itemBuilder: (context, index) => Center(
                          child: OnboardingAnimation(
                            asset: _animations[index],
                            isActive: index == _currentPage,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: _cardToIndicator),
              OnboardingPageIndicator(
                count: _animations.length,
                currentIndex: _currentPage,
              ),
              const SizedBox(height: _indicatorToTitle),
              Padding(
                padding: _textPadding,
                child: AnimatedSwitcher(
                  duration: _pageDuration,
                  child: Column(
                    key: ValueKey(_currentPage),
                    children: [
                      Text(
                        titles[_currentPage],
                        style: AppTextStyles.onboardingTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: _titleToBody),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: _bodyMinHeight,
                        ),
                        child: Text(
                          bodies[_currentPage],
                          style: AppTextStyles.onboardingBody,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: _bodyToButtons),
              const Spacer(),
              Padding(padding: _buttonsPadding, child: _buildButtons(l10n)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(AppLocalizations l10n) {
    if (_isLastPage) {
      return PrimaryButton(
        label: l10n.onboardingStart,
        height: AppSizes.buttonHeightLarge,
        onPressed: _finish,
      );
    }

    final next = PrimaryButton(
      label: l10n.onboardingNext,
      height: AppSizes.buttonHeightLarge,
      onPressed: () => _goToPage(_currentPage + 1),
    );
    if (_currentPage == 0) return next;

    return Row(
      spacing: _buttonsGap,
      children: [
        Expanded(child: next),
        Expanded(
          child: OutlinedAppButton.light(
            label: l10n.backButton,
            height: AppSizes.buttonHeightLarge,
            onPressed: () => _goToPage(_currentPage - 1),
          ),
        ),
      ],
    );
  }
}

class _AnimationCard extends StatelessWidget {
  const _AnimationCard({
    required this.skipLabel,
    required this.onSkip,
    required this.child,
  });

  final String skipLabel;
  final VoidCallback onSkip;
  final Widget child;

  static const double _skipTop = 13;
  static const double _skipEnd = 10;
  static const Size _skipSize = Size(50, 27.5);

  @override
  Widget build(BuildContext context) {
    final skipRadius = BorderRadius.circular(AppRadius.field);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: ColoredBox(
        color: AppColors.primaryLightActive,
        child: Stack(
          children: [
            Positioned.fill(child: child),
            PositionedDirectional(
              top: _skipTop,
              end: _skipEnd,
              child: Material(
                color: Colors.white,
                borderRadius: skipRadius,
                child: InkWell(
                  borderRadius: skipRadius,
                  onTap: onSkip,
                  child: SizedBox.fromSize(
                    size: _skipSize,
                    child: Center(
                      child: Text(skipLabel, style: AppTextStyles.skip),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
