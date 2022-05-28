import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:restaurant_app/components/header_component.dart';
import 'package:restaurant_app/components/search_component.dart';
import 'package:restaurant_app/helper/db/database_helper.dart';
import 'package:restaurant_app/helper/result_state.dart';
import 'package:restaurant_app/model/restaurants.dart';
import 'package:restaurant_app/providers/database_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
          child: Consumer<DatabaseProvider>(builder: (context, data, _) {
            return SmartRefresher(
              controller: data.refreshController,
              onRefresh: data.refresh,
              child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderComponent(
                          headerText: "Favorite Restaurants",
                          subHeaderText: "Your favorite restaurant for you",
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
    return Consumer<DatabaseProvider>(builder: (context, data, _) {
      return ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.favorites.length,
          itemBuilder: (context, index) {
            Restaurant restaurant = data.favorites[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
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
                        const Icon(Icons.star, color: Colors.orange),
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
                        tag: "restoThumbnail${restaurant.id}",
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
