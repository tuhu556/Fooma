import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/forgot_password/bloc/verify_email_bloc.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key}) : super(key: key);

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyEmailBloc(),
      child: const EmailFormView(),
    );
  }
}

class EmailFormView extends StatefulWidget {
  const EmailFormView({Key? key}) : super(key: key);

  @override
  State<EmailFormView> createState() => _EmailFormViewState();
}

class _EmailFormViewState extends State<EmailFormView> {
  GlobalKey<FormState> _emailKeyForm = GlobalKey();
  TextEditingController _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyEmailBloc, VerifyEmailState>(
      listener: (context, state) {
        if (state.status == VerifyEmailStatus.Processing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == VerifyEmailStatus.Failed) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared
              .showDialogError(context, message: "Email không tồn tại!");
        } else if (state.status == VerifyEmailStatus.Success) {
          Helpers.shared.hideDialogProgress(context);
          Navigator.pushNamed(context, Routes.checkCode,
              arguments: {'email': _emailController.text});
        }
      },
      child: KeyboardDismisser(
        child: Scaffold(
          appBar: AppBar(),
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
                      SizedBox(height: SizeConfig.screenHeight! * 0.03),
                      Text(
                        "Quên Mật khẩu",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(28),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.01),
                      const Text(
                        "Vui lòng nhập email và chúng tôi sẽ gửi hướng dẫn cho bạn",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.05),
                      emailTextFrom(context),
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      DefaultButton(
                        width: double.infinity,
                        text: "TIẾP TỤC",
                        press: () {
                          if (_emailKeyForm.currentState!.validate()) {
                            if (_emailController.text.isEmpty) {
                            } else {
                              setState(() {
                                final bloc = context.read<VerifyEmailBloc>();
                                bloc.add(CreateVerifyEmailEvent(
                                    _emailController.text));
                              });
                            }
                          }
                        },
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

  Form emailTextFrom(BuildContext context) {
    return Form(
      key: _emailKeyForm,
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
        ],
      ),
    );
  }
}
