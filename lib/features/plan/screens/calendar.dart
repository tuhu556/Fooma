import 'package:collection/collection.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/plan/bloc/delete_plan/delete_plan_bloc.dart';
import 'package:foodhub/features/plan/bloc/get_plan/get_plan_bloc.dart';
import 'package:foodhub/features/plan/bloc/update_plan/update_plan_bloc.dart';
import 'package:foodhub/features/plan/models/meal.dart';
import 'package:foodhub/features/plan/models/plan_entity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/size_config.dart';
import '../../../helper/helper.dart';
import '../../../session/session.dart';
import '../../notification/bloc/notification_bloc.dart';
import '../../signin/provider/google_sign_in.dart';
import '../../user_profile/bloc/user_profile_bloc.dart';

const String sortOption = "asc";

class CalendarScreen extends StatefulWidget {
  final Function(int)? onTap;
  String? selectedDate;
  CalendarScreen({
    Key? key,
    this.selectedDate,
    this.onTap,
  }) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedDate != null) {
      String? parseStr = widget.selectedDate;
      selectedDate = DateTime.parse(parseStr!);
    }
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => UserProfileBloc()..add(const UserProfile()),
          ),
          BlocProvider(
            create: (_) => GetPlanBloc()
              ..add(Plan(1, 50, sortOption,
                  widget.selectedDate ?? DateTime.now().toString())),
          ),
          BlocProvider(
            create: (context) => UpdatePlanBloc(),
          ),
          BlocProvider(
            create: (context) => DeletePlanBloc(),
          ),
          BlocProvider(
              create: (_) => AllNotiBloc()..add(const AllNotification())),
        ],
        child: CalendarView(
          seletedDate: selectedDate,
          onTap: widget.onTap,
        ));
  }
}

