import 'package:absen_smkn1_punggelan/app/module/repository/photo_repository.dart';
import 'package:absen_smkn1_punggelan/core/network/data_state.dart';
import 'package:absen_smkn1_punggelan/core/use_case/app_use_case.dart';

class PhotoGetBytesUseCase
    extends AppUseCase<Future<DataState<dynamic>>, void> {
  final PhotoRepository _photoRepository;

  PhotoGetBytesUseCase(this._photoRepository);

  @override
  Future<DataState> call({void param}) async {
    final response = await _photoRepository.get();
    if (response.success) {
      final responseBytes = await _photoRepository.getBytes(response.data!);
      return responseBytes;
    } else {
      return response;
    }
  }
}
