import 'package:ecommerceapp/pages/homeScreen.dart';
import 'package:ecommerceapp/pages/login.dart';
import 'package:ecommerceapp/providers/modalHud.dart';
import 'package:ecommerceapp/widgets/customButton.dart';
import 'package:ecommerceapp/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:ecommerceapp/services/auth.dart';

// ignore: must_be_immutable
class SignUpPage extends StatelessWidget {
  final _auth = Auth();
  static String id = 'SignUpPage';
  String _email, _password;
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ModalHud>(context).isLoading,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.54,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Image.asset('assets/images/logo.png'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Form(
                            key: globalKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: <Widget>[
                                  CustomTextField(
                                    hint: 'Enter Your Email',
                                    icon: Image.asset(
                                      'assets/svg/mail.png',
                                      scale: 1.4,
                                    ),
                                    onClick: (value) {
                                      _email = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CustomTextField(
                                    hint: 'Enter Your Password',
                                    icon: Image.asset(
                                      'assets/svg/password.png',
                                      scale: 1.4,
                                    ),
                                    onClick: (value) {
                                      _password = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Builder(
                                    builder: (context) => CustomButton(
                                      width: 156,
                                      height: 57,
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () async {
                                        final modalHud = Provider.of<ModalHud>(context,listen: false);
                                        modalHud.changeIsLoading(true);
                                        if (globalKey.currentState.validate()) {
                                          try {
                                            globalKey.currentState.save();
                                            final authResult = await _auth
                                                .signUp(_email.trim(), _password.trim());
                                            modalHud.changeIsLoading(false);
                                            Navigator.pushNamed(context, HomeScreen.id);
                                          } catch (e) {
                                            modalHud.changeIsLoading(false);
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor: Color.fromRGBO(
                                                  255, 255, 255, 0.2),
                                              content: Text(
                                                e.message,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        227, 73, 124, 1),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ));
                                          }
                                        }
                                        modalHud.changeIsLoading(false);
                                      },
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color.fromARGB(1000, 72, 93, 242),
                                          Color.fromARGB(1000, 227, 73, 124)
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Already a user?',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, LoginPage.id);
                                        },
                                        child: Text(
                                          ' Log In',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  227, 73, 124, 1),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
