// User roles
enum UserRole { customer, mitra, admin }

extension UserRoleExt on UserRole {
  String get name {
    switch (this) {
      case UserRole.customer:
        return 'CUSTOMER';
      case UserRole.mitra:
        return 'MITRA';
      case UserRole.admin:
        return 'ADMIN';
    }
  }

  static UserRole fromString(String s) {
    switch (s.toUpperCase()) {
      case 'MITRA':
        return UserRole.mitra;
      case 'ADMIN':
        return UserRole.admin;
      default:
        return UserRole.customer;
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final UserRole role;
  final String status;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    this.status = 'ACTIVE',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'],
        role: UserRoleExt.fromString(json['role'] ?? 'CUSTOMER'),
        status: json['status'] ?? 'ACTIVE',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'role': role.name,
        'status': status,
      };
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        accessToken: json['access_token'] ?? '',
        refreshToken: json['refresh_token'] ?? '',
      );
}

class LoginRequest {
  final String phone;
  final String password;

  const LoginRequest({required this.phone, required this.password});

  Map<String, dynamic> toJson() => {'phone': phone, 'password': password};
}

class RegisterRequest {
  final String name;
  final String phone;
  final String? email;
  final String password;

  const RegisterRequest({
    required this.name,
    required this.phone,
    this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      };
}
