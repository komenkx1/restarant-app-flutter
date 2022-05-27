import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:restaurant_app/helper/db/database_helper.dart';
import 'package:restaurant_app/helper/result_state.dart';
import 'package:restaurant_app/model/restaurants.dart';
import 'package:restaurant_app/page/detail_page.dart';
import 'package:restaurant_app/providers/scheduling_provider.dart';
import 'package:restaurant_app/services/restaurant_service.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantServices apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurants();
    schedulingProvider.getIsScheduled;
    notifyListeners();
  }

  final bool _isBusy = false;
  final DatabaseHelper databaseHelper = DatabaseHelper();
  SchedulingProvider schedulingProvider = Get.put(SchedulingProvider());
  List<Restaurant> _restaurantResult = [];
  late ResultState _state;
  String _message = '';

  String get message => _message;
  bool get isBusy => _isBusy;

  List<Restaurant> get result => _restaurantResult;

  ResultState get state => _state;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void refresh() async {
    await _fetchAllRestaurants();
    refreshController.refreshCompleted();
  }

  Future<dynamic> _fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final data = await apiService.getRestaurant();
      if (data.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Tidak Terdapat Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantResult = data;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (kDebugMode) {
        return _message = 'Error --> $e';
      }
      return _message = 'terjadi kesalahan, silahkan cek jaringan anda';
    }
  }

  void search(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      if (query.isNotEmpty) {
        _state = ResultState.loading;
        notifyListeners();
        //set state loading

        final restaurants = await apiService.searchRestaurant(query);
        if (restaurants.isNotEmpty) {
          _state = ResultState.hasData;
          notifyListeners();
          _restaurantResult = restaurants;
        } else {
          _state = ResultState.noData;
          notifyListeners();
          _message = 'Data Tidak DItemukan';
        }
      } else {
        await _fetchAllRestaurants();
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
    Get.to(() => const DetailPage(), arguments: id);
  }

  addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorites(restaurant);
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> checkIsFavorite(Restaurant restaurant) {
    return databaseHelper.getFavoriteById(restaurant.id).then((value) {
      return value.isNotEmpty ? true : false;
    });
  }
}
