// import 'dart:convert';
// import 'package:brando_app/constant/api_constants.dart';
// import 'package:brando_app/models/upgrade_model.dart';
// import 'package:dio/dio.dart';


// class UpgradeBookingService {
//   final Dio _dio;

//   UpgradeBookingService({Dio? dio})
//       : _dio = dio ??
//             Dio(BaseOptions(
//               connectTimeout:
//                   Duration(milliseconds: ApiConstants.connectTimeoutMs),
//               receiveTimeout:
//                   Duration(milliseconds: ApiConstants.receiveTimeoutMs),
//               headers: {
//                 ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
//               },
//             ));

//   Future<UpgradeBookingResponse> upgradeBooking({
//     required String bookingId,
//     required UpgradeBookingRequest request,
//     String? token,
//   }) async {
//     try {
//       final url = ApiConstants.upgradeBookingUrl(bookingId);

//       final options = Options(
//         headers: {
//           if (token != null)
//             ApiConstants.authorizationHeader:
//                 '${ApiConstants.bearerPrefix}$token',
//         },
//       );

//       final response = await _dio.put(
//         url,
//         data: jsonEncode(request.toJson()),
//         options: options,
//       );

//       if (response.statusCode == 200 && response.data != null) {
//         return UpgradeBookingResponse.fromJson(response.data);
//       }

//       throw Exception('Unexpected response: ${response.statusCode}');
//     } on DioException catch (e) {
//       final message = e.response?.data?['message'] ?? e.message ?? 'Request failed';
//       throw Exception('Upgrade booking failed: $message');
//     } catch (e) {
//       throw Exception('Upgrade booking error: $e');
//     }
//   }
// }













import 'dart:convert';
import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/models/upgrade_model.dart';
import 'package:dio/dio.dart';

class UpgradeBookingService {
  final Dio _dio;

  UpgradeBookingService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: Duration(
                  milliseconds: ApiConstants.connectTimeoutMs,
                ),
                receiveTimeout: Duration(
                  milliseconds: ApiConstants.receiveTimeoutMs,
                ),
                headers: {
                  ApiConstants.contentTypeHeader:
                      ApiConstants.contentTypeJson,
                },
              ),
            );

  Future<UpgradeBookingResponse> upgradeBooking({
    required String bookingId,
    required UpgradeBookingRequest request,
    String? token,
  }) async {
    try {
      final url = ApiConstants.upgradeBookingUrl(bookingId);

      final options = Options(
        headers: {
          if (token != null)
            ApiConstants.authorizationHeader:
                '${ApiConstants.bearerPrefix}$token',
        },
      );

      final response = await _dio.put(
        url,
        data: jsonEncode(request.toJson()),
        options: options,
      );

      /// PRINT STATUS CODE
      print("Status Code: ${response.statusCode}");

      /// PRINT FULL RESPONSE
      print("Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        return UpgradeBookingResponse.fromJson(response.data);
      }

      throw Exception('Unexpected response: ${response.statusCode}');
    } on DioException catch (e) {
      /// ERROR STATUS CODE
      print("Error Status Code: ${e.response?.statusCode}");

      /// ERROR RESPONSE
      print("Error Response: ${e.response?.data}");

      final message =
          e.response?.data?['message'] ??
          e.message ??
          'Request failed';

      throw Exception('Upgrade booking failed: $message');
    } catch (e) {
      print("Unexpected Error: $e");
      throw Exception('Upgrade booking error: $e');
    }
  }
}