import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/plan/bloc/delete_saved_plan/delete_saved_plan_bloc.dart';
import 'package:foodhub/features/plan/bloc/get_saved_plan/get_saved_plan_bloc.dart';
import 'package:foodhub/features/plan/models/ingredientPrepare_entity.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SavedPlanScreen extends StatefulWidget {
  const SavedPlanScreen({Key? key}) : super(key: key);

  @override
  State<SavedPlanScreen> createState() => _SavedPlanScreenState();
}

class _SavedPlanScreenState extends State<SavedPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => GetSavedPlanBloc()
          ..add(
            const GetSavedPlan(1, 100, "desc", ""),
          ),
      ),
      BlocProvider(
        create: (context) => DeleteSavedPlanBloc(),
      ),
    ], child: const SavedPlanView());
  }
}

class SavedPlanView extends StatefulWidget {
  const SavedPlanView({Key? key}) : super(key: key);

  @override
  State<SavedPlanView> createState() => _SavedPlanViewState();
}

class _SavedPlanViewState extends State<SavedPlanView> {
  List<PlanPrepareModel> planList = [];
  int totalItem = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<GetSavedPlanBloc, GetSavedPlanState>(
          listener: (context, state) {
            if (state.status == PlanStatus.Processing) {
            } else if (state.status == PlanStatus.Failed) {
            } else if (state.status == PlanStatus.Success) {
              planList.clear();
              setState(() {
                totalItem = state.planResponse!.totalItem;
                planList = state.planResponse!.planList;
              });
            }
          },
        ),
        BlocListener<DeleteSavedPlanBloc, DeleteSavedPlanState>(
          listener: (context, state) {
            if (state.status == DeletePlanStatus.Processing) {
            } else if (state.status == DeletePlanStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi không thể xóa dữ liệu"),
                ),
              );
            } else if (state.status == DeletePlanStatus.Success) {}
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
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
          title: Text(
            "Danh sách mua sắm ",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: FoodHubColors.color0B0C0C),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 25, right: 10),
              child: Text(
                totalItem.toString() + " Kế hoạch",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<GetSavedPlanBloc, GetSavedPlanState>(
                    builder: (context, state) {
                      if (state.status == PlanStatus.Processing) {
                        return _buildLoading();
                      } else if (state.status == PlanStatus.Failed) {
                        return _buildFailed();
                      } else if (state.status == PlanStatus.Success) {
                        if (planList.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: planList.length,
                            itemBuilder: (context, index) {
                              return _card(
                                context,
                                index,
                                planList[index],
                              );
                            },
                          );
                        } else {
                          return _buildNullList();
                        }
                      } else {
                        return _buildNullList();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(
        child: CircularProgressIndicator(
          color: FoodHubColors.colorFC6011,
        ),
      );
  Widget _buildFailed() => const Center(
        child: Text("Lỗi! không ổn rồi"),
      );
  Widget _buildNullList() => Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          SvgPicture.asset(
            "assets/icons/pumpkin-coco-fall-svgrepo-com.svg",
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text("Chưa có kế hoạch nào hết trơn á!"),
          ),
        ],
      );
  Widget _card(BuildContext context, int index, PlanPrepareModel model) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        child: Container(
          width: double.infinity,
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
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 35,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "Kế hoạch: ",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: FoodHubColors.colorFC7F401,
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
                      Text(
                        convertDate(model.planDate.toString()),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveValue(
                              context,
                              defaultValue: 20.0,
                              valueWhen: const [
                                Condition.largerThan(
                                  name: TABLET,
                                  value: 22.0,
                                )
                              ],
                            ).value,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Icon(
                    Icons.remove_shopping_cart_rounded,
                    size: 30,
                    color: FoodHubColors.colorCC0000,
                  ),
                  onTap: () {
                    setState(
                      () {
                        planList.removeAt(index);
                        final bloc = context.read<DeleteSavedPlanBloc>();
                        bloc.add(DeletePlan(id: model.id));
                        var snackBar = SnackBar(
                          content: Text(
                              "Đã xóa kế hoạch " + convertDate(model.planDate)),
                          duration: const Duration(milliseconds: 1500),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        totalItem--;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.ingredientPreparePlan,
            arguments: model);
      },
    );
  }

  String convertDate(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }
}
