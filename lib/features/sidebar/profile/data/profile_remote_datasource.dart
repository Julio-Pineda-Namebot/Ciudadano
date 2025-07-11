import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/features/sidebar/profile/data/models/user_profile_modal.dart";
import "package:ciudadano/service_locator.dart";
import "package:dio/dio.dart";

class ProfileRemoteDatasource {
  final DioClient _dio = sl<DioClient>();

  Future<UserProfileModel> getProfile() async {
    try {
      final response = await _dio.get("/auth/profile");

      final userJson = response.data["data"]["user"];

      return UserProfileModel.fromJson(userJson);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final errorMessage =
          responseData is Map<String, dynamic>
              ? responseData["message"] ?? "Error al cargar el perfil."
              : "Error inesperado.";
      throw Exception(errorMessage);
    }
  }

  Future<void> updateProfile(UserProfileModel profile) async {
    try {
      await _dio.put("/auth/profile", data: profile.toJson());
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final errorMessage =
          responseData is Map<String, dynamic>
              ? responseData["message"] ?? "Error al actualizar perfil."
              : "Error inesperado.";
      throw Exception(errorMessage);
    }
  }
}
