import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/signin/components/socal_card.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:foodhub/widgets/no_account_text.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../bloc/signin_bloc.dart';
import '../provider/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SigninBloc(),
      child: SignInView(),
    );
  }
}

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  GlobalKey<FormState> _signInKeyForm = GlobalKey();

  TextEditingController _emailController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  bool _loginTap = false;
  bool _showPass = true;
  String message = "";

  ConnectivityResult? _connectivityResult;
  late StreamSubscription _connectivitySubscription;
  bool? _isConnectionSuccessful;

  @override
  initState() {
    super.initState();
    // _emailController.text = "";
    // _passwordController.text = "";
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        setState(() {
          _connectivityResult = result;
        });
        if (result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile) {
          Helpers.shared.showDialogError(
            context,
            message:
                "???? c?? l???i x???y ra trong qu?? tr??nh k???t n???i v???i m??y ch???. Vui l??ng ki???m tra k???t n???i m???ng v?? th??? l???i sau",
            title: 'L???i k???t n???i m???ng',
          );
        }
      },
    );
  }

  @override
  dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  Future<void> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      print('Connected to a Wi-Fi network');
    } else if (result == ConnectivityResult.mobile) {
      print('Connected to a mobile network');
    } else {
      print('Not connected to any network');
    }

    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<SigninBloc, SignInState>(
      listener: (context, state) async {
        if (state.status == SignInStatus.Processing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == SignInStatus.NotActive) {
          Helpers.shared.hideDialogProgress(context);
          Navigator.pushNamed(context, Routes.activeCode,
              arguments: {'email': _emailController.text});
        } else if (state.status == SignInStatus.Failed) {
          Helpers.shared.hideDialogProgress(context);

          final ConnectivityResult result =
              await Connectivity().checkConnectivity();

          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            Helpers.shared.showDialogError(
              context,
              message: "T??i kho???n ho???c m???t kh???u kh??ng ????ng",
            );
          } else {
            Helpers.shared.showDialogError(
              context,
              message:
                  "???? c?? l???i x???y ra trong qu?? tr??nh k???t n???i v???i m??y ch???. Vui l??ng ki???m tra k???t n???i m???ng v?? th??? l???i sau",
              title: 'L???i k???t n???i ?????n m??y ch???',
            );
          }
        } else if (state.status == SignInStatus.Ban) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared.showDialogError(
            context,
            message:
                "T??i kho???n c???a b???n b??? kh??a do vi ph???m quy t???c c???ng ?????ng. Ki???m tra email ????? bi???t th??m th??ng tin chi ti???t",
            title: 'Kh??a t??i kho???n',
          );
        } else if (state.status == SignInStatus.Success) {
          // Store credential in local
          if (state.data?.status == "1") {
            state.data?.storeCredential();
            Helpers.shared.hideDialogProgress(context);
            Navigator.pushNamed(context, Routes.mainTab);
          } else if (state.data?.status == "0") {
            Helpers.shared.hideDialogProgress(context);
            Helpers.shared.showDialogConfirm(context,
                message: "T??i kho???n c???a b???n ???? b??? kh??a", title: "T??i kho???n");
          } else {
            Helpers.shared.hideDialogProgress(context);
            Helpers.shared.showDialogConfirm(context,
                message: "???? c?? l???i x???y ra v???i t??i kho???n c???a b???n",
                title: "T??i kho???n");
          }
        } else if (state.status == SignInStatus.WithGoogleProcessing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == SignInStatus.WithGoogleFailed) {
          Helpers.shared.hideDialogProgress(context);

          final ConnectivityResult result =
              await Connectivity().checkConnectivity();

          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            Helpers.shared.showDialogError(
              context,
              message: "T??i kho???n kh??ng ????ng",
            );
          } else {
            Helpers.shared.showDialogError(
              context,
              message:
                  "???? c?? l???i x???y ra trong qu?? tr??nh k???t n???i v???i m??y ch???. Vui l??ng ki???m tra k???t n???i m???ng v?? th??? l???i sau",
              title: 'L???i k???t n???i ?????n m??y ch???',
            );
          }
          signOutGoogle();
        } else if (state.status == SignInStatus.WithGoogleSuccess) {
          // Store credential in local
          if (state.data?.status == "1") {
            state.data?.storeCredential();
            Helpers.shared.hideDialogProgress(context);
            Navigator.pushNamed(context, Routes.mainTab);
          } else if (state.data?.status == "0") {
            Helpers.shared.hideDialogProgress(context);
            Helpers.shared.showDialogConfirm(context,
                message: "T??i kho???n c???a b???n ???? b??? kh??a", title: "T??i kho???n");
          }
        }
      },
      child: KeyboardDismisser(
        child: Scaffold(
          body: WillPopScope(
            onWillPop: () async {
              Helpers.shared.showDialogConfirm(context,
                  title: "Tho??t",
                  message: "B???n c?? mu???n tho??t kh???i ???ng d???ng kh??ng?",
                  okFunction: () {
                // exit(0);
                // SystemNavigator.pop();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                // Future.delayed(Duration.zero, () {
                //   Navigator.of(context)
                //       .pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
                //   ApplicationSesson.shared.clearSession();
                // });
                // signOut();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     Routes.signIn, (Route<dynamic> route) => false);
              });
              return true;
            },
            child: SafeArea(
                child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: Image.asset(
                          "assets/images/logo.png",
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.05,
                      ),
                      Text(
                        "????ng nh???p",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(28),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      loginWithEmail(context),
                      Visibility(
                        visible: _loginTap,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              message,
                              style: TextStyle(
                                  color: FoodHubColors.colorCC0000,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.02,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: Text(
                            "Qu??n m???t kh???u?",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: FoodHubColors.color333333),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, Routes.forgotPass);
                          },
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.03),
                      DefaultButton(
                        width: double.infinity,
                        text: "????NG NH???P",
                        press: () async {
                          if (_signInKeyForm.currentState!.validate()) {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                            } else {
                              String deviceId =
                                  await FirebaseMessaging.instance.getToken() ??
                                      "";
                              final bloc = context.read<SigninBloc>();
                              bloc.add(SignIn(_emailController.text,
                                  _passwordController.text, deviceId));
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: FoodHubColors.colorB7B7B7,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(10),
                              ),
                              child: Text(
                                "Ho???c",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: FoodHubColors.color0B0C0C,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: FoodHubColors.colorB7B7B7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocalCard(
                            icon: "assets/icons/google-icon.svg",
                            press: () {
                              signInWithGoogle().then((result) async {
                                if (result != null) {
                                  String deviceId = await FirebaseMessaging
                                          .instance
                                          .getToken() ??
                                      "";
                                  final bloc = context.read<SigninBloc>();
                                  bloc.add(SignInWithGoogle(result, deviceId));
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.04,
                      ),
                      const NoAccountText(),
                    ],
                  ),
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }

  Form loginWithEmail(BuildContext context) {
    return Form(
      key: _signInKeyForm,
      child: Column(
        children: [
          Helpers.shared.textFieldUserID(
            context,
            controllerText: _emailController,
            suffixIcon: Icon(
              Icons.mail,
              color: FoodHubColors.colorFC6011,
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.01,
          ),
          Helpers.shared.textFieldPassword(context,
              controllerText: _passwordController,
              suffixIcon: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _showPass
                      ? Icon(
                          Icons.visibility,
                          color: FoodHubColors.colorFC6011,
                        )
                      : Icon(Icons.visibility_off,
                          color: FoodHubColors.colorFC6011),
                ),
                onTap: () {
                  setState(() {
                    _showPass = !_showPass;
                  });
                },
              ),
              obscureText: _showPass),
        ],
      ),
    );
  }
}
