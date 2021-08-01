import 'package:desafio_mobile/app/home/domain/repository/home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SaveUserInfoInDbUsecase {
  final HomeRepository _repository;

  SaveUserInfoInDbUsecase(this._repository);

  Future<void> call({
    required User userInfo,
    required LatLng position,
  }) =>
      _repository.saveUserInDb(userInfo, position);
}
