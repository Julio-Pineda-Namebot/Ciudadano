import 'package:ciudadano/config/core/dio_cliente.dart';
import 'package:ciudadano/features/sidebar/profile/data/models/user_profile_modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileRemoteDatasource {
  final DioClient _dio = DioClient();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<UserProfileModel> getProfile() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');

      final response = await _dio.get(
        '/auth/profile',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final userJson = response.data['data']['user'];

      return UserProfileModel.fromJson(userJson);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final errorMessage = responseData is Map<String, dynamic>
          ? responseData['message'] ?? 'Error al cargar el perfil.'
          : 'Error inesperado.';
      throw Exception(errorMessage);
    }
  }

  Future<void> updateProfile(UserProfileModel profile) async {
    try {
      final token = await secureStorage.read(key: 'auth_token');

      await _dio.put(
        '/auth/profile',
        data: profile.toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final errorMessage = responseData is Map<String, dynamic>
          ? responseData['message'] ?? 'Error al actualizar perfil.'
          : 'Error inesperado.';
      throw Exception(errorMessage);
    }
  }
}
