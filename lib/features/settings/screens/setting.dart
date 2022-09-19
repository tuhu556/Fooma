import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/features/signout/bloc/remove_device_id_bloc.dart';

import '../../../config/routes.dart';
import '../../../constants/color.dart';
import '../../../helper/helper.dart';
import '../../../session/session.dart';
import '../../signin/provider/google_sign_in.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RemoveDeviceIdBloc(),
      child: const SettingView(),
    );
  }
}

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoveDeviceIdBloc, RemoveDeviceIdState>(
      listener: (context, state) {
        if (state.status == RemoveStatus.Processing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == RemoveStatus.Failed) {
          Helpers.shared.hideDialogProgress(context);
          signOutGoogle();
          ApplicationSesson.shared.clearSession();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
        } else if (state.status == RemoveStatus.Success) {
          Helpers.shared.hideDialogProgress(context);
          signOutGoogle();
          ApplicationSesson.shared.clearSession();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: FoodHubColors.colorF0F5F9,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: FoodHubColors.colorF0F5F9,
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
            "Cài đặt",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: FoodHubColors.color0B0C0C),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              // widgetButton('assets/icons/notification.svg', "Thông báo", () {}),
              ApplicationSesson.shared.credential!.role != "USER_GOOGLE"
                  ? widgetButton('assets/icons/password.svg', "Đổi mật khẩu",
                      () {
                      Navigator.pushNamed(context, Routes.changePasswordUser);
                    })
                  : Container(),
              widgetButton(
                  'assets/icons/feedback.svg', "Góp ý ứng dụng", () {}),
              widgetButton(
                  'assets/icons/question.svg', "Những câu hỏi thường gặp", () {
                Navigator.pushNamed(context, Routes.question);
              }),
              widgetButton('assets/icons/information.svg', "Về Fooma", () {}),
              // widgetButtonLogout('assets/icons/logout.svg', "Đăng xuất", () {
              //   Helpers.shared.showDialogConfirm(context,
              //       title: "Đăng xuất",
              //       message: "Bạn có muốn đăng xuất tài khoản không?",
              //       okFunction: () async {
              //     String deviceId =
              //         await FirebaseMessaging.instance.getToken() ?? "";
              //     final bloc = context.read<RemoveDeviceIdBloc>();
              //     bloc.add(RemoveDeviceId(deviceId));
              //   });
              // }),
            ],
          ),
        )),
      ),
    );
  }

  Widget widgetButton(String icon, String text, VoidCallback onTap) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon, height: 30),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: FoodHubColors.color0B0C0C,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 1,
                    color: FoodHubColors.color0B0C0C.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget widgetButtonLogout(String icon, String text, VoidCallback onTap) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              icon,
              height: 30,
              color: FoodHubColors.colorFC6011,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: FoodHubColors.colorFC6011,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 1,
                    color: FoodHubColors.colorFC6011,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
