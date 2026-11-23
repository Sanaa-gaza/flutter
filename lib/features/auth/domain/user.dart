/// Roles as the API names them. The app routes by the role the server
/// returns, never by a role the user picks.
enum UserRole {
  customer('customer'),
  craftsman('craftsman'),
  institution('institution'),
  contractor('contractor'),
  admin('admin');

  const UserRole(this.apiName);

  final String apiName;

  static UserRole? fromApi(Object? value) {
    for (final role in values) {
      if (role.apiName == value) return role;
    }
    return null;
  }
}

class User {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  final int id;
  final String fullName;
  final String email;
  final UserRole role;

  /// Returns null when a required field is missing or has the wrong type.
  static User? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final role = UserRole.fromApi(json['role']);
    if (id is! int || role == null) return null;
    final fullName = json['full_name'];
    final email = json['email'];
    return User(
      id: id,
      fullName: fullName is String ? fullName : '',
      email: email is String ? email : '',
      role: role,
    );
  }

  /// Only the fields the app needs are saved on the device.
  Map<String, Object?> toJson() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'role': role.apiName,
  };
}
