/// What the customer signup form sends. Lives only in memory: the password is
/// never saved on the device.
class CustomerSignupRequest {
  const CustomerSignupRequest({
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
