import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/user_profile/model/user_profile_entity.dart';

import '../../../widgets/detail_screen.dart';

Widget profileHeaderWidget(
    BuildContext context,
    int index,
    UserProfileResponse userProfile,
    int totalPost,
    int totalRecipe,
    bool onPress) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(color: FoodHubColors.colorFFFFFF),
    child: Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
      child: Column(
        children: [
          GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(600),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(userProfile.imageUrl ??
                        "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return DetailScreen(
                  image: userProfile.imageUrl ??
                      "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png",
                );
              }));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userProfile.name ?? "",
                style: TextStyle(
                  color: FoodHubColors.color0B0C0C,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              userProfile.role == "MANAGER"
                  ? SizedBox(
                      height: 25,
                      width: 25,
                      child: Image.asset('assets/images/tick.png'))
                  : Container(),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            userProfile.bio ?? "",
            style: TextStyle(
              fontSize: 16,
              color: FoodHubColors.color0B0C0C,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                postReact(totalPost.toString(), "Post"),
                const SizedBox(
                  width: 50,
                ),
                postReact(totalRecipe.toString(), "Recipe"),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          index == 1 ? actions(context, userProfile, onPress) : Container(),
          index == 1
              ? const SizedBox(
                  height: 10,
                )
              : Container(),
        ],
      ),
    ),
  );
}

Widget postReact(String number, String title) {
  return Container(
    width: 100,
    decoration: BoxDecoration(
      color: FoodHubColors.colorF0F5F9,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 22,
              color: FoodHubColors.color0B0C0C,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: FoodHubColors.color0B0C0C,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget actions(
    BuildContext context, UserProfileResponse userProfile, bool onPress) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("Chỉnh sửa trang cá nhân",
                  style: TextStyle(
                    fontSize: 16,
                    color: FoodHubColors.color0B0C0C,
                  )),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: FoodHubColors.colorF0F5F9,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: const Size(0, 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(
                color: FoodHubColors.colorDADCE6,
              ),
            ),
            onPressed: onPress
                ? () {
                    Navigator.pushNamed(context, Routes.editUserProfile,
                        arguments: userProfile);
                  }
                : null,
          ),
        ),
      ],
    ),
  );
}
