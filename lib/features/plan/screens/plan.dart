import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/app.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/plan/bloc/create_plan/create_plan_bloc.dart';
import 'package:foodhub/features/plan/models/card.dart';
import 'package:foodhub/features/plan/models/meal.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/size_config.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CreatePlanBloc(),
        ),
      ],
      child: const PlanView(),
    );
  }
}

class PlanView extends StatefulWidget {
  const PlanView({Key? key}) : super(key: key);

  @override
  State<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  CardModel? card;
  TextEditingController _serveController = new TextEditingController();
  GlobalKey<FormState> _createPlanForm = GlobalKey();
  String selectedDate = "";
  MealModel? _selectedMeal;
  @override
  initState() {
    super.initState();
    _selectedMeal = meals[0];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    selectedDate = args['selectedDate'];
    card = args['card'];
    print("seletedDate" + selectedDate.toString());
    return MultiBlocListener(
      listeners: [
        BlocListener<CreatePlanBloc, CreatePlanState>(
          listener: (context, state) {
            if (state.status == CreatePlanStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == CreatePlanStatus.Failed) {
              Helpers.shared.hideDialogProgress(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi: Tạo kế hoạch thất bại!"),
                ),
              );
            } else if (state.status == CreatePlanStatus.Success) {
              Helpers.shared.hideDialogProgress(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text("Tạo kế hoạch thành công!"),
                ),
              );
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MainTabView(
                      select: 2,
                      selectedDate: selectedDate,
                    ),
                  ),
                  (route) => false);
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
            "Kế hoạch nấu ăn",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: FoodHubColors.color0B0C0C),
          ),
        ),
        body: SafeArea(
          child: KeyboardDismisser(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                        _card(context, card),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                            text: "XÁC NHẬN",
                            press: () {
                              setState(() {
                                if (_createPlanForm.currentState!.validate() &&
                                    (int.parse(_serveController.text
                                                .toString()) >
                                            0 &&
                                        int.parse(_serveController.text
                                                .toString()) <=
                                            30)) {
                                  final String recipeId = card!.id;
                                  final int planCategory = _selectedMeal!.id;
                                  const bool isCompleted = false;
                                  final serve =
                                      _serveController.text.toString();
                                  print("id" + recipeId);
                                  print(
                                      "planCategory" + planCategory.toString());
                                  print("serve" + serve.toString());
                                  print("date" + selectedDate);
                                  final bloc = context.read<CreatePlanBloc>();
                                  bloc.add(CreatePlan(
                                      recipeId,
                                      selectedDate,
                                      planCategory,
                                      isCompleted,
                                      int.parse(serve)));
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
  Widget _card(BuildContext context, CardModel? model) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: Container(
        height: getProportionateScreenHeight(155),
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
                      image: NetworkImage(model!.thumbnailImage),
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
                              model.name.toString(),
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
                                  Icons.schedule,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                model.time.toString() + " phút",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: FoodHubColors.color0B0C0C),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.whatshot,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                model.calories.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: FoodHubColors.color0B0C0C),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
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
                                model.serve.toString() + " người",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: FoodHubColors.color0B0C0C),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.outdoor_grill,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                model.method.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: FoodHubColors.color0B0C0C),
                              ),
                            ],
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
