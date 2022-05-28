import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:restaurant_app/helper/db/database_helper.dart';
import 'package:restaurant_app/helper/result_state.dart';
import 'package:restaurant_app/model/restaurants.dart';
import 'package:restaurant_app/page/detail_page.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  DatabaseProvider({required this.databaseHelper}) {
    getFavorites();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void refresh() async {
    await getFavorites();
    refreshController.refreshCompleted();
  }

  getFavorites() async {
    _state = ResultState.loading;
    _favorites = await databaseHelper.getFavorite();
    if (_favorites.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void search(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      if (query.isNotEmpty) {
        _state = ResultState.loading;
        notifyListeners();
        //set state loading

        final restaurants = await databaseHelper.getFavoriteBySeacrh(query);
        if (restaurants.isNotEmpty) {
          _state = ResultState.hasData;
          notifyListeners();
          _favorites = restaurants;
        } else {
          _state = ResultState.noData;
          notifyListeners();
          _message = 'Data Tidak DItemukan';
        }
      } else {
        await getFavorites();
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (kDebugMode) {
        _message = 'Error --> $e';
      } else {
        _message = 'terjadi kesalahan, silahkan cek jaringan anda';
      }
    }
  }

  Future getDetail(id) async {
    Get.to(() => const DetailPage(), arguments: id)?.then((value) => refresh());
  }
}
