import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/plan/bloc/update_saved_plan/update_saved_plan_bloc.dart';
import 'package:foodhub/features/plan/models/ingredientPrepare_entity.dart';
import 'package:intl/intl.dart';

class IngredientPreparePlanScreen extends StatefulWidget {
  const IngredientPreparePlanScreen({Key? key}) : super(key: key);

  @override
  State<IngredientPreparePlanScreen> createState() =>
      _IngredientPreparePlanScreenState();
}

class _IngredientPreparePlanScreenState
    extends State<IngredientPreparePlanScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PlanPrepareModel;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UpdateSavedPlanBloc(),
          ),
        ],
        child: IngredientPrepareView(
          model: args,
        ));
  }
}

class IngredientPrepareView extends StatefulWidget {
  final PlanPrepareModel model;
  const IngredientPrepareView({Key? key, required this.model})
      : super(key: key);

  @override
  State<IngredientPrepareView> createState() => _IngredientPrepareViewState();
}

class _IngredientPrepareViewState extends State<IngredientPrepareView> {
  int totalRecipe = 0;
  int totalIngredient = 0;
  int totalIngredientUser = 0;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<IngredientPrepareModel> ingredientList = [];
  @override
  Widget build(BuildContext context) {
    ingredientList = widget.model.ingredientList;
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateSavedPlanBloc, UpdateSavedPlanState>(
          listener: ((context, state) {
            if (state.status == UpdatePlanStatus.Processing) {
            } else if (state.status == UpdatePlanStatus.Failed) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text("Lỗi không thể cập nhập dữ liệu"),
              //   ),
              // );
            } else if (state.status == UpdatePlanStatus.Success) {}
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
            "Danh sách nguyên liệu " + convertDate(widget.model.planDate),
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: FoodHubColors.color0B0C0C),
          ),
        ),
        body: SafeArea(
          child: buildDataTable(),
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
        checkboxHorizontalMargin: 20,
        showCheckboxColumn: true,
        columnSpacing: 20,
        bottomMargin: 10,
        dataRowHeight: 60,
        horizontalMargin: 25,
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
            fixedWidth: 120,
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
            fixedWidth: 120,
          ),
        ],
        rows: ingredientList
            .map(
              (IngredientPrepareModel ingredient) => DataRow2(
                selected: ingredient.isCheck,
                onSelectChanged: (bool? value) {
                  setState(() {
                    if (ingredient.isCheck != value) {
                      ingredient.isCheck = value!;
                      final bloc = context.read<UpdateSavedPlanBloc>();
                      bloc.add(UpdateSavedPlan(
                          id: widget.model.id,
                          planDate: widget.model.planDate,
                          list: ingredientList));
                      print(value);
                    }
                  });
                },
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
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  String convertDate(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }
}
