class LoginResponse {
  final int accountId;
  final String username;
  final String role;
  final String token;

  LoginResponse({
    required this.accountId,
    required this.username,
    required this.role,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accountId: json['accountId'],
      username: json['username'],
      role: json['role'],
      token: json['token'],
    );
  }
}
