import 'package:flutter/cupertino.dart';

class ApiResponse {
  bool success;
  Map<String, dynamic> data;
  String message;

  ApiResponse({this.success, this.data, this.message});

  // ApiResponse.fromJson(Map<String, dynamic> json) {
  //   success = json['success'];
  //   data = json['data'];
  //   message = json['message'];
  // }
  ApiResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false; // Set default value if success field is null
    data = json['data'] ?? {}; // Set default value if data field is null
    message = json['message'] ?? ''; // Set default value if message field is null
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;

    return data;
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'success': success,
  //     'data': data,
  //     'message': message,
  //   };
  // }
}


// import 'package:flutter/cupertino.dart';
//
// class ApiResponse {
//   final Map<String, dynamic> data;
//   final String message;
//
//   ApiResponse({@required this.data, @required this.message});
//
//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       data: json['data'],
//       message: json['message'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'data': data,
//       'message': message,
//     };
//   }
// }
