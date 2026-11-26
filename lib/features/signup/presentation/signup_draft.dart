import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/features/signup/domain/institution_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';

/// Step 1 of a multi-step signup, kept in memory for the next steps. Never
/// saved to disk. The providers auto-dispose: the data (with the password) is
/// dropped once every step of that signup is closed.
class SignupDraft<T> extends Notifier<T?> {
  @override
  T? build() => null;

  void save(T value) => state = value;

  void clear() => state = null;
}

final craftsmanSignupDraftProvider =
    NotifierProvider.autoDispose<SignupDraft<PersonalInfo>, PersonalInfo?>(
      SignupDraft<PersonalInfo>.new,
    );

final institutionSignupDraftProvider =
    NotifierProvider.autoDispose<
      SignupDraft<InstitutionStep1>,
      InstitutionStep1?
    >(SignupDraft<InstitutionStep1>.new);
