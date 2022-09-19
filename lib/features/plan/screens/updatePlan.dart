import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/plan/bloc/update_plan/update_plan_bloc.dart';
import 'package:foodhub/features/plan/models/meal.dart';
import 'package:foodhub/features/plan/models/plan_entity.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:responsive_framework/responsive_framework.dart';

class UpdatePlanScreen extends StatefulWidget {
  const UpdatePlanScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePlanScreen> createState() => _UpdatePlanScreenState();
}

class _UpdatePlanScreenState extends State<UpdatePlanScreen> {
  String selectedDate = "";
  PlanModel? _planModel;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    selectedDate = args['selectedDate'];
    _planModel = args['PlanModel'];
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UpdatePlanBloc(),
        ),
      ],
      child: UpdatePlanView(
        model: _planModel,
        selectedDate: selectedDate,
      ),
    );
  }
}

class UpdatePlanView extends StatefulWidget {
  final PlanModel? model;
  final String selectedDate;
  const UpdatePlanView({Key? key, this.model, required this.selectedDate})
      : super(key: key);

  @override
  State<UpdatePlanView> createState() => _UpdatePlanViewState();
}

class _UpdatePlanViewState extends State<UpdatePlanView> {
  PlanModel? _planModel;
  TextEditingController _serveController = new TextEditingController();
  GlobalKey<FormState> _createPlanForm = GlobalKey();
  String selectedDate = "";

  MealModel? _selectedMeal;
  @override
  initState() {
    super.initState();
    _planModel = widget.model;
    _serveController.text = widget.model!.serve.toString();
    for (int i = 0; i < meals.length; i++) {
      if (meals[i].id == _planModel!.planCategory) {
        _selectedMeal = meals[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    selectedDate = args['selectedDate'];
    print("seletedDate" + selectedDate.toString());
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdatePlanBloc, UpdatePlanState>(
          listener: (context, state) {
            if (state.status == UpdatePlanStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == UpdatePlanStatus.Failed) {
              Helpers.shared.hideDialogProgress(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi: Cập nhập thất bại!"),
                ),
              );
            } else if (state.status == UpdatePlanStatus.Success) {
              Helpers.shared.hideDialogProgress(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text("Cập nhập kế hoạch thành công!"),
                ),
              );
              Navigator.pop(context);
            }
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
            "Thay đổi kế hoạch nấu ăn",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: FoodHubColors.color0B0C0C),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Form(
                key: _createPlanForm,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Opacity(
                        opacity: 0.7,
                        child: Text(
                          'Công thức',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _card(context, _planModel),
                      const SizedBox(
                        height: 30,
                      ),
                      Helpers.shared.textFieldServes(context,
                          controllerText: _serveController),
                      const SizedBox(
                        height: 10,
                      ),
                      Opacity(
                        opacity: 0.7,
                        child: Text(
                          'Bữa trong ngày',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: FoodHubColors.colorFFFFFF),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton<MealModel>(
                              dropdownColor: FoodHubColors.colorFFFFFF,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: FoodHubColors.color0B0C0C,
                              ),
                              isExpanded: true,
                              value: _selectedMeal,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedMeal = newValue;
                                });
                              },
                              items: meals.map((MealModel e) {
                                return DropdownMenuItem<MealModel>(
                                  value: e,
                                  child: Text(
                                    e.mealName.toString(),
                                    style: TextStyle(
                                      color: FoodHubColors.color0B0C0C,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    ),
                                  ),
                                );
                              }).toList(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Center(
                        child: DefaultButton(
                          text: "LƯU THAY ĐỔI",
                          press: () {
                            Helpers.shared.hideKeyboard(context);
                            setState(() {
                              if (_createPlanForm.currentState!.validate() &&
                                  (int.parse(_serveController.text.toString()) >
                                          0 &&
                                      int.parse(_serveController.text
                                              .toString()) <=
                                          30)) {
                                final String planId = _planModel!.planId;
                                final String recipeId = _planModel!.recipeId;
                                final int planCategory = _selectedMeal!.id;
                                bool isCompleted = _planModel!.isCompleted;
                                final serve = _serveController.text.toString();
                                print("id" + recipeId);
                                // print("planCategory" + planCategory.toString());
                                // print("serve" + serve.toString());
                                // print("date" + selectedDate);
                                final bloc = context.read<UpdatePlanBloc>();
                                bloc.add(CreateUpdatePlanEvent(
                                    planId: planId,
                                    recipeId: recipeId,
                                    isCompleted: isCompleted,
                                    planCategory: _selectedMeal!.id,
                                    plannedDate: selectedDate,
                                    serve: int.parse(serve)));
                              }
                            });
                          },
                          width: 450,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeButton() => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: getProportionateScreenHeight(130),
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: DottedBorder(
              color: FoodHubColors.colorFC6011,
              strokeWidth: 3,
              dashPattern: const [10, 6],
              radius: const Radius.circular(20),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: FoodHubColors.colorFC6011,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Thêm công thức",
                      style: TextStyle(
                        fontSize: 18,
                        color: FoodHubColors.colorFC6011,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  Widget _card(BuildContext context, PlanModel? model) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: Container(
        height: getProportionateScreenHeight(120),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(model!.thumbnail),
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
                              maxLines: 3,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
