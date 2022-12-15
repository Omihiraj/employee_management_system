import 'package:employee_management/main_page.dart';
import 'package:flutter/material.dart';

import 'components/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  TextEditingController textEditingControllerUser = TextEditingController();
  TextEditingController textEditingControllerPass = TextEditingController();
  FocusNode focusNodePass = FocusNode();
  FocusNode focusNodeUser = FocusNode();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/img.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  height: 530.0,
                  width: 360.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 10.0, right: 32.0, bottom: 20.0),
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/logo.png"),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 30.0,
                                top: 120.0,
                                right: 0.0,
                                bottom: 0.0),
                            child: Text(
                              "Enter your username and password below",
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "USERNAME",
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          keyboardType: TextInputType.name,
                          controller: textEditingControllerUser,
                          focusNode: focusNodeUser,
                          maxLength: 20,
                          autofocus: true,
                          onSubmitted: (text) {
                            focusNodePass.requestFocus();
                          },
                          decoration: const InputDecoration(
                              filled: true,
                              hintText: 'Username',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "PASSWORD",
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: textEditingControllerPass,
                          focusNode: focusNodePass,
                          keyboardType: TextInputType.visiblePassword,
                          onSubmitted: (text) => login(context),
                          maxLength: 8,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: _obscureText
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: secondaryColor,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: secondaryColor,
                                    ),
                              onPressed: () {
                                setState(() => _obscureText = !_obscureText);
                              },
                            ),
                          ),
                          obscureText: _obscureText,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        InkWell(
                          onTap: () {
                            login(context);
                          },
                          child: Container(
                            height: 48,
                            width: 316,
                            color: primaryColor,
                            child: const Center(
                                child: Text(
                              'Log In',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'mulish'),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void login(BuildContext context) {
    String user = textEditingControllerUser.text;
    String pass = textEditingControllerPass.text;
    if (user.isNotEmpty && pass.isNotEmpty) {
      if (user.toLowerCase() == 'admin' && pass == '(1234@QweR)') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const MainPage(),
            ));
      } else {
        focusNodeUser.requestFocus();
        textEditingControllerPass.clear();
        textEditingControllerUser.clear();
        SnackBar snackBar = const SnackBar(
          content: Text(
            'Wrong username or password !',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          backgroundColor: (Colors.black54),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      focusNodeUser.requestFocus();
      SnackBar snackBar = const SnackBar(
        content: Text(
          'Please enter login !',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        backgroundColor: (Colors.black54),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
