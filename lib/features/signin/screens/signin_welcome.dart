import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/signin/screens/signin.dart';

class SignInWelcomeScreen extends StatefulWidget {
  const SignInWelcomeScreen({Key? key}) : super(key: key);

  @override
  _SignInWelcomeScreenState createState() => _SignInWelcomeScreenState();
}

class _SignInWelcomeScreenState extends State<SignInWelcomeScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Image.asset(
                      "assets/images/logo.png",
                    ),
                  ),
                ),
                SpinKitThreeBounce(color: FoodHubColors.colorFC6011),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 40),
                //   child: Column(
                //     children: [
                //       textButtonWelcome("ĐĂNG NHẬP", () {
                //         Navigator.pushNamed(context, Routes.signIn);
                //       }, false),
                //       const SizedBox(
                //         height: 10,
                //       ),
                //       textButtonWelcome("ĐĂNG KÝ", () {
                //         Navigator.pushNamed(context, Routes.signUp);
                //       }, true),
                //       const SizedBox(
                //         height: 10,
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container textButtonWelcome(String text, VoidCallback onTap, bool account) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: account ? null : FoodHubColors.colorFC6011,
        borderRadius: BorderRadius.circular(10),
        border: account
            ? Border.all(
                color: FoodHubColors.colorFFFFFF,
                width: 2,
              )
            : null,
        boxShadow: account
            ? [
                BoxShadow(
                    color: FoodHubColors.color333333,
                    offset: const Offset(0, 0),
                    blurRadius: 0)
              ]
            : null,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: FoodHubColors.colorFFFFFF,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              shadows: account
                  ? [
                      Shadow(
                          color: FoodHubColors.color0B0C0C,
                          offset: const Offset(0, 0),
                          blurRadius: 5),
                    ]
                  : null),
        ),
        onPressed: onTap,
      ),
    );
  }
}


// import 'dart:async';
 
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:keyboard_dismisser/keyboard_dismisser.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({Key? key}) : super(key: key);

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => SigninBloc(),
//       child: SignInView(),
//     );
//   }
// }

// class SignInView extends StatefulWidget {
//   @override
//   State<SignInView> createState() => _SignInViewState();
// }

// class _SignInViewState extends State<SignInView> {
//   GlobalKey<FormState> _signInKeyForm = GlobalKey();

//   TextEditingController _emailController = new TextEditingController();

//   TextEditingController _passwordController = new TextEditingController();

//   bool _loginTap = false;

//   bool _showPass = true;

//   String message = '';

//   String tokenid = '';

//   Future<void> signInWithGoogle() async {
//     await Authentification().signInWithGoogle();
//     // Navigator.pushNamed(context, Routes.mainTab);
//   }

