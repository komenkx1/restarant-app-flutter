// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/model/menu.dart';
import 'package:restaurant_app/model/review.dart';
import 'package:restaurant_app/providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/services/restaurant_service.dart';
import 'package:restaurant_app/theme/custom_theme.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final String restaurantId = Get.arguments.toString();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ChangeNotifierProvider(
            create: (_) => RestaurantDetailProvider(
                apiService: RestaurantServices(), id: restaurantId),
            child: Consumer<RestaurantDetailProvider>(
              builder: (context, data, _) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(data.isBusy
                        ? "Loading..."
                        : data.result?.name ?? 'Detail'),
                  ),
                  body: data.isBusy
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://restaurant-api.dicoding.dev/images/large/" +
                                        (data.result?.pictureId ?? ''),
                                fit: BoxFit.fill,
                              ),
                            ),

                            // Text(),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.result?.name ?? '',
                                      style: CustomTheme.subHeaderTextStyle),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.pin_drop),
                                      Text(data.result?.city ?? '',
                                          style: GoogleFonts.poppins()),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                      ),
                                      Text(data.result?.rating.toString() ?? '',
                                          style: GoogleFonts.poppins()),
                                    ],
                                  ),
                                  const Divider(),
                                  Text(data.result?.description ?? '',
                                      style: GoogleFonts.poppins()),
                                  const Divider(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Menu',
                                      style: CustomTheme.subHeaderTextStyle),
                                  MenuComponent(menus: data.result?.menus),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Review Restaurant',
                                          style:
                                              CustomTheme.subHeaderTextStyle),
                                      ElevatedButton(
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          onPressed: () => {data.addReview()}),
                                    ],
                                  ),
                                  ReviewComponents(
                                    reviews: data.result?.customerReviews,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                );
              },
            )));
  }
}

class MenuComponent extends StatelessWidget {
  const MenuComponent({Key? key, required this.menus}) : super(key: key);
  final Menus? menus;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      color: const Color.fromRGBO(0, 0, 0, 0.001),
                      child: GestureDetector(
                        onTap: () {},
                        child: DraggableScrollableSheet(
                          initialChildSize: 0.4,
                          minChildSize: 0.2,
                          maxChildSize: 0.75,
                          builder: (_, controller) {
                            return MenuItemsComponent(
                              controller: controller,
                              restaurant: menus?.foods,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: SizedBox(
              height: 150,
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/food card.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      color: const Color.fromRGBO(0, 0, 0, 0.001),
                      child: GestureDetector(
                        onTap: () {},
                        child: DraggableScrollableSheet(
                          initialChildSize: 0.4,
                          minChildSize: 0.2,
                          maxChildSize: 0.75,
                          builder: (_, controller) {
                            return MenuItemsComponent(
                              isMakanan: false,
                              controller: controller,
                              restaurant: menus?.drinks,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: SizedBox(
              height: 150,
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/drink card.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewComponents extends StatelessWidget {
  const ReviewComponents({
    Key? key,
    this.reviews,
  }) : super(key: key);

  final List<Review>? reviews;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: reviews?.length,
        itemBuilder: (BuildContext context, int index) {
          final dataReview = reviews?[index];
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SizedBox(
              width: 200,
              child: Card(
                child: InkWell(
                  onTap: () => Get.dialog(AlertDialog(
                    title: Text('Review ${dataReview?.name}'),
                    content: Text('${dataReview?.review}'),
                    actions: [
                      FlatButton(
                        child: const Text('Tutup'),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataReview?.name ?? "-",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          dataReview?.date ?? "-",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              color: const Color.fromARGB(255, 37, 37, 37)),
                        ),
                        Text(
                          dataReview?.review ?? "-",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MenuItemsComponent extends StatelessWidget {
  const MenuItemsComponent({
    Key? key,
    required this.restaurant,
    required this.controller,
    this.isMakanan = true,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final restaurant;
  final bool isMakanan;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.remove,
            color: Colors.grey[600],
          ),
          Text(isMakanan ? "Makanan" : 'Minuman',
              style: CustomTheme.subHeaderTextStyle),
          const Divider(),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: restaurant.length,
              itemBuilder: (_, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(restaurant[index].name ?? "-"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
