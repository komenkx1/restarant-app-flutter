import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/components/custom_dialog_form.dart';
import 'package:restaurant_app/model/restaurants.dart';
import 'package:restaurant_app/model/review.dart';
import 'package:restaurant_app/page/home_page.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/services/restaurant_service.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantServices apiService;
  final String id;
  TextEditingController namaPelangganController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  RestaurantDetailProvider({required this.apiService, required this.id}) {
    getDetail();
  }
  bool _isBusy = false;
  Restaurant? _restaurantResult;

  final String _message = '';
  bool _isFavorite = false;
  RestaurantProvider? restaurantProvider;
  String get message => _message;
  bool get isBusy => _isBusy;
  bool get isFavorite => _isFavorite;

  Restaurant? get result => _restaurantResult;

  Future getDetail() async {
    restaurantProvider = Get.put(RestaurantProvider(apiService: apiService));

    try {
      _isBusy = true;
      final data = await apiService.getDetailRestaurant(id);
      _restaurantResult = data;
      _isFavorite = await restaurantProvider!.checkIsFavorite(data);
      _isBusy = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        return Get.defaultDialog(
          title: 'Error',
          content: Text('Error --> $e'),
          onConfirm: () => Get.to(const HomePage()),
          barrierDismissible: false,
        );
      }
      return Get.defaultDialog(
        title: 'Error',
        content: const Text('terjadi kesalahan, silahkan cek jaringan anda'),
        onConfirm: () => Get.to(const HomePage()),
        barrierDismissible: false,
      );
    }
  }

  addReview() async {
    Get.dialog(CustomFormDialog(
      namaPelangganController: namaPelangganController,
      reviewController: reviewController,
      onConfirm: saveReview,
    ));
  }

  addfavorite(Restaurant? resto) async {
    restaurantProvider?.addFavorite(resto!);
    _isFavorite = await restaurantProvider!.checkIsFavorite(resto!);
    notifyListeners();
  }

  removefavorite(Restaurant? resto) async {
    restaurantProvider?.removeFavorite(resto!.id);
    _isFavorite = await restaurantProvider!.checkIsFavorite(resto!);
    notifyListeners();
  }

  void saveReview() async {
    if (namaPelangganController.text.isEmpty || reviewController.text.isEmail) {
      return Get.dialog(AlertDialog(
        title: const Text("Alret!"),
        content: const Text("Harap lengkapi Semua Field!"),
        actions: [
          ElevatedButton(
            child: const Text("Close"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ));
    }

    Review newReview = Review(
      date: DateTime.now().toIso8601String(),
      name: namaPelangganController.text,
      review: reviewController.text,
    );

    _isBusy = true;
    final review = await apiService.addReviewRestaurant(id, newReview);

    _restaurantResult!.customerReviews = review;
    _isBusy = false;
    notifyListeners();

    Get.back();

    Get.dialog(const AlertDialog(
      title: Text("Alret!"),
      content: Text("Berhasil Menambahkan Review"),
    ));
    namaPelangganController.text = "";
    reviewController.text = "";
  }
}
