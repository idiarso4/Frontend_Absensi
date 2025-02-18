import 'package:absen_smkn1_punggelan/core/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'photo_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class PhotoApiService {
  factory PhotoApiService(Dio dio) {
    return _PhotoApiService(dio);
  }

  @POST('/api/photo/upload')
  Future<Map<String, dynamic>> uploadPhoto({
    @Part() required String type,
    @Part() required String photo,
  });

  @GET('/api/photo/list')
  Future<Map<String, dynamic>> getPhotoList();

  @GET('/api/photo/detail/{id}')
  Future<Map<String, dynamic>> getPhotoDetail(@Path() int id);

  @DELETE('/api/photo/delete/{id}')
  Future<Map<String, dynamic>> deletePhoto(@Path() int id);

  @GET('/api/photo/bytes/{id}')
  Future<Map<String, dynamic>> getPhotoBytes(@Path() int id);
}
