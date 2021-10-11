import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midterm/authentication.dart';
import 'package:midterm/signup.dart';
import 'package:midterm/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Login());
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  bool _initialized = false;
  bool _error = false;
  var passwordlessSignInResult;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      var result =
          await Authentication.verifyEmailLink(email: emailController.text);

      if (passwordlessSignInResult == null) {
        setState(() {
          passwordlessSignInResult = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const userNotFoundSnackBar = SnackBar(content: Text('User not found!'));
    const wrongPasswordSnackBar =
        SnackBar(content: Text('Incorrect Password!'));
    const userLoggedInSnackBar =
        SnackBar(content: Text('Successfully Logged in!'));

    // FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(
                'assets/login.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Login',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
                suffixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              controller: emailController,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: const Icon(Icons.visibility_off),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Authentication.loginEmailAndPassword(
                          emailController.text, passwordController.text);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Homepage()));

                      ScaffoldMessenger.of(context)
                          .showSnackBar(userLoggedInSnackBar);
                    } catch (e) {
                      if (e == 'user-not-found') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(userNotFoundSnackBar);
                      } else if (e == 'wrong-password') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(wrongPasswordSnackBar);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.white),
                    // primary: Colors.lightBlue,
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await Authentication.loginWithoutPassword(
                            emailController.text);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Homepage()));

                        ScaffoldMessenger.of(context)
                            .showSnackBar(userLoggedInSnackBar);
                      } catch (e) {
                        if (e == 'user-not-found') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(userNotFoundSnackBar);
                        } else if (e == 'wrong-password') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(wrongPasswordSnackBar);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      // primary: Colors.lightBlue,
                    ),
                    child: const Text('Login Without Password')),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: SizedBox(
                  height: 36,
                  width: 280,
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                          onPressed: () async {
                            await Authentication.loginGoogle();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()));
                          },
                          icon: Icon(Icons.g_mobiledata_outlined),
                          label: SizedBox.shrink(),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0))))),
                      const SizedBox(width: 5.0),
                      ElevatedButton.icon(
                          onPressed: () async {
                            await Authentication.loginFacebook();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()));
                          },
                          icon: Icon(Icons.facebook),
                          label: SizedBox.shrink(),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0))))),
                      const SizedBox(width: 5.0),
                      ElevatedButton.icon(
                          onPressed: () async {
                            await Authentication.loginPhone();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()));
                          },
                          icon: Icon(Icons.phone_android),
                          label: SizedBox.shrink(),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0))))),
                      const SizedBox(width: 5.0),
                      ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.email),
                          label: SizedBox.shrink(),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0))))),
                    ],
                  )),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                child: const Text.rich(
                    TextSpan(text: 'Don\'t have an account? ', children: [
                  TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(color: Colors.lightBlue)),
                ]))),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
                onTap: () {
                  try {
                    Authentication.anonymousLogin();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(userLoggedInSnackBar);
                    // Push Navigator!
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homepage()));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString()),
                    ));
                  }
                },
                child: const Text.rich(TextSpan(text: 'Or Log in ', children: [
                  TextSpan(
                      text: 'Anonymously!',
                      style: TextStyle(color: Colors.lightBlue)),
                ]))),
          ]),
        ),
      ),
    );
  }
}
