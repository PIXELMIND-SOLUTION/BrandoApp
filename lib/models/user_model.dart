
class SendOtpRequest {
  final String mobileNumber;

  const SendOtpRequest({required this.mobileNumber});

  Map<String, dynamic> toJson() => {'mobileNumber': mobileNumber};
}

class VerifyOtpRequest {
  final String token;
  final String otp;

  const VerifyOtpRequest({required this.token, required this.otp});

  Map<String, dynamic> toJson() => {'token': token, 'otp': otp};
}


class SendOtpResponse {
  final bool success;
  final String message;
  final String? otp;
  final String token; 

  const SendOtpResponse({
    required this.success,
    required this.message,
    this.otp,
    required this.token,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      otp: json['otp'] as String?,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    if (otp != null) 'otp': otp,
    'token': token,
  };

  @override
  String toString() =>
      'SendOtpResponse(success: $success, message: $message, token: $token)';
}

class UserModel {
  final String id;
  final String mobileNumber;

  const UserModel({required this.id, required this.mobileNumber});

  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //     id: json['id'] as String,
  //     mobileNumber: json['mobileNumber'] as String,
  //   );
  // }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      mobileNumber: json['mobileNumber'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'mobileNumber': mobileNumber};

  @override
  String toString() => 'UserModel(id: $id, mobileNumber: $mobileNumber)';
}

class VerifyOtpResponse {
  final bool success;
  final String message;
  final String token; 
  final UserModel user;

  const VerifyOtpResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'token': token,
    'user': user.toJson(),
  };

  @override
  String toString() =>
      'VerifyOtpResponse(success: $success, message: $message, user: $user)';
}
