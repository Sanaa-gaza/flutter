/// The personal info step shared by every signup form. Lives only in memory:
/// the password is never saved on the device.
class PersonalInfo {
  const PersonalInfo({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    required this.governorateId,
    required this.address,
  });

  final String fullName;

  /// Full number with the country code, e.g. `+970599123456`.
  final String phone;
  final String email;
  final String password;
  final int governorateId;
  final String address;
}
