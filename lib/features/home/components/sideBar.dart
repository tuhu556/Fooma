import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/notification/screens/notification.dart';
import 'package:foodhub/features/signout/bloc/remove_device_id_bloc.dart';

import '../../../config/routes.dart';
import '../../../data/data.dart';
import '../../../helper/helper.dart';
import '../../../session/session.dart';
import '../../notification/bloc/notification_bloc.dart';
import '../../signin/provider/google_sign_in.dart';
import '../../user_profile/bloc/user_profile_bloc.dart';
import '../../user_profile/model/user_profile_entity.dart';

class SideBar extends StatefulWidget {
  final Function(int)? onTap;
  const SideBar({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RemoveDeviceIdBloc(),
        ),
        BlocProvider(
          create: (_) => UserProfileBloc()..add(const UserProfile()),
        ),
        BlocProvider(
            create: (_) => AllNotiBloc()..add(const AllNotification())),
      ],
      child: SideBarView(
        onTap: widget.onTap,
      ),
    );
  }
}

class SideBarView extends StatefulWidget {
  final Function(int)? onTap;
  const SideBarView({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<SideBarView> createState() => _SideBarViewState();
}

class _SideBarViewState extends State<SideBarView> {
  UserProfileResponse userProfile = UserProfileResponse();
  String userName = '';
  String imageUserUrl = Data.avatar;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state.status == UserProfileStatus.Processing) {
            } else if (state.status == UserProfileStatus.Failed) {
            } else if (state.status == UserProfileStatus.Ban) {
              signOutGoogle();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.signIn, (Route<dynamic> route) => false);
              ApplicationSesson.shared.clearSession();
              Helpers.shared.showDialogSuccess(context,
                  title: "Đăng xuất", message: "Phiên đăng nhập hết hạn");
            } else if (state.status == UserProfileStatus.Success) {
              setState(() {
                userProfile = state.userProfile!;
                userName = userProfile.name!;
                imageUserUrl = userProfile.imageUrl!;
                Data.avatar = imageUserUrl;
              });
            }
          },
        ),
        BlocListener<AllNotiBloc, AllNotiState>(listener: (context, state) {
          if (state.status == AllNotiStatus.AllProcessing) {
          } else if (state.status == AllNotiStatus.AllFailed) {
          } else if (state.status == AllNotiStatus.AllSuccess) {
            int count = 0;
            for (int i = 0; i < state.allNotification!.listNoti.length; i++) {
              if (state.allNotification!.listNoti[i].status == 1 &&
                  state.allNotification!.listNoti[i].isSeen == false) {
                setState(() {
                  count = count + 1;
                });
              }
            }
            widget.onTap!(count);
          }
        }),
        BlocListener<RemoveDeviceIdBloc, RemoveDeviceIdState>(
          listener: (context, state) {
            if (state.status == RemoveStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == RemoveStatus.Failed) {
              Helpers.shared.hideDialogProgress(context);
              signOutGoogle();
              ApplicationSesson.shared.clearSession();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
            } else if (state.status == RemoveStatus.Success) {
              Helpers.shared.hideDialogProgress(context);
              signOutGoogle();
              ApplicationSesson.shared.clearSession();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
            }
          },
        ),
      ],
      child: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context, userName, imageUrl),
            builMenuItems(context),
          ],
        )),
      ),
    );
  }

  Widget buildHeader(BuildContext context, String userName, String imageUrl) =>
      Material(
        color: FoodHubColors.colorF0F5F9,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.userProfile);
          },
          child: Stack(
            children: [
              Positioned(
                top: 20,
                right: 30,
                child: InkWell(
                  child: Badge(
                    position: BadgePosition.topEnd(),
                    animationType: BadgeAnimationType.slide,
                    showBadge: Data.noti,
                    badgeContent: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 2,
                      ),
                      child: Text(
                        Data.numNoti >= 9
                            ? Data.numNoti.toString() + "+"
                            : Data.numNoti.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    child: Icon(
                      Icons.notifications,
                      size: 45,
                      color: FoodHubColors.color52616B,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return NotificationScreen(
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
                      );
                    }));
                  },
                ),
              ),
              Positioned(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 30,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              foregroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                imageUserUrl,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: FoodHubColors.color0B0C0C,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color:
                                  FoodHubColors.colorFC6011.withOpacity(0.8)),
                          width: 250,
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Xem trang cá nhân",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 22,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, Routes.userProfile);
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget builMenuItems(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: FoodHubColors.colorFFFFFF,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 6,
              blurRadius: 9,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10)
            .add(const EdgeInsets.symmetric(horizontal: 20)),
        child: Wrap(
          runSpacing: 15,
          children: [
            ListTile(
              leading: const Icon(
                Icons.favorite_border,
                size: 35,
                color: Colors.black,
              ),
              title: const Text(
                "Công thức đã lưu",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.pushNamed(context, Routes.favoriteRecipe);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.event_note,
                size: 35,
                color: Colors.black,
              ),
              title: const Text(
                "Danh sách mua sắm",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.pushNamed(context, Routes.savedPlan);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_outlined,
                  size: 35, color: Colors.black),
              title: const Text(
                "Bài viết của tôi",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.pushNamed(context, Routes.myPost);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_dining_outlined,
                  size: 35, color: Colors.black),
              title: const Text(
                "Công thức của tôi",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.pushNamed(context, Routes.myRecipe);
              },
            ),
            ListTile(
              leading: const Icon(Icons.turned_in_not,
                  size: 35, color: Colors.black),
              title: const Text(
                "Nội dung đã lưu",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.pushNamed(context, Routes.favoritePost);
              },
            ),
            Divider(
              color: FoodHubColors.colorB7B7B7,
            ),
            ListTile(
              leading:
                  const Icon(Icons.settings, size: 35, color: Colors.black),
              title: const Text(
                "Cài đặt & Cá nhân",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.pushNamed(context, Routes.setting);
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: FoodHubColors.color52616B.withOpacity(0.8)),
                    width: double.infinity,
                    height: 52,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.logout,
                          size: 35,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Đăng xuất",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Helpers.shared.showDialogConfirm(
                      context,
                      title: "Đăng xuất",
                      message: "Bạn có muốn đăng xuất không?",
                      okFunction: () async {
                        String deviceId =
                            await FirebaseMessaging.instance.getToken() ?? "";
                        final bloc = context.read<RemoveDeviceIdBloc>();
                        bloc.add(RemoveDeviceId(deviceId));
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      );
}
