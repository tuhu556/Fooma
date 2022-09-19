import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/ingredient_manager/bloc/ingredientUser/ingredient_user_bloc.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';
import 'package:foodhub/features/plan/bloc/get_plan/get_plan_bloc.dart';
import 'package:foodhub/features/plan/bloc/get_plan_ingredient/get_plan_ingredient_bloc.dart';
import 'package:foodhub/features/plan/bloc/get_total_user_ingredient/get_total_user_ingredient_bloc.dart';
import 'package:foodhub/features/plan/bloc/save_plan/save_plan_bloc.dart';
import 'package:foodhub/features/plan/models/ingredientPrepare_entity.dart';
import 'package:foodhub/features/plan/models/ingredient_plan_calculation.dart';
import 'package:foodhub/features/plan/models/plan_entity.dart';
import 'package:foodhub/helper/helper.dart';

const String sortOption = "asc";

class CalculateIngredientScreen extends StatefulWidget {
  const CalculateIngredientScreen({Key? key}) : super(key: key);

  @override
  State<CalculateIngredientScreen> createState() =>
      _CalculateIngredientScreenState();
}

class _CalculateIngredientScreenState extends State<CalculateIngredientScreen> {
  String selectedDate = "";
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    selectedDate = args['selectedDate'];
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) =>
            GetPlanBloc()..add(Plan(1, 50, sortOption, selectedDate)),
      ),
      BlocProvider(
        create: (_) =>
            GetPlanIngredientBloc()..add(GetPlanIngredient(selectedDate)),
      ),
      BlocProvider(
        create: (context) =>
            GetTotalUserIngredientBloc()..add(const IngredientTotal()),
      ),
      BlocProvider(
        create: (context) => SavePlanBloc(),
      ),
    ], child: const CaculateIngredientView());
  }
}

class CaculateIngredientView extends StatefulWidget {
  const CaculateIngredientView({Key? key}) : super(key: key);

  @override
  State<CaculateIngredientView> createState() => _CaculateIngredientViewState();
}

