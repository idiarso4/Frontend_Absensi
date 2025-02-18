import 'dart:convert';
import 'dart:io';

import 'package:absen_smkn1_punggelan/core/network/base_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_state.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DataState<T> extends BaseResponse {
  final T? data;
  DataState({required super.success, required super.message, this.data});

  factory DataState.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$DataStateFromJson(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object? Function(T? value) toJsonT) {
    return _$DataStateToJson(this, toJsonT);
  }
}

class SuccessState<T> extends DataState<T> {
  SuccessState({T? data, String message = 'Success'})
      : super(success: true, message: message, data: data);
}

class ErrorState<T> extends DataState<T> {
  ErrorState({required String message})
      : super(success: false, message: message);
}

Future<DataState<T>> handleResponse<T>(
    Future<HttpResponse<Map<String, dynamic>>> Function() apiCall,
    T Function(dynamic) mapDataSuccess) async {
  try {
    final httpResponse = await apiCall();
    if (httpResponse.response.statusCode == HttpStatus.ok) {
      final response = httpResponse.data;
      if (response['success'] == true) {
        return SuccessState(
            data: mapDataSuccess(response['data']),
            message: response['message'] ?? 'Success');
      } else {
        return ErrorState(message: response['message'] ?? 'Unknown error');
      }
    } else {
      return ErrorState(
          message:
              '${httpResponse.response.statusCode} : ${httpResponse.response.statusMessage}');
    }
  } on DioException catch (e) {
    if (e.response?.data != null &&
        e.response?.data is Map<String, dynamic> &&
        e.response?.data['message'] != null) {
      return ErrorState(message: e.response?.data['message']);
    }
    return ErrorState(message: e.message ?? 'Unknown error');
  } catch (e) {
    return ErrorState(message: e.toString());
  }
}
