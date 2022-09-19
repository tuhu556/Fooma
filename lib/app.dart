import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/data/data.dart';
import 'package:foodhub/features/home/components/sideBar.dart';
import 'package:foodhub/features/home/screens/home.dart';
import 'package:foodhub/features/ingredient_manager/screens/ingredient_manager.dart';
import 'package:foodhub/features/notification/screens/notification.dart';
import 'package:foodhub/features/plan/screens/calendar.dart';
import 'package:foodhub/features/social/screens/social.dart';
import 'package:foodhub/features/user_profile/model/user_profile_entity.dart';
import 'package:foodhub/features/user_profile/screens/user_profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'constants/color.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({Key? key}) : super(key: key);

  @override
  _MainTabScreenState createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  UserProfileResponse userProfile = UserProfileResponse();
  int args = 0;
  @override
  Widget build(BuildContext context) {
    try {
      args = ModalRoute.of(context)?.settings.arguments as int;
    } catch (e) {
      args = 0;
    }

    return MainTabView(
      select: args,
    );
  }
}

class MainTabView extends StatefulWidget {
  final int? select;
  final String? selectedDate;
  const MainTabView({
    Key? key,
    this.select,
    this.selectedDate,
  }) : super(key: key);

  @override
  _MainTabViewState createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with SingleTickerProviderStateMixin {
  late List<Map<String, Widget>> _pages;

  int _selectedPageIndex = 0;
  @override
  void initState() {
    if (widget.select != null) {
      _selectedPageIndex = widget.select!;
    }

    _pages = [
      {
        'page': HomeScreen(
          onTap: (value) {
            if (value >= 9) {
              setState(() {
                Data.noti = true;
                Data.numNoti = 9;
              });
            } else if (value > 0 && value < 9) {
              setState(() {
                Data.noti = true;
                Data.numNoti = value;
              });
            } else {
              setState(() {
                Data.noti = false;
              });
            }
          },
        ),
      },
      {
        'page': FoodManagerScreen(
          onTap: (value) {
            if (value >= 9) {
              setState(() {
                Data.noti = true;
                Data.numNoti = 9;
              });
            } else if (value > 0 && value < 9) {
              setState(() {
                Data.noti = true;
                Data.numNoti = value;
              });
            } else {
              setState(() {
                Data.noti = false;
              });
            }
          },
        ),
      },
      {
        'page': CalendarScreen(
          selectedDate: widget.selectedDate,
          onTap: (value) {
            if (value >= 9) {
              setState(() {
                Data.noti = true;
                Data.numNoti = 9;
              });
            } else if (value > 0 && value < 9) {
              setState(() {
                Data.noti = true;
                Data.numNoti = value;
              });
            } else {
              setState(() {
                Data.noti = false;
              });
            }
          },
        ),
      },
      {
        'page': SocialScreen(
          onTap: (value) {
            if (value >= 9) {
              setState(() {
                Data.noti = true;
                Data.numNoti = 9;
              });
            } else if (value > 0 && value < 9) {
              setState(() {
                Data.noti = true;
                Data.numNoti = value;
              });
            } else {
              setState(() {
                Data.noti = false;
              });
            }
          },
        ),
      },
      // {
      //   'page': NotificationScreen(onTap: (value) {
      //     if (value >= 9) {
      //       setState(() {
      //         Data.noti = true;
      //         Data.numNoti = 9;
      //       });
      //     } else if (value > 0 && value < 9) {
      //       setState(() {
      //         Data.noti = true;
      //         Data.numNoti = value;
      //       });
      //     } else {
      //       setState(() {
      //         Data.noti = false;
      //         // Data.numNoti = 0;
      //       });
      //     }
      //   }
      // ),
      // },
      {
        'page': SideBar(onTap: (value) {
          if (value >= 9) {
            setState(() {
              Data.noti = true;
              Data.numNoti = 9;
            });
          } else if (value > 0 && value < 9) {
            setState(() {
              Data.noti = true;
              Data.numNoti = value;
            });
          } else {
            setState(() {
              Data.noti = false;
              // Data.numNoti = 0;
            });
          }
        })
      }
      // {
      //   'page': UserProfileScreen(
      //     onTap: (value) {
      //       if (value >= 9) {
      //         setState(() {
      //           Data.noti = true;
      //           Data.numNoti = 9;
      //         });
      //       } else if (value > 0 && value < 9) {
      //         setState(() {
      //           Data.noti = true;
      //           Data.numNoti = value;
      //         });
      //       } else {
      //         setState(() {
      //           Data.noti = false;
      //         });
      //       }
      //     },
      //   ),
      // },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) => _selectPage(index),
        items: [
          //Home
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.home_filled,
              size: 40,
            ),
            title: const Text(
              "Trang chủ",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            unselectedColor: FoodHubColors.color52616B,
            selectedColor: FoodHubColors.colorFC6011,
          ),
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.kitchen_outlined,
              size: 40,
            ),
            title: const Text(
              "Tủ lạnh",
              style: TextStyle(fontSize: 16),
            ),
            unselectedColor: FoodHubColors.color52616B,
            selectedColor: FoodHubColors.colorFC6011,
          ),
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.calendar_month,
              size: 40,
            ),
            title: const Text(
              "Kế hoạch",
              style: TextStyle(fontSize: 16),
            ),
            unselectedColor: FoodHubColors.color52616B,
            selectedColor: FoodHubColors.colorFC6011,
          ),
          //Scocial
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.group,
              size: 40,
            ),
            title: const Text(
              "Cộng đồng",
              style: TextStyle(fontSize: 16),
            ),
            unselectedColor: FoodHubColors.color52616B,
            selectedColor: FoodHubColors.colorFC6011,
          ),
          // //Notification
          // SalomonBottomBarItem(
          //   icon:
          // Badge(
          //     position: BadgePosition.topEnd(),
          //     animationType: BadgeAnimationType.slide,
          //     showBadge: Data.noti,
          //     badgeContent: Padding(
          //       padding: const EdgeInsets.only(
          //         bottom: 2,
          //       ),
          //       child: Text(
          //         Data.numNoti >= 9
          //             ? Data.numNoti.toString() + "+"
          //             : Data.numNoti.toString(),
          //         style: const TextStyle(color: Colors.white),
          //       ),
          //     ),
          //     child: const Icon(
          //       Icons.notifications,
          //       size: 40,
          //     ),
          //   ),
          //   // ),
          //   title: const Text(
          //     "Thông báo",
          //     style: TextStyle(fontSize: 16),
          //   ),
          //   unselectedColor: FoodHubColors.color52616B,
          //   selectedColor: FoodHubColors.colorFC6011,
          // ),
          //User Profile
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.menu,
              size: 40,
            ),
            title: const Text(
              "Menu",
              style: TextStyle(fontSize: 16),
            ),
            unselectedColor: FoodHubColors.color52616B,
            selectedColor: FoodHubColors.colorFC6011,
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
}