class CalendarView extends StatefulWidget {
  final Function(int)? onTap;
  final DateTime seletedDate;
  CalendarView({
    Key? key,
    required this.seletedDate,
    this.onTap,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with AutomaticKeepAliveClientMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  String _selectedDateStr = "";
  int totalItem = 0;
  List<PlanModel> planList = [];
  bool isDelete = false;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _focusedDay = widget.seletedDate;
    _selectedDate = widget.seletedDate;
    _selectedDateStr = _selectedDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig().init(context);
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
        BlocListener<GetPlanBloc, GetPlanState>(
          listener: ((context, state) {
            if (state.status == PlanStatus.Processing) {
            } else if (state.status == PlanStatus.Failed) {
            } else if (state.status == PlanStatus.Success) {
              setState(() {
                planList.clear();
                planList = state.planResponse!.items;
                totalItem = state.planResponse!.totalItem;
              });
            }
          }),
        ),
        BlocListener<UpdatePlanBloc, UpdatePlanState>(
          listener: ((context, state) {
            if (state.status == PlanStatus.Processing) {
            } else if (state.status == PlanStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi không thể cập nhập dữ liệu"),
                ),
              );
            } else if (state.status == PlanStatus.Success) {}
          }),
        ),
        BlocListener<DeletePlanBloc, DeletePlanState>(
          listener: ((context, state) {
            if (state.status == PlanStatus.Processing) {
            } else if (state.status == PlanStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi không thể xóa dữ liệu"),
                ),
              );
            } else if (state.status == PlanStatus.Success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Đã xóa kế hoạch"),
                ),
              );
            }
          }),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.loose,
            children: [
              Positioned(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 40, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                style: subHeadingStyle,
                              ),
                              Text(
                                "Hôm nay",
                                style: headingStyle,
                              ),
                            ],
                          ),
                        ),
                        _buttonAddRecipe(),
                        const SizedBox(
                          width: 1,
                        ),
                      ],
                    ),
                    //---------------//
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 20),
                      child: DatePicker(
                        DateTime.now(),
                        height: 100,
                        width: 80,
                        initialSelectedDate: _focusedDay,
                        selectionColor: FoodHubColors.colorFC6011,
                        selectedTextColor: Colors.white,
                        dateTextStyle: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                        dayTextStyle: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                        monthTextStyle: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                        onDateChange: (date) {
                          setState(() {
                            _selectedDate = date;
                            _selectedDateStr =
                                DateFormat('yyyy-MM-dd').format(_selectedDate);
                            final bloc = context.read<GetPlanBloc>();
                            bloc.add(Plan(1, 50, sortOption, _selectedDateStr));
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 200,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: BlocBuilder<GetPlanBloc, GetPlanState>(
                    buildWhen: ((previous, current) => true),
                    builder: ((context, state) {
                      if (state.status == PlanStatus.Processing) {
                        return _buildLoading();
                      } else if (state.status == PlanStatus.Failed) {
                        return const Center(
                          child: Text("Error"),
                        );
                      } else if (state.status == PlanStatus.Success) {
                        if (planList.isNotEmpty) {
                          final group = groupBy(planList, (PlanModel model) {
                            return model.planCategory;
                          });
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 40),
                                    child: Text(
                                      totalItem.toString() + " Công thức",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(
                              //   height: 5,
                              // ),
                              SizedBox(
                                height: getProportionateScreenHeight(510),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: group.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _categoryTitle(
                                                    context,
                                                    group.keys
                                                        .elementAt(index)),
                                                ListView.builder(
                                                    itemCount: planList.length,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (BuildContext c,
                                                            int index2) {
                                                      if (group.keys.elementAt(
                                                              index) ==
                                                          planList[index2]
                                                              .planCategory) {
                                                        return _card(
                                                          c,
                                                          index2,
                                                          planList[index2],
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    }),
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return _buildNothing();
                        }
                      } else {
                        return Container();
                      }
                    }),
                  ))
            ],
          ),
        ),
        floatingActionButton: _buildFloatingButton(_selectedDateStr),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
      ),
    );
  }

  Widget _buildNothing() => Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          SvgPicture.asset(
            "assets/icons/pumpkin-food-fall-svgrepo-com.svg",
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text("Chưa có công thức nào!"),
          ),
        ],
      );
  Widget _buildLoading() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
          ),
          Center(
            child: CircularProgressIndicator(
              color: FoodHubColors.colorFC6011,
            ),
          ),
        ],
      );
  Widget _categoryTitle(
    BuildContext context,
    int category,
  ) {
    String categoryName = "";
    for (var element in meals) {
      if (category == element.id) {
        categoryName = element.mealName;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Container(
        child: Text(
          categoryName.toString().toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: FoodHubColors.colorFC6011,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton(String selectedDate) =>
      FloatingActionButton.extended(
        label: const Text(
          "Nguyên liệu cần dùng",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.remove_red_eye),
        backgroundColor: FoodHubColors.colorFC7F401,
        onPressed: () {
          Navigator.pushNamed(context, Routes.calculateIngredient,
              arguments: {"selectedDate": selectedDate});
        },
      );
  Widget _buttonDefault(Color backgroundColor, Color textColor,
          Color borderColor, String text, Function() function) =>
      Container(
        width: double.infinity,
        height: getProportionateScreenHeight(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 6,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: borderColor, width: 2)),
            primary: backgroundColor,
            backgroundColor: backgroundColor,
          ),
          onPressed: function,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  Widget _buttonAddRecipe() => SizedBox(
        width: 210,
        height: getProportionateScreenHeight(40),
        child: TextButton.icon(
          icon: const Icon(
            Icons.add,
            size: 28,
          ),
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            primary: Colors.white,
            backgroundColor: FoodHubColors.colorFC6011,
          ),
          onPressed: () async {
            await Navigator.pushNamed(context, Routes.searchRecipePlan,
                arguments: {"selectedDate": _selectedDateStr});
            final bloc = context.read<GetPlanBloc>();
            bloc.add(Plan(1, 50, sortOption, _selectedDateStr));
          },
          label: const Text(
            "Thêm công thức",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
  Widget _card(BuildContext context, int index, PlanModel? model) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            model!.onTap = true;
            bottomScreen(context, model, index);
          });
        },
        child: Container(
          height: getProportionateScreenHeight(135),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: model!.onTap
                ? Border.all(color: FoodHubColors.colorFC7F401, width: 2)
                : const Border(),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 6,
                offset: const Offset(0, 8),
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(model.thumbnail),
                        fit: BoxFit.fitWidth),
                  ),
                  height: getProportionateScreenHeight(120),
                  width: getProportionateScreenWidth(120),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 35,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                model.recipeName.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ResponsiveValue(
                                      context,
                                      defaultValue: 22.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                          name: TABLET,
                                          value: 24.0,
                                        )
                                      ],
                                    ).value,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Icons.people,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  model.serve.toString() + " khẩu phần",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: FoodHubColors.color0B0C0C),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                height: 100,
                width: 0.5,
                color: model.isCompleted
                    ? FoodHubColors.color007A32
                    : FoodHubColors.colorFFA375,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    model.isCompleted ? "COMPLETED" : "TODO",
                    style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: model.isCompleted
                            ? FoodHubColors.color007A32
                            : FoodHubColors.colorFFA375),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get subHeadingStyle {
    return GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
  }

  TextStyle get headingStyle {
    return GoogleFonts.lato(
        textStyle: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black));
  }

  void bottomScreen(
    context,
    PlanModel model,
    int index,
  ) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        context: context,
        builder: (BuildContext context2) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: BlocProvider.of<GetPlanBloc>(context),
              ),
              BlocProvider.value(
                value: BlocProvider.of<DeletePlanBloc>(context),
              ),
              BlocProvider.value(
                value: BlocProvider.of<UpdatePlanBloc>(context),
              )
            ],
            child: StatefulBuilder(builder: (context, setState) {
              return FractionallySizedBox(
                heightFactor: 0.85,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buttonDefault(
                          FoodHubColors.colorF1F1F1,
                          FoodHubColors.color30A197,
                          FoodHubColors.color30A197,
                          "Xem chi tiết công thức",
                          () => setState(
                                () {
                                  Navigator.pushNamed(
                                      context, Routes.recipeDetail,
                                      arguments: {'recipeId': model.recipeId});
                                },
                              )),
                      const SizedBox(
                        height: 20,
                      ),
                      model.isCompleted
                          ? _buttonDefault(
                              FoodHubColors.colorF1F1F1,
                              FoodHubColors.colorFC6011,
                              FoodHubColors.colorFC6011,
                              "Chưa hoàn thành kế hoạch",
                              () => setState(
                                    () {
                                      planList[index].isCompleted = false;
                                      final bloc =
                                          context.read<UpdatePlanBloc>();
                                      bloc.add(CreateUpdatePlanEvent(
                                          planId: model.planId,
                                          planCategory: model.planCategory,
                                          plannedDate: model.plannedDate,
                                          recipeId: model.recipeId,
                                          serve: model.serve,
                                          isCompleted: false));
                                      Navigator.pop(context);
                                    },
                                  ))
                          : _buttonDefault(
                              FoodHubColors.colorF1F1F1,
                              FoodHubColors.color007A32,
                              FoodHubColors.color007A32,
                              "Hoàn thành kế hoạch",
                              () => setState(
                                    () {
                                      planList[index].isCompleted = true;
                                      final bloc =
                                          context.read<UpdatePlanBloc>();
                                      bloc.add(CreateUpdatePlanEvent(
                                          planId: model.planId,
                                          planCategory: model.planCategory,
                                          plannedDate: model.plannedDate,
                                          recipeId: model.recipeId,
                                          serve: model.serve,
                                          isCompleted: true));
                                      Navigator.pop(context);
                                    },
                                  )),
                      const SizedBox(
                        height: 20,
                      ),
                      _buttonDefault(
                        FoodHubColors.colorF1F1F1,
                        FoodHubColors.colorFFC107,
                        FoodHubColors.colorFFC107,
                        "Chỉnh sửa kế hoạch",
                        () async {
                          await Navigator.pushNamed(context, Routes.updatePlan,
                              arguments: {
                                "selectedDate": _selectedDateStr,
                                "PlanModel": model
                              });
                          final bloc = context.read<GetPlanBloc>();
                          bloc.add(Plan(1, 50, sortOption, _selectedDateStr));
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buttonDefault(
                          FoodHubColors.colorF1F1F1,
                          FoodHubColors.colorCC0000,
                          FoodHubColors.colorCC0000,
                          "Xóa kế hoạch",
                          () => setState(
                                () {
                                  final bloc = context.read<DeletePlanBloc>();
                                  bloc.add(
                                      CreateDeletePlanEvent(id: model.planId));
                                  isDelete = !isDelete;
                                  totalItem--;
                                  Navigator.pop(context);
                                },
                              )),
                      const SizedBox(
                        height: 20,
                      ),
                      _buttonDefault(
                          FoodHubColors.colorE1E4E8,
                          Colors.black,
                          FoodHubColors.colorE1E4E8,
                          "Đóng",
                          () => Navigator.pop(context)),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }).whenComplete(() => setState(
          () {
            model.onTap = false;
            if (isDelete) {
              planList.removeAt(index);
              isDelete = !isDelete;
            }
          },
        ));
  }
}
