// import 'package:flutter/material.dart';
// import 'package:foodhub/features/search_recipe/model/model.dart';
// import 'package:responsive_framework/responsive_framework.dart';

// import '../../../config/size_config.dart';
// import '../../../constants/color.dart';

// final bucketGlobal = PageStorageBucket();

// class CardRecipe extends StatefulWidget {
//   const CardRecipe({Key? key}) : super(key: key);

//   @override
//   State<CardRecipe> createState() => _CardRecipeState();
// }

// class _CardRecipeState extends State<CardRecipe> {
//   @override
//   Widget build(BuildContext context) {
//     return PageStorage(
//       bucket: bucketGlobal,
//       child: ListView.builder(
//         key: const PageStorageKey<String>('ScrollKey'),
//         physics: NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         itemCount: recipeCard.length,
//         itemBuilder: (context, index) {
//           return _card(
//             context,
//             recipeCard[index].recipeName!,
//             recipeCard[index].imagePath!,
//             recipeCard[index].time!,
//             recipeCard[index].calories!,
//             recipeCard[index].isSave!,
//           );
//         },
//       ),
//     );
//   }

//   Widget _card(BuildContext context, String recipeName, String imagePath,
//       int cookingTime, double calories, bool _isSave) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 12,
//         vertical: 20,
//       ),
//       child: Container(
//         height: getProportionateScreenHeight(150),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 3,
//               blurRadius: 6,
//               offset: const Offset(0, 8),
//             ),
//           ],
//           color: Colors.white,
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               imagePath,
//               fit: BoxFit.cover,
//               height: getProportionateScreenHeight(130),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   SizedBox(
//                     height: SizeConfig.screenHeight! * 0.01,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell(
//                         child: Icon(
//                           _isSave
//                               ? Icons.turned_in_outlined
//                               : Icons.turned_in_not_outlined,
//                           size: 40,
//                           color: _isSave
//                               ? FoodHubColors.colorFC6011
//                               : Colors.black54,
//                         ),
//                         onTap: () {
//                           const saveText = "Đã lưu công thức này";
//                           const cancelText = "Bỏ lưu công thức này";

//                           setState(() {
//                             _isSave = !_isSave;
//                             if (_isSave) {
//                               const snackBar = SnackBar(
//                                 content: Text(saveText),
//                                 duration: Duration(seconds: 1),
//                               );
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(snackBar);
//                             } else {
//                               const snackBar = SnackBar(
//                                 content: Text(cancelText),
//                                 duration: Duration(seconds: 1),
//                               );
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(snackBar);
//                             }
//                           });
//                         },
//                       ),
//                       SizedBox(
//                         width: SizeConfig.screenWidth! * 0.02,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: SizeConfig.screenHeight! * 0.01,
//                   ),
//                   Row(
//                     children: [
//                       Flexible(
//                         fit: FlexFit.loose,
//                         child: SizedBox(
//                           height: getProportionateScreenHeight(50),
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Text(
//                               recipeName,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: ResponsiveValue(
//                                     context,
//                                     defaultValue: 22.0,
//                                     valueWhen: const [
//                                       Condition.largerThan(
//                                         name: TABLET,
//                                         value: 24.0,
//                                       )
//                                     ],
//                                   ).value,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: SizeConfig.screenHeight! * 0.02,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: SizeConfig.screenWidth! * 0.04,
//                       ),
//                       const Icon(
//                         Icons.schedule,
//                         size: 25,
//                       ),
//                       SizedBox(
//                         width: SizeConfig.screenWidth! * 0.01,
//                       ),
//                       Text(
//                         cookingTime.toString() + " phút",
//                         style:
//                             const TextStyle(fontSize: 18, color: Colors.black),
//                       ),
//                       SizedBox(
//                         width: SizeConfig.screenWidth! * 0.1,
//                       ),
//                       const Icon(
//                         Icons.whatshot,
//                         size: 25,
//                       ),
//                       Text(
//                         calories.toString() + " calo",
//                         style:
//                             const TextStyle(fontSize: 18, color: Colors.black),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
