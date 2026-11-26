import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';

/// Step 1 of the craftsman signup, kept in memory for step 2. Never saved to
/// disk. Auto-dispose: it is dropped (with the password) once both steps are
/// closed.
class CraftsmanSignupDraft extends Notifier<PersonalInfo?> {
  @override
  PersonalInfo? build() => null;

  void savePersonalInfo(PersonalInfo info) => state = info;

  void clear() => state = null;
}

final craftsmanSignupDraftProvider =
    NotifierProvider.autoDispose<CraftsmanSignupDraft, PersonalInfo?>(
      CraftsmanSignupDraft.new,
    );
