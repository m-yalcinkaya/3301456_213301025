import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:littlefont_app/services/auth_service.dart';
import 'package:littlefont_app/widgets/bottom_nav_bar.dart';
import 'package:littlefont_app/widgets/button.dart';
import 'package:littlefont_app/screens/first_screen.dart';
import 'package:littlefont_app/screens/sign_up_page.dart';

import '../utilities/google_sign_in.dart';

class Login extends ConsumerStatefulWidget {
  const Login({
    super.key,
  });

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKeyLogin = GlobalKey<FormState>();

  final _text1Controller = TextEditingController();
  final _text2Controller = TextEditingController();
  bool isLoading = false;


  @override
  void dispose() {
    _text1Controller.dispose();
    _text2Controller.dispose();
    super.dispose();
  }

  int lenghtString1 = 0;
  int lenghtString2 = 0;


  void googleButtonOnPressed(){

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? const Center(child: SpinKitWave(color: Colors.red,)) : Form(
        key: _formKeyLogin,
        child: Container(
          color: Colors.blue.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              PhysicalModel(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Button(
                      text: 'Log in with Google',
                      textColor: Colors.black,
                      color: Colors.white,
                      height: 50,
                      width: 300,
                      image: 'assets/images/google.png',
                      onPressedOperations: () async {
                        try {
                          setState(() {
                            isLoading= true;
                          });
                          await signInWithGoogle();
                          setState(() {
                            isLoading= false;
                          });
                          if(isLoading == true){
                            const Center(child: CircularProgressIndicator());
                          }else {
                            await Future.microtask(() async {
                              if (FirebaseAuth.instance.currentUser != null) {
                                await Future.microtask(
                                      () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => const BottomNavBar(),
                                        ),
                                            (route) => false);
                                  },
                                );
                              } else {
                                await Future.microtask(
                                      () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => const FirstScreen(),
                                        ),
                                            (route) => false);
                                  },
                                );
                              }
                            },);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Log in with Google Error! please try to log in normally')));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 10,
                          child: Divider(
                            thickness: 1,
                            indent: 0,
                            endIndent: 20,
                            color: Colors.black,
                          ),
                        ),
                        Text('Or'),
                        SizedBox(
                          width: 150,
                          height: 10,
                          child: Divider(
                            thickness: 1,
                            indent: 20,
                            endIndent: 0,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        width: 330,
                        height: 75,
                        alignment: Alignment.center,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              lenghtString1 = value.length;
                            });
                          },
                          validator: (value) {
                            bool isMailSymbol = false;
                            for (var i = 0; i < value!.length; i++) {
                              if (value[i] == '@') {
                                isMailSymbol = true;
                                break;
                              }
                            }
                            return !isMailSymbol ? 'Invalid Email' : null;
                          },
                          controller: _text1Controller,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            counterText: '$lenghtString1 Character',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20),
                              right: Radius.circular(20),
                            )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        width: 330,
                        height: 75,
                        alignment: Alignment.center,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              lenghtString2 = value.length;
                            });
                          },
                          validator: (value) {
                            return null;
                          },
                          controller: _text2Controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter the password',
                            counterText: '$lenghtString2 Character',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20),
                              right: Radius.circular(20),
                            )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Button(
                          height: 50,
                          width: 120,
                          text: 'Log in',
                          onPressedOperations: () async {
                            final isSuitable =
                                _formKeyLogin.currentState?.validate();
                            if (isSuitable == true) {
                              try {
                                await logInUser(context, _text1Controller.text,
                                    _text2Controller.text);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$e')));
                              }
                            }
                          },
                          color: Colors.red,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ));
                      },
                      child: const Text('Don\'t have an account? register now'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
