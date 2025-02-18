import 'package:absen_smkn1_punggelan/app/module/repository/photo_repository.dart';
import 'package:absen_smkn1_punggelan/core/network/data_state.dart';

class PhotoGetBytesUseCase {
  final PhotoRepository _photoRepository;

  PhotoGetBytesUseCase(this._photoRepository);

  Future<DataState<List<int>?>> call(int photoId) async {
    return await _photoRepository.getPhotoBytes(photoId);
  }

  Future<DataState<List<int>?>> execute(int photoId) async {
    return await call(photoId);
  }
}
