import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers whether onboarding was shown. Not sensitive, so plain storage
/// is fine here (the token lives in secure storage).
class OnboardingStorage {
  OnboardingStorage(this._preferences);

  final SharedPreferencesAsync _preferences;

  static const String _seenKey = 'onboarding_seen';

  Future<bool> hasSeen() async => await _preferences.getBool(_seenKey) ?? false;

  Future<void> markSeen() => _preferences.setBool(_seenKey, true);
}

final onboardingStorageProvider = Provider<OnboardingStorage>(
  (ref) => OnboardingStorage(SharedPreferencesAsync()),
);
