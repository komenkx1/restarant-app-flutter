import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:restaurant_app/helper/result_state.dart';
import 'package:restaurant_app/model/restaurants.dart';
import 'package:restaurant_app/page/setting_page.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/services/restaurant_service.dart';
import 'package:restaurant_app/theme/custom_theme.dart';

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text("Restaurant",
                                  style: CustomTheme.headerTextStyle),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: IconButton(
                                    onPressed: () =>
                                        Get.to(const SettingPage()),
                                    icon: const Icon(Icons.settings))),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text("Recomendation restaurant for you",
                              style: CustomTheme.subHeaderTextStyle),
                        ),
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
                      child: Hero(
                        tag: "restoThumbnail${restaurant.id}+res",
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
              ),
            );
          });
    });
  }
}

class SearchComponent extends StatelessWidget {
  const SearchComponent({Key? key, this.onChanged, this.hint})
      : super(key: key);
  final ValueChanged<String>? onChanged;
  final String? hint;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.5),
        child: TextField(
            style: const TextStyle(color: Color(0xff636370)),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Color(0xff282833), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Color(0xff282833), width: 2.0),
                ),
                hintStyle: const TextStyle(color: Color(0xff636370)),
                hintText: hint,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xff636370),
                )),
            onChanged: onChanged));
  }
}
