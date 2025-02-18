import 'dart:convert';
import 'dart:io';
import 'package:absen_smkn1_punggelan/app/data/model/photo.dart';
import 'package:absen_smkn1_punggelan/app/data/source/photo_api_service.dart';
import 'package:absen_smkn1_punggelan/app/module/repository/photo_repository.dart';
import 'package:absen_smkn1_punggelan/core/network/data_state.dart';

class PhotoRepositoryImpl extends PhotoRepository {
  final PhotoApiService _photoApiService;

  PhotoRepositoryImpl(this._photoApiService);

  @override
  Future<DataState<void>> uploadPhoto(File photo, String type) async {
    try {
      final String base64Image = base64Encode(await photo.readAsBytes());
      
      final response = await _photoApiService.uploadPhoto(
        type: type,
        photo: base64Image,
      );

      if (response['success'] == true) {
        return SuccessState(message: response['message'] ?? 'Photo uploaded successfully');
      } else {
        return ErrorState(message: response['message'] ?? 'Failed to upload photo');
      }
    } catch (e) {
      return ErrorState(message: e.toString());
    }
  }

  @override
  Future<DataState<List<Photo>>> getPhotoList() async {
    try {
      final response = await _photoApiService.getPhotoList();
      
      if (response['success'] == true) {
        final List<dynamic> photoList = response['data'] ?? [];
        final photos = photoList.map((json) => Photo.fromJson(json)).toList();
        return SuccessState(
          data: photos,
          message: response['message'] ?? 'Photos retrieved successfully'
        );
      } else {
        return ErrorState(message: response['message'] ?? 'Failed to get photos');
      }
    } catch (e) {
      return ErrorState(message: e.toString());
    }
  }

  @override
  Future<DataState<Photo>> getPhotoDetail(int id) async {
    try {
      final response = await _photoApiService.getPhotoDetail(id);
      
      if (response['success'] == true) {
        final photo = Photo.fromJson(response['data']);
        return SuccessState(
          data: photo,
          message: response['message'] ?? 'Photo details retrieved successfully'
        );
      } else {
        return ErrorState(message: response['message'] ?? 'Failed to get photo details');
      }
    } catch (e) {
      return ErrorState(message: e.toString());
    }
  }

  @override
  Future<DataState<void>> deletePhoto(int id) async {
    try {
      final response = await _photoApiService.deletePhoto(id);
      
      if (response['success'] == true) {
        return SuccessState(message: response['message'] ?? 'Photo deleted successfully');
      } else {
        return ErrorState(message: response['message'] ?? 'Failed to delete photo');
      }
    } catch (e) {
      return ErrorState(message: e.toString());
    }
  }
}
