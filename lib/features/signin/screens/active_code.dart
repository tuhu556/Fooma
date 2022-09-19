import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/signin/bloc/activeCode_bloc.dart';
import 'package:foodhub/features/signin/bloc/reSendActive_bloc.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:pinput/pinput.dart';

class ActiveCodeScreen extends StatefulWidget {
  const ActiveCodeScreen({Key? key}) : super(key: key);

  @override
  State<ActiveCodeScreen> createState() => _ActiveCodeScreenState();
}

class _ActiveCodeScreenState extends State<ActiveCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ActiveCodeBloc(),
        ),
        BlocProvider(
          create: (_) => ReSendActiveBloc(),
        ),
      ],
      child: const ActiveCodeView(),
    );
  }
}

class ActiveCodeView extends StatefulWidget {
  const ActiveCodeView({Key? key}) : super(key: key);

  @override
  State<ActiveCodeView> createState() => _ActiveCodeViewState();
}

class _ActiveCodeViewState extends State<ActiveCodeView> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool check = false;
  late String email;
  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    if (args != null) {
      email = args['email'];
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<ActiveCodeBloc, ActiveCodeState>(
          listener: (context, state) async {
            if (state.status == ActiveCodeStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == ActiveCodeStatus.Failed) {
              Helpers.shared.hideDialogProgress(context);
              Helpers.shared
                  .showDialogError(context, message: "Sai mã, xin hãy thử lại");
            } else if (state.status == ActiveCodeStatus.Success) {
              Helpers.shared.hideDialogProgress(context);
              Helpers.shared.showDialogSuccess(context, message: "Success");
              state.data?.storeCredential();
              Navigator.pushNamed(
                context,
                Routes.mainTab,
              );
            }
          },
        ),
        BlocListener<ReSendActiveBloc, ReSendActiveState>(
          listener: (context, state) async {
            if (state.status == ReSendActiveStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == ReSendActiveStatus.Failed) {
              Helpers.shared.hideDialogProgress(context);
              const snackBar = SnackBar(
                content: Text("Có lỗi xảy ra!"),
                duration: Duration(milliseconds: 500),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state.status == ReSendActiveStatus.Success) {
              Helpers.shared.hideDialogProgress(context);
              const snackBar = SnackBar(
                content: Text("Thư đã được gửi"),
                duration: Duration(milliseconds: 500),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ],
      child: KeyboardDismisser(
        child: Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      Image.asset("assets/images/otp.png"),
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      Text(
                        "Mã kích hoạt tài khoản",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(25),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.02),
                      const Text(
                        "Vui lòng điền mã đã được gửi vào mail của bạn!",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.02),
                      builPinPut(),
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      DefaultButton(
                        width: getProportionateScreenWidth(250),
                        text: "TIẾP TỤC",
                        press: () {
                          final bloc = context.read<ActiveCodeBloc>();
                          bloc.add(ActiveCode(email, controller.text));
                        },
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bạn chưa nhận được thư? ",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(13)),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                final bloc = context.read<ReSendActiveBloc>();
                                bloc.add(CreateReSendActive(email));
                              });
                            },
                            child: Text(
                              "Gửi lại 1 lần nữa!",
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(13),
                                  color: FoodHubColors.colorFC6011),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget builPinPut() {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(
          fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
      decoration: BoxDecoration(
        color: FoodHubColors.colorE1E4E8,
        borderRadius: BorderRadius.circular(24),
      ),
    );
    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Pinput(
        length: 6,
        controller: controller,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        separator: const SizedBox(width: 10),
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                offset: Offset(0, 3),
                blurRadius: 16,
              ),
            ],
          ),
        ),
        showCursor: true,
        cursor: cursor,
      ),
    );
  }
}
