import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polo_s/global/global.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final emailTextEditingController = TextEditingController();

  //declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    firebaseAuth
        .sendPasswordResetEmail(email: emailTextEditingController.text.trim())
        .then((value) {
      Fluttertoast.showToast(
          msg:
              "We have sent an email to recover your password. Please check your mail.");
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "Error Occurred:\n ${error.toString()}");
    });
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
                  'Change Password',
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
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     const Text(
                            //       'Don\'t an account?',
                            //       style: TextStyle(
                            //         color: Colors.grey,
                            //         fontSize: 15,
                            //       ),
                            //     ),
                            //     const SizedBox(
                            //       width: 5,
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (c) =>
                            //                     const RegisterScreen()));
                            //       },
                            //       child: const Text(
                            //         'Sign Up',
                            //         style: TextStyle(
                            //           fontSize: 15,
                            //           // color: darkTheme
                            //           //     ? Colors.amber.shade400
                            //           //     : Colors.blue,
                            //           color: Colors.blue,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
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
