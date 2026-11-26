import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/signup/domain/contractor_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/domain/craftsman_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/domain/institution_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';
import 'package:flutter_sanaa_app/features/signup/domain/signup_repository.dart';

/// Signup without a server, used until the backend sends the mobile app API.
///
/// Test cases: an email that starts with `taken` answers "email already
/// used". Anything else succeeds.
class MockSignupRepository implements SignupRepository {
  static const Duration _delay = Duration(milliseconds: 800);
  static const String _takenPrefix = 'taken';

  @override
  Future<String> uploadFile(String localPath) async {
    await Future<void>.delayed(_delay);
    return 'uploads/mock_${localPath.split(RegExp(r'[/\\]')).last}';
  }

  @override
  Future<void> registerCustomer(PersonalInfo info) => _register(info);

  @override
  Future<void> registerCraftsman(CraftsmanSignupRequest request) =>
      _register(request.personalInfo);

  // Sample options until the backend confirms the real list.
  static const List<ReferenceItem> _activityTypes = [
    ReferenceItem(id: 1, name: 'مقاولات وإنشاءات'),
    ReferenceItem(id: 2, name: 'صيانة وتشغيل'),
    ReferenceItem(id: 3, name: 'خدمات تعليمية'),
    ReferenceItem(id: 4, name: 'خدمات صحية'),
    ReferenceItem(id: 5, name: 'منظمة غير ربحية'),
  ];

  static const List<ReferenceItem> _workersCountOptions = [
    ReferenceItem(id: 1, name: '1 - 5'),
    ReferenceItem(id: 2, name: '6 - 10'),
    ReferenceItem(id: 3, name: '11 - 20'),
    ReferenceItem(id: 4, name: 'أكثر من 20'),
  ];

  @override
  Future<List<ReferenceItem>> getActivityTypes() async {
    await Future<void>.delayed(_delay);
    return _activityTypes;
  }

  @override
  Future<List<ReferenceItem>> getWorkersCountOptions() async {
    await Future<void>.delayed(_delay);
    return _workersCountOptions;
  }

  @override
  Future<void> registerContractor(ContractorSignupRequest request) =>
      _register(request.step1.personalInfo);

  @override
  Future<void> registerInstitution(InstitutionSignupRequest request) =>
      _register(request.step1.personalInfo);

  Future<void> _register(PersonalInfo info) async {
    await Future<void>.delayed(_delay);
    if (info.email.startsWith(_takenPrefix)) {
      throw const ServerFailure(
        statusCode: 422,
        fieldErrors: {'email': 'البريد الإلكتروني مستخدم مسبقاً.'},
      );
    }
  }
}
