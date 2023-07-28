import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polo_s/screens/main_screen_user.dart';
import 'package:polo_s/screens/register_screen.dart';

import '../global/global.dart';
import 'forgot_password_screen.dart';
//import 'map_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String idScreen = "login";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  //declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    //validate all the form fields
    if (_formKey.currentState!.validate()) {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((auth) async {
        currentUser = auth.user;
        await Fluttertoast.showToast(msg: 'Logged In Successfully');
        if (context.mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MainScreen()));
        }
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: 'Error occurred:\n$errorMessage');
      });
    } else {
      Fluttertoast.showToast(msg: 'Not all fields are valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool darkTheme =
    //     MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset('images/Polo.png'),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                    // color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                // fillColor: darkTheme
                                //     ? Colors.black45
                                //     : Colors.grey.shade200,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  // color: darkTheme
                                  //     ? Colors.amber.shade400
                                  //     : Colors.grey,
                                  color: Colors.grey,
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Email cannot be empty';
                                }
                                if (EmailValidator.validate(text) == true) {
                                  return null;
                                }
                                if (text.length < 2) {
                                  return 'Please enter a valid mail';
                                }
                                if (text.length > 99) {
                                  return 'Email cannot be more than 100 characters';
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                emailTextEditingController.text = text;
                              }),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: !_passwordVisible,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                // fillColor: darkTheme
                                //     ? Colors.black45
                                //     : Colors.grey.shade200,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  // color: darkTheme
                                  //     ? Colors.amber.shade400
                                  //     : Colors.grey,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    // color: darkTheme
                                    //     ? Colors.amber.shade400
                                    //     : Colors.grey,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    //update the state; i.e, set the state of the passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Password cannot be empty';
                                }
                                if (text !=
                                    passwordTextEditingController.text) {
                                  return 'Passwords do not match';
                                }
                                if (text.length < 2) {
                                  return 'Please enter a valid password';
                                }
                                if (text.length > 49) {
                                  return 'Password cannot be more than 50 characters';
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                passwordTextEditingController.text = text;
                              }),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: darkTheme
                                //     ? Colors.amber.shade400
                                //     : Colors.blue,
                                backgroundColor: Colors.blue,
                                // foregroundColor:
                                //     darkTheme ? Colors.black : Colors.white,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                _submit();
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const ForgotPasswordScreen()));
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  // color: darkTheme
                                  //     ? Colors.amber.shade400
                                  //     : Colors.blue,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) =>
                                                const RegisterScreen()));
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 15,
                                      // color: darkTheme
                                      //     ? Colors.amber.shade400
                                      //     : Colors.blue,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
