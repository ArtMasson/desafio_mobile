import 'package:desafio_mobile/app/common/store/global_store.dart';
import 'package:desafio_mobile/app/home/domain/usecase/save_user_info_in_db_usecase.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mobx/mobx.dart';
part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

abstract class _HomeController with Store {
  final Location _location;
  final GlobalStore _globalStore;
  final SaveUserInfoInDbUsecase _saveUserInfoInDbUsecase;
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  @observable
  bool isLoading = true;

  _HomeController(
    this._globalStore,
    this._saveUserInfoInDbUsecase,
    this._location,
  );

  @action
  Future<void> saveUserInfoInDb(LatLng position) async {
    if (_globalStore.hasCurrentUser) {
      final user = _globalStore.getCurrentUser!;
      _saveUserInfoInDbUsecase(
        userInfo: user,
        position: position,
      );
      _analytics.logEvent(
        name: 'Rendered_Success',
        parameters: {
          "user_uid": user.uid,
          "user_email": user.email,
          "user_latitude": position.latitude,
          "user_longitude": position.longitude,
        },
      );
    }
  }

  @action
  Future<LatLng> getCurrentLocation() async {
    var location = await _location.getLocation();
    isLoading = false;
    return LatLng(location.latitude!, location.longitude!);
  }
}