class _CaculateIngredientViewState extends State<CaculateIngredientView> {
  int totalRecipe = 0;
  int totalIngredient = 0;
  int totalIngredientUser = 0;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  bool _onTap = false;
  bool _onSave = true;
  String selectedDate = "";
  List<PlanModel> planList = [];
  List<PlanIngredientModel> ingredientList = [];
  List<IngredientUserModel> ingredientUserList = [];
  List<CalculatedIngredientModel> calculatedIngredientList = [];
  List<IngredientPrepareModel> ingredientPrepareList = [];
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    selectedDate = args['selectedDate'];
    insertToCalculatedIngredientList(ingredientList, calculatedIngredientList);
    compareAndReplaceCalculatedIngredientList(
        ingredientUserList, calculatedIngredientList);
    return MultiBlocListener(
      listeners: [
        BlocListener<GetTotalUserIngredientBloc, GetTotalUserIngredientState>(
          listener: (context, state) {
            if (state.status == IngredientTotalStatus.Processing) {
            } else if (state.status == IngredientTotalStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi không thể load dữ liệu"),
                ),
              );
            } else if (state.status == IngredientTotalStatus.Success) {
              setState(
                () {
                  ingredientUserList.clear();
                  totalIngredientUser = state.ingredientUserResponse!.totalItem;
                  ingredientUserList = state.ingredientUserResponse!.items;
                },
              );
            }
          },
        ),
        BlocListener<GetPlanBloc, GetPlanState>(
          listener: ((context, state) {
            if (state.status == PlanStatus.Processing) {
            } else if (state.status == PlanStatus.Failed) {
            } else if (state.status == PlanStatus.Success) {
              setState(() {
                planList.clear();
                planList = state.planResponse!.items;
                totalRecipe = state.planResponse!.totalItem;
              });
            }
          }),
        ),
        BlocListener<GetPlanIngredientBloc, GetPlanIngredientState>(
          listener: ((context, state) {
            if (state.status == PlanIngredientStatus.Processing) {
            } else if (state.status == PlanIngredientStatus.Failed) {
            } else if (state.status == PlanIngredientStatus.Success) {
              setState(() {
                ingredientList.clear();
                ingredientList = state.planIngredientResponse!.items;
                totalIngredient = state.planIngredientResponse!.totalItem;
              });
            }
          }),
        ),
        BlocListener<SavePlanBloc, SavePlanState>(
          listener: ((context, state) {
            if (state.status == SavePlanStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == SavePlanStatus.Failed) {
              setState(() {
                _onTap = false;
                _onSave = true;
              });
              Helpers.shared.hideDialogProgress(context);
              Helpers.shared.showDialogError(context,
                  message: "Lỗi: không thể lưu kế hoạch");
            } else if (state.status == SavePlanStatus.Success) {
              Helpers.shared.hideDialogProgress(context);
              Helpers.shared.showDialogSuccess(
                context,
                message: "Lưu kế hoạch thành công",
              );
              setState(() {
                _onTap = true;
              });
            }
          }),
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
            "Nguyên liệu cần dùng",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: FoodHubColors.color0B0C0C),
          ),
          actions: [
            planList.isNotEmpty
                ? InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.save,
                        color: _onTap
                            ? FoodHubColors.colorFC6011
                            : FoodHubColors.color52616B,
                        size: 30,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _onTap = true;
                        if (_onSave) {
                          _onSave = false;
                          createIngredientPrepareList(
                              ingredientList, ingredientPrepareList);
                          final bloc = context.read<SavePlanBloc>();
                          bloc.add(
                            SavePlan(
                              planDate: selectedDate,
                              list: ingredientPrepareList,
                            ),
                          );
                        }
                      });
                    },
                  )
                : Container(),
          ],
        ),
        body: SafeArea(
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
                    return buildDataTable();
                  } else {
                    return _buildNullList();
                  }
                } else {
                  return Container();
                }
              })),
        ),
      ),
    );
  }

  Widget _buildNullList() => Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          SvgPicture.asset(
            "assets/icons/frying-pan-cook-svgrepo-com.svg",
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text("Chưa có nguyên liệu nào hết trơn á!"),
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

  Widget buildDataTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DataTable2(
        dataTextStyle: const TextStyle(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 15),
        headingTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: FoodHubColors.colorFFA375,
            fontSize: 15),
        columnSpacing: 20,
        bottomMargin: 10,
        dataRowHeight: 60,
        horizontalMargin: 15,
        minWidth: 900,
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        columns: [
          const DataColumn2(
            label: Text("Nguyên liệu"),
            size: ColumnSize.S,
            fixedWidth: 100,
          ),
          DataColumn2(
            label: const Text("Số lượng"),
            numeric: true,
            fixedWidth: 105,
            onSort: (int index, bool ascending) {
              setState(() {
                _sortColumnIndex = index;
                _sortAscending = ascending;
                ingredientList.sort(((a, b) {
                  if (!ascending) {
                    final c = a;
                    a = b;
                    b = c;
                  }
                  return a.quantity.compareTo(b.quantity);
                }));
              });
            },
          ),
          const DataColumn2(
            label: Text("Đơn vị"),
            fixedWidth: 65,
          ),
          const DataColumn2(
            label: Text("Hiện có"),
            numeric: true,
            fixedWidth: 85,
          ),
          const DataColumn2(
            label: Text("Đơn vị"),
            fixedWidth: 65,
          ),
        ],
        rows: calculatedIngredientList
            .map(
              (CalculatedIngredientModel ingredient) => DataRow2(
                cells: [
                  DataCell(
                    Text(ingredient.ingredientName),
                  ),
                  DataCell(
                    Text(ingredient.quantity.ceil().toString()),
                  ),
                  DataCell(
                    Text(ingredient.unit),
                  ),
                  DataCell(
                    ingredient.quantityUser > 0
                        ? Text(ingredient.quantityUser.ceil().toString())
                        : const Text(""),
                  ),
                  DataCell(
                    Text(ingredient.unitUser),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  void insertToCalculatedIngredientList(
      List<PlanIngredientModel> ingredientList,
      List<CalculatedIngredientModel> calculatedIngredientList) {
    calculatedIngredientList.clear();
    for (var element in ingredientList) {
      calculatedIngredientList.add(CalculatedIngredientModel(
          element.ingredientDbId,
          element.ingredientName,
          element.quantity,
          element.unit,
          0,
          ""));
    }
  }

  void compareAndReplaceCalculatedIngredientList(
      List<IngredientUserModel> ingredientUserList,
      List<CalculatedIngredientModel> calculatedIngredientList) {
    for (int i = 0; i < calculatedIngredientList.length; i++) {
      for (var element in ingredientUserList) {
        if (calculatedIngredientList[i].ingredientDbId ==
            element.ingredientDbid) {
          calculatedIngredientList[i] = CalculatedIngredientModel(
              calculatedIngredientList[i].ingredientDbId,
              calculatedIngredientList[i].ingredientName,
              calculatedIngredientList[i].quantity,
              calculatedIngredientList[i].unit,
              element.quantity,
              element.unit.toLowerCase());
        }
      }
    }
  }

  void createIngredientPrepareList(List<PlanIngredientModel> ingredientList,
      List<IngredientPrepareModel> ingredientPrepareList) {
    for (var element in ingredientList) {
      ingredientPrepareList.add(IngredientPrepareModel(element.ingredientDbId,
          element.ingredientName, element.unit, element.quantity, false));
    }
  }
}
