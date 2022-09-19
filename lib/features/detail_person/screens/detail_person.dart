// import 'package:flutter/material.dart';
// import 'package:foodhub/constants/color.dart';
// import '../../../widgets/build_post_screen.dart';
// import '../../../widgets/build_recipe_screen.dart';
// import '../../social/models/post_model.dart';
// import '../../user_profile/widgets/profile_header_widget.dart';

// class DetailPersonScreen extends StatefulWidget {
//   @override
//   _DetailPersonScreenState createState() => _DetailPersonScreenState();
// }

// class _DetailPersonScreenState extends State<DetailPersonScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: FoodHubColors.colorFFFFFF,
//         title: Text(
//           "Hồ sơ người dùng",
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: FoodHubColors.color0B0C0C,
//           ),
//         ),
//       ),
//       backgroundColor: FoodHubColors.colorFFFFFF,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 0),
//         child: SafeArea(
//           child: DefaultTabController(
//             length: 2,
//             child: NestedScrollView(
//               headerSliverBuilder: (context, _) {
//                 return [
//                   SliverList(
//                     delegate: SliverChildListDelegate(
//                       [
//                         // profileHeaderWidget(context, 0),
//                       ],
//                     ),
//                   ),
//                 ];
//               },
//               body: Column(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: Material(
//                       color: FoodHubColors.colorFFFFFF,
//                       child: TabBar(
//                         labelColor: FoodHubColors.colorFC6011,
//                         unselectedLabelColor: FoodHubColors.color0B0C0C,
//                         indicatorWeight: 2,
//                         indicatorColor: FoodHubColors.colorFC6011,
//                         labelStyle: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         tabs: const [
//                           Tab(
//                             text: "Bài đăng (1000)",
//                           ),
//                           Tab(
//                             text: "Công thức (999)",
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.only(bottom: 10),
//                       color: FoodHubColors.colorF0F5F9,
//                       child: TabBarView(
//                         children: [
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: 2,
//                             itemBuilder: (context, index) {
//                               return BuildPostScreen(posts: posts[index]);
//                             },
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: 2,
//                             itemBuilder: (context, index) {
//                               return BuildRecipeScreen(
//                                 posts: posts[index],
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
