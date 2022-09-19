import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/data/data.dart';
import 'package:foodhub/features/notification/bloc/notification_bloc.dart';
import 'package:foodhub/features/notification/models/notification.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../helper/helper.dart';
import '../../../session/session.dart';
import '../../signin/provider/google_sign_in.dart';
import '../../user_profile/bloc/user_profile_bloc.dart';

class NotificationScreen extends StatefulWidget {
  final Function(int)? onTap;
  const NotificationScreen({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserProfileBloc()..add(const UserProfile()),
        ),
        BlocProvider(
          create: (_) => AllNotiBloc()
            ..add(const AllNotiSocial(1))
            ..add(const AllNotiIngredient(1))
            ..add(const AllNotiPlan(1))
            ..add(const AllNotification()),
        ),
      ],
      child: NotificationView(
        onTap: widget.onTap,
      ),
    );
  }
}

class NotificationView extends StatefulWidget {
  final Function(int)? onTap;
  const NotificationView({Key? key, this.onTap}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  int tab = 0;
  int pageNoti = 1;
  List<Noti> allNoti = [];

  int pageIngredient = 1;
  List<Noti> allIngredient = [];

  int pagePlan = 1;
  List<Noti> allPlan = [];

  bool enablePullUpSocial = true;
  bool enablePullUpIngredient = true;
  bool enablePullUpPlan = true;

  int count = 0;
  final RefreshController _refreshControllerSocial =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKeySocial = GlobalKey();

  final RefreshController _refreshControllerIngredient =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKeyIngredient = GlobalKey();
  final RefreshController _refreshControllerPlan =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKeyPlan = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
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
          } else if (state.status == UserProfileStatus.Success) {}
        }),
        BlocListener<AllNotiBloc, AllNotiState>(
          listener: (context, state) {
            if (state.status == AllNotiStatus.Processing) {
            } else if (state.status == AllNotiStatus.Failed) {
            } else if (state.status == AllNotiStatus.Success) {
              for (int i = 0; i < state.allNotiSocial!.listNoti.length; i++) {
                if (state.allNotiSocial!.listNoti[i].status == 1) {
                  setState(() {
                    allNoti.add(state.allNotiSocial!.listNoti[i]);
                  });
                }
              }

              if (pageNoti >= state.allNotiSocial!.totalPage) {
                setState(() {
                  enablePullUpSocial = false;
                });
              }
            } else if (state.status == AllNotiStatus.IngredientProcessing) {
            } else if (state.status == AllNotiStatus.IngredientFailed) {
            } else if (state.status == AllNotiStatus.IngredientSuccess) {
              for (int i = 0;
                  i < state.allNotiIngredient!.listNoti.length;
                  i++) {
                if (state.allNotiIngredient!.listNoti[i].status == 1) {
                  setState(() {
                    allIngredient.add(state.allNotiIngredient!.listNoti[i]);
                  });
                }
              }

              if (pageIngredient >= state.allNotiIngredient!.totalPage) {
                setState(() {
                  enablePullUpIngredient = false;
                });
              }
            } else if (state.status == AllNotiStatus.PlanProcessing) {
            } else if (state.status == AllNotiStatus.PlanFailed) {
            } else if (state.status == AllNotiStatus.PlanSuccess) {
              for (int i = 0; i < state.allNotiPlan!.listNoti.length; i++) {
                if (state.allNotiPlan!.listNoti[i].status == 1) {
                  setState(() {
                    allPlan.add(state.allNotiPlan!.listNoti[i]);
                  });
                }
              }

              if (pagePlan >= state.allNotiPlan!.totalPage) {
                setState(() {
                  enablePullUpPlan = false;
                });
              }
            } else if (state.status == AllNotiStatus.ReadProcessing) {
            } else if (state.status == AllNotiStatus.ReadFailed) {
            } else if (state.status == AllNotiStatus.ReadSuccess) {}
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        AppBar(
                          leading: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: FoodHubColors.color0B0C0C,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          automaticallyImplyLeading: false,
                          title: Text(
                            "HOẠT ĐỘNG",
                            style: TextStyle(
                              fontSize: 22,
                              color: FoodHubColors.color0B0C0C,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          centerTitle: true,
                          actions: [
                            InkWell(
                              child: const Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child:
                                    const Icon(Icons.mark_email_read_outlined),
                              ),
                              onTap: tab == 0
                                  ? () {
                                      for (int i = 0; i < allNoti.length; i++) {
                                        if (allNoti[i].status == 1 &&
                                            allNoti[i].isSeen == false) {
                                          final bloc =
                                              context.read<AllNotiBloc>();
                                          bloc.add(
                                            ReadNoti(id: allNoti[i].id),
                                          );
                                          setState(() {
                                            allNoti[i].isSeen = true;
                                            widget.onTap!(Data.numNoti - 1);
                                          });
                                        }
                                      }
                                    }
                                  : tab == 1
                                      ? () {
                                          for (int i = 0;
                                              i < allIngredient.length;
                                              i++) {
                                            if (allIngredient[i].status == 1 &&
                                                allIngredient[i].isSeen ==
                                                    false) {
                                              final bloc =
                                                  context.read<AllNotiBloc>();
                                              bloc.add(
                                                ReadNoti(
                                                    id: allIngredient[i].id),
                                              );
                                              setState(() {
                                                allIngredient[i].isSeen = true;
                                                widget.onTap!(Data.numNoti - 1);
                                              });
                                            }
                                          }
                                        }
                                      : () {
                                          for (int i = 0;
                                              i < allPlan.length;
                                              i++) {
                                            if (allPlan[i].status == 1 &&
                                                allPlan[i].isSeen == false) {
                                              final bloc =
                                                  context.read<AllNotiBloc>();
                                              bloc.add(
                                                ReadNoti(id: allPlan[i].id),
                                              );
                                              setState(() {
                                                allPlan[i].isSeen = true;
                                                widget.onTap!(Data.numNoti - 1);
                                              });
                                            }
                                          }
                                        },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: Column(
                children: [
                  Material(
                    color: FoodHubColors.colorF0F5F9,
                    child: TabBar(
                      labelColor: FoodHubColors.colorFC6011,
                      unselectedLabelColor: FoodHubColors.color0B0C0C,
                      indicatorWeight: 2,
                      indicatorColor: FoodHubColors.colorFC6011,
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                      onTap: (int index) {
                        setState(() {
                          tab = index;
                        });
                      },
                      tabs: const [
                        Tab(
                          text: "Cộng đồng",
                        ),
                        Tab(
                          text: "Nguyên liệu",
                        ),
                        Tab(
                          text: "Kế hoạch",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SmartRefresher(
                          key: _refresherKeySocial,
                          controller: _refreshControllerSocial,
                          enablePullUp: enablePullUpSocial,
                          physics: const BouncingScrollPhysics(),
                          footer: const ClassicFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                            completeDuration: Duration(milliseconds: 500),
                          ),
                          onLoading: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            setState(() {
                              pageNoti++;
                            });
                            final bloc = context.read<AllNotiBloc>();
                            bloc.add(AllNotiSocial(pageNoti));
                            _refreshControllerSocial.loadComplete();
                          },
                          onRefresh: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            setState(() {
                              allNoti.clear();
                              enablePullUpSocial = true;
                              pageNoti = 1;
                            });
                            final bloc = context.read<AllNotiBloc>();
                            bloc.add(AllNotiSocial(pageNoti));
                            _refreshControllerSocial.refreshCompleted();
                          },
                          child: ListView.builder(
                            itemCount: allNoti.length,
                            itemBuilder: (context, index) {
                              return notificationItem(allNoti[index], index);
                            },
                          ),
                        ),
                        SmartRefresher(
                          key: _refresherKeyIngredient,
                          controller: _refreshControllerIngredient,
                          enablePullUp: enablePullUpIngredient,
                          physics: const BouncingScrollPhysics(),
                          footer: const ClassicFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                            completeDuration: Duration(milliseconds: 500),
                          ),
                          onLoading: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            setState(() {
                              pageIngredient++;
                            });
                            final bloc = context.read<AllNotiBloc>();
                            bloc.add(AllNotiIngredient(pageIngredient));
                            _refreshControllerIngredient.loadComplete();
                          },
                          onRefresh: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            setState(() {
                              allIngredient.clear();
                              enablePullUpIngredient = true;
                              pageIngredient = 1;
                            });
                            final bloc = context.read<AllNotiBloc>();
                            bloc.add(AllNotiIngredient(pageIngredient));
                            _refreshControllerIngredient.refreshCompleted();
                          },
                          child: ListView.builder(
                            itemCount: allIngredient.length,
                            itemBuilder: (context, index) {
                              return notificationItem(
                                  allIngredient[index], index);
                            },
                          ),
                        ),
                        SmartRefresher(
                          key: _refresherKeyPlan,
                          controller: _refreshControllerPlan,
                          enablePullUp: enablePullUpPlan,
                          physics: const BouncingScrollPhysics(),
                          footer: const ClassicFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                            completeDuration: Duration(milliseconds: 500),
                          ),
                          onLoading: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            setState(() {
                              pagePlan++;
                            });
                            final bloc = context.read<AllNotiBloc>();
                            bloc.add(AllNotiPlan(pagePlan));
                            _refreshControllerPlan.loadComplete();
                          },
                          onRefresh: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            setState(() {
                              allPlan.clear();
                              enablePullUpPlan = true;
                              pagePlan = 1;
                            });
                            final bloc = context.read<AllNotiBloc>();
                            bloc.add(AllNotiPlan(pagePlan));
                            _refreshControllerPlan.refreshCompleted();
                          },
                          child: ListView.builder(
                            itemCount: allPlan.length,
                            itemBuilder: (context, index) {
                              return notificationItem(allPlan[index], index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  notificationItem(Noti noti, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: noti.isSeen
              ? FoodHubColors.colorF0F5F9
              : FoodHubColors.colorFC6011.withOpacity(0.5),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  child: Image.network(
                    noti.postThumbnail == ""
                        ? noti.recipeThumbnail == ""
                            ? noti.ingredientThumbnail == ""
                                ? noti.planThumbnail
                                : noti.ingredientThumbnail
                            : noti.recipeThumbnail
                        : noti.postThumbnail,
                    fit: BoxFit.cover,
                  ),
                )),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(noti.title,
                            style: TextStyle(
                                fontSize: 16,
                                color: FoodHubColors.color0B0C0C,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          noti.postTitle == ""
                              ? noti.recipeTitle == ""
                                  ? noti.content
                                  : noti.recipeTitle
                              : noti.postTitle,
                          style: TextStyle(
                              color: FoodHubColors.color0B0C0C,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            noti.isSeen == false
                ? InkWell(
                    onTap: tab == 0
                        ? () {
                            final bloc = context.read<AllNotiBloc>();
                            bloc.add(
                              ReadNoti(id: noti.id),
                            );
                            setState(() {
                              noti.isSeen = true;
                              allNoti[index].isSeen = true;
                              widget.onTap!(Data.numNoti - 1);
                            });
                          }
                        : tab == 1
                            ? () {
                                final bloc = context.read<AllNotiBloc>();
                                bloc.add(
                                  ReadNoti(id: noti.id),
                                );
                                setState(() {
                                  noti.isSeen = true;
                                  allIngredient[index].isSeen = true;
                                  widget.onTap!(Data.numNoti - 1);
                                });
                              }
                            : () {
                                final bloc = context.read<AllNotiBloc>();
                                bloc.add(
                                  ReadNoti(id: noti.id),
                                );
                                setState(() {
                                  noti.isSeen = true;
                                  allPlan[index].isSeen = true;
                                  widget.onTap!(Data.numNoti - 1);
                                });
                              },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: const Icon(Icons.mark_as_unread),
                    ))
                : Container(),
            // Container(
            //     height: 35,
            //     width: 110,
            //     decoration: BoxDecoration(
            //       color: Colors.blue[700],
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     child: const Center(
            //       child: Text(
            //         'Follow',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