//   Future<void> token() async {
//     final tokenResult = FirebaseAuth.instance.currentUser;
//     final idToken = await tokenResult!.getIdToken();
//     tokenid = idToken.toString();
//     final bloc = context.read<SigninBloc>();
//     bloc.add(SignIn(tokenid));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<SigninBloc, SignInState>(
//       listener: (context, state) {
//         if (state.status == SignInStatus.Processing) {
//           Helpers.shared.showDialogProgress(context);
//         } else if (state.status == SignInStatus.Failed) {
//           Helpers.shared.hideDialogProgress(context);
//           Helpers.shared.showDialogError(context, message: 'Failed!');
//         } else if (state.status == SignInStatus.Success) {
//           // Store credential in local
//           state.data?.storeCredential();
//           Helpers.shared.hideDialogProgress(context);
//           if (state.data!.isRegister) {
//             Navigator.pushReplacementNamed(context, Routes.registerUser,
//                 arguments: _emailController.text);
//           } else {
//             Navigator.pushReplacementNamed(context, Routes.mainTab);
//           }
//         }
//       },
//       child: KeyboardDismisser(
//         child: Scaffold(
//             backgroundColor: SpiritColors.color3D0E6E,
//             body: SingleChildScrollView(
//               child: Container(
//                   child: SafeArea(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60)
//                           .add(EdgeInsets.symmetric(vertical: 70)),
//                   child: Column(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               AppLocalizations.of(context)!.signIntxtSignIn,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: SpiritColors.colorFFFFFF,
//                                   fontSize: 32),
//                               textAlign: TextAlign.left,
//                             ),
//                           ),
//                           SizedBox(height: 25),
//                           loginWithSocial(context),
//                           loginWithEmail(context),
//                         ],
//                       ),
//                       Visibility(
//                         visible: _loginTap,
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 20),
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: Text(
//                               message,
//                               style: TextStyle(
//                                   color: SpiritColors.colorFF5D60,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.centerRight,
//                         child: InkWell(
//                           child: Text(
//                             AppLocalizations.of(context)!.signIntxtForgotPass,
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                                 color: SpiritColors.colorFFFFFF),
//                           ),
//                           onTap: () {
//                             // Navigator.pushNamed(context, Routes.forgotPassword);
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 30.0),
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: TextButton(
//                               style: TextButton.styleFrom(
//                                   padding: EdgeInsets.all(15),
//                                   backgroundColor: Colors.purple[800],
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8))),
//                               onPressed: () async {
//                                 if (_signInKeyForm.currentState!.validate()) {
//                                   try {
//                                     UserCredential userCredential =
//                                         await FirebaseAuth.instance
//                                             .signInWithEmailAndPassword(
//                                                 email: _emailController.text,
//                                                 password:
//                                                     _passwordController.text);
//                                     _emailController.text = '';
//                                     _passwordController.text = '';
//                                     _loginTap = false;
//                                     token();
//                                   } on FirebaseAuthException catch (e) {
//                                     if (e.code == 'user-not-found') {
//                                       setState(() {
//                                         message = AppLocalizations.of(context)!
//                                             .signIntxtNoUser;
//                                         _loginTap = true;
//                                       });
//                                     } else if (e.code == 'wrong-password') {
//                                       setState(() {
//                                         message = AppLocalizations.of(context)!
//                                             .signIntxtWrongPass;
//                                         _loginTap = true;
//                                       });
//                                     }
//                                   }
//                                 }
//                               },
//                               child: Text(
//                                   AppLocalizations.of(context)!.signIntxtSignIn,
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color: SpiritColors.colorFFFFFF))),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       InkWell(
//                         child: Text(
//                           AppLocalizations.of(context)!.signIntxtSignUp,
//                           style: TextStyle(
//                             color: SpiritColors.colorFFFFFF,
//                           ),
//                         ),
//                         onTap: () {
//                           Navigator.pushNamed(context, Routes.signUp);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               )),
//             )),
//       ),
//     );
//   }

//   Form loginWithEmail(BuildContext context) {
//     return Form(
//       key: _signInKeyForm,
//       child: Column(
//         children: [
//           Helpers.shared.textFieldEmail(
//             context,
//             controllerText: _emailController,
//           ),
//           SizedBox(height: 10),
//           Helpers.shared.textFieldPassword(context,
//               controllerText: _passwordController,
//               suffixIcon: InkWell(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: _showPass
//                       ? Icon(
//                           Icons.visibility,
//                           color: SpiritColors.colorFFFFFF,
//                         )
//                       : Icon(Icons.visibility_off,
//                           color: SpiritColors.colorFFFFFF),
//                 ),
//                 onTap: () {
//                   setState(() {
//                     _showPass = !_showPass;
//                   });
//                 },
//               ),
//               obscureText: _showPass),
//         ],
//       ),
//     );
//   }

//   Widget loginWithSocial(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           // ),
//           SizedBox(
//             width: 30,
//           ),
//           ClipOval(
//             child: InkWell(
//               borderRadius: BorderRadius.circular(30),
//               child: Container(
//                 height: 60,
//                 width: 60,
//                 decoration: BoxDecoration(
//                   color: MaterialColors.socialFacebook,
//                 ),
//                 child: Icon(Ionicons.logo_facebook,
//                     size: 50.0, color: SpiritColors.colorFFFFFF),
//               ),
//               onTap: () {},
//             ),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//           ClipOval(
//             child: InkWell(
//               borderRadius: BorderRadius.circular(30),
//               child: Container(
//                 height: 60,
//                 width: 60,
//                 decoration: BoxDecoration(
//                   color: MaterialColors.socialDribbble,
//                 ),
//                 child: Icon(Ionicons.logo_google,
//                     size: 45.0, color: SpiritColors.colorFFFFFF),
//               ),
//               onTap: () {
//                 // signInWithGoogle();
//                 // _googleSignIn.signIn().then((user) {
//                 //   FirebaseAuth.instance.authStateChanges();
//                 //   Navigator.pushNamed(context, Routes.mainTab);
//                 // }).catchError((e) {});
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
