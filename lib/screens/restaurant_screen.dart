import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:restaurant_app/components/header_component.dart';
import 'package:restaurant_app/components/search_component.dart';
import 'package:restaurant_app/helper/result_state.dart';
import 'package:restaurant_app/model/restaurants.dart';
import 'package:restaurant_app/page/setting_page.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/services/restaurant_service.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: RestaurantServices()),
          child: Consumer<RestaurantProvider>(builder: (context, data, _) {
            return SmartRefresher(
              controller: data.refreshController,
              onRefresh: data.refresh,
              child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderComponent(
                            headerText: "Restaurants",
                            subHeaderText: "Recomendation restaurant for you",
                            isButtonActive: true,
                            onPressed: () => Get.to(const SettingPage())),
                        SearchComponent(
                          hint: "Search",
                          onChanged: data.search,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        data.state == ResultState.loading
                            ? const Center(child: CircularProgressIndicator())
                            : (data.state == ResultState.noData ||
                                    data.state == ResultState.error)
                                ? Center(child: Text(data.message))
                                : const ListRestaurantWidget()
                      ],
                    )),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ListRestaurantWidget extends StatelessWidget {
  const ListRestaurantWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(builder: (context, data, _) {
      return ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.result.length,
          itemBuilder: (context, index) {
            Restaurant restaurant = data.result[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                  trailing: FutureBuilder(
                      future: data.checkIsFavorite(restaurant),
                      builder: (context, snapshot) {
                        return IconButton(
                          onPressed: () {
                            if (snapshot.data == true) {
                              data.removeFavorite(restaurant.id);
                            } else {
                              data.addFavorite(restaurant);
                            }
                          },
                          icon: Icon(snapshot.data == true
                              ? Icons.favorite
                              : Icons.favorite_outline),
                        );
                      }),
                  onTap: () async => await data.getDetail(restaurant.id),
                  title: Text(
                    restaurant.name,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.pin_drop),
                          Text(
                            restaurant.city,
                            style: GoogleFonts.poppins(),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: data.isBusy ? Colors.grey : Colors.orange),
                          Text(restaurant.rating.toString(),
                              style: GoogleFonts.poppins())
                        ],
                      )
                    ],
                  ),
                  leading: SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl:
                            "https://restaurant-api.dicoding.dev/images/large/" +
                                restaurant.pictureId,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  )),
            );
          });
    });
  }
}
