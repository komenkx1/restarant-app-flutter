import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/helper/notification_helper.dart';
import 'package:restaurant_app/page/detail_page.dart';
import 'package:restaurant_app/providers/home_provider.dart';
import 'package:restaurant_app/screens/favorite_screen.dart';
import 'package:restaurant_app/screens/restaurant_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  List<Widget>? _screen;
  @override
  void initState() {
    _screen = [
      const RestaurantScreen(),
      const FavoriteScreen(),
    ];
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(const DetailPage());
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        //use indexedStact to kee alive the screen
        // body: IndexedStack(
        //   index: provider.selectedNavbar,
        //   children: const [
        //     RestaurantScreen(),
        //     FavoriteScreen(),
        //   ],
        // ),

        //use List WIdget to reload screen on change index
        body: _screen?[provider.selectedNavbar],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorite",
            ),
          ],
          currentIndex: provider.selectedNavbar,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: provider.changeSelectedNavBar,
        ),
      );
    });
  }
}
