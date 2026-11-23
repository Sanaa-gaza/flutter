import 'package:flutter_sanaa_app/features/reference_data/domain/reference_data_repository.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';

/// Sample lists used until the backend sends the mobile app API.
class MockReferenceDataRepository implements ReferenceDataRepository {
  // A short wait so screens show their loading state like a real request.
  static const Duration _delay = Duration(milliseconds: 600);

  static const List<ReferenceItem> _governorates = [
    ReferenceItem(id: 1, name: 'شمال غزة'),
    ReferenceItem(id: 2, name: 'غزة'),
    ReferenceItem(id: 3, name: 'دير البلح'),
    ReferenceItem(id: 4, name: 'خان يونس'),
    ReferenceItem(id: 5, name: 'رفح'),
  ];

  static const Map<int, List<ReferenceItem>> _areas = {
    1: [
      ReferenceItem(id: 1, name: 'جباليا'),
      ReferenceItem(id: 2, name: 'بيت لاهيا'),
    ],
    2: [
      ReferenceItem(id: 3, name: 'الرمال'),
      ReferenceItem(id: 4, name: 'الشجاعية'),
      ReferenceItem(id: 5, name: 'تل الهوا'),
    ],
    3: [
      ReferenceItem(id: 6, name: 'النصيرات'),
      ReferenceItem(id: 7, name: 'المغازي'),
    ],
    4: [
      ReferenceItem(id: 8, name: 'عبسان'),
      ReferenceItem(id: 9, name: 'بني سهيلا'),
    ],
    5: [
      ReferenceItem(id: 10, name: 'تل السلطان'),
      ReferenceItem(id: 11, name: 'الشابورة'),
    ],
  };

  static const List<ReferenceItem> _services = [
    ReferenceItem(id: 1, name: 'كهرباء'),
    ReferenceItem(id: 2, name: 'سباكة'),
    ReferenceItem(id: 3, name: 'نجارة'),
    ReferenceItem(id: 4, name: 'دهان'),
    ReferenceItem(id: 5, name: 'بلاط'),
  ];

  @override
  Future<List<ReferenceItem>> getGovernorates() async {
    await Future<void>.delayed(_delay);
    return _governorates;
  }

  @override
  Future<List<ReferenceItem>> getAreas(int governorateId) async {
    await Future<void>.delayed(_delay);
    return _areas[governorateId] ?? const [];
  }

  @override
  Future<List<ReferenceItem>> getServices() async {
    await Future<void>.delayed(_delay);
    return _services;
  }
}
