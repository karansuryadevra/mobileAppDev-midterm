import 'dart:io';

import 'package:midterm/login.dart';
import 'package:midterm/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  runApp(MaterialApp(home: SignUp()));
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ImagePicker picker = ImagePicker();
  var _image;
  String imageURL = "";
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypedPasswordController = TextEditingController();
  final bioController = TextEditingController();
  final hometownController = TextEditingController();
  final ageController = TextEditingController();
  SnackBar noEmailSnackBar =
      SnackBar(content: Text('Please Enter your Email Address to Sign Up'));
  SnackBar noFirstNameSnackBar =
      SnackBar(content: Text('Please Enter your First Name to Sign Up'));
  SnackBar noLastNameSnackBar =
      SnackBar(content: Text('Please Enter your Last Name to Sign Up'));
  SnackBar noAgeSnackBar =
      SnackBar(content: Text('Please Enter your Age to Sign Up'));
  SnackBar noBioSnackBar =
      SnackBar(content: Text('Please Enter a Bio to Sign Up'));
  SnackBar noHometownSnackBar = SnackBar(
      content: Text('Please Enter the name of your hometown to Sign Up'));
  SnackBar noDisplayPicSnackBar =
      SnackBar(content: Text('Please Upload a Display Picture to Sign Up'));
  SnackBar weakPasswordSnackBar = SnackBar(content: Text('Password too weak!'));
  SnackBar passwordsDontMatchSnackBar =
      SnackBar(content: Text('Passwords don\'t match!'));
  SnackBar userExistsSnackBar =
      SnackBar(content: Text('An account already exists for that email'));
  SnackBar userCreatedSnackBar =
      SnackBar(content: Text('User Successfully created! Try Logging in!'));
  DateTime now = DateTime.now();

//     FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  imageUpload() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.blue[300],
            title: const Text('Where do you want to upload from?'),
            // content: TextField(
            //   controller: messageController,
            //   decoration: const InputDecoration(hintText: "I love my fans!"),
            //   keyboardType: TextInputType.multiline,
            //   maxLines: null,
            // ),
            actions: <Widget>[
              ElevatedButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue[600],
                ),
                child: const Text('GALLERY'),
                onPressed: () async {
                  XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = File(image!.path);
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue[600],
                ),
                child: const Text('CAMERA'),
                onPressed: () async {
                  XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _image = File(image!.path);
                    Navigator.pop(context);
                  });
                },
              ),
            ]);
      },
    );
    // return true;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = firestore.collection('users');
    final String fileName =
        DateTime.now().microsecondsSinceEpoch.toString() + ".jpeg";
    DateTime date = new DateTime(now.year, now.month, now.day);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            const Center(
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: firstnameController,
              decoration: InputDecoration(
                hintText: 'First Name',
                suffixIcon: const Icon(Icons.person_pin_circle),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: lastnameController,
              decoration: InputDecoration(
                hintText: 'Last Name',
                suffixIcon: const Icon(Icons.person_pin_circle),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                suffixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: bioController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Bio',
                suffixIcon: const Icon(Icons.text_fields_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: hometownController,
              decoration: InputDecoration(
                hintText: 'Hometown',
                suffixIcon: const Icon(Icons.house),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                hintText: 'Age',
                suffixIcon: const Icon(Icons.child_friendly),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
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
              height: 20.0,
            ),
            TextField(
              controller: retypedPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Re-Type Password',
                suffixIcon: const Icon(Icons.visibility_off),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
                child: ElevatedButton.icon(
              onPressed: () async {
                await imageUpload();
              },
              icon: const Icon(Icons.camera),
              label: const Text('Upload Display Picture'),
            )),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (emailController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(noEmailSnackBar);
                  } else if (firstnameController.text == "") {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(noFirstNameSnackBar);
                  } else if (lastnameController.text == "") {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(noLastNameSnackBar);
                  } else if (ageController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(noAgeSnackBar);
                  } else if (bioController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(noBioSnackBar);
                  } else if (hometownController.text == "") {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(noHometownSnackBar);
                  } else if (passwordController.text !=
                      retypedPasswordController.text) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(passwordsDontMatchSnackBar);
                  } else if (_image == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(noDisplayPicSnackBar);
                  } else {
                    try {
                      await Authentication.createUserEmailPassword(
                          emailController.text, passwordController.text);

                      print(fileName);

                      await storage.ref("displayPictures/" + fileName).putFile(
                          _image,
                          SettableMetadata(customMetadata: {
                            'description': firstnameController.text +
                                " " +
                                lastnameController.text
                          }));

                      imageURL = await storage
                          .ref()
                          .child('displayPictures/')
                          .child(fileName)
                          .getDownloadURL();

                      if (imageURL != null) {
                        users.add({
                          'firstName': firstnameController.text,
                          'lastName': lastnameController.text,
                          'email': emailController.text,
                          'bio': bioController.text,
                          'hometown': hometownController.text,
                          'age': ageController.text,
                          'displayPicture': imageURL,
                          'registrationTime': date.toString().split(" ")[0],
                        });
                      }

                      ScaffoldMessenger.of(context)
                          .showSnackBar(userCreatedSnackBar);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: const Text('Sign up!'))
          ],
        ),
      ),
//       body: Container(
//         child: SingleChildScrollView(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const SizedBox(
//               height: 100.0,
//             ),
//             const Text(
//               'Sign Up',
//               style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             TextField(
//               controller: firstnameController,
//               decoration: InputDecoration(
//                 hintText: 'First Name',
//                 // suffixIcon: const Icon(Icons),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             TextField(
//               controller: lastnameController,
//               decoration: InputDecoration(
//                 hintText: 'Last Name',
//                 // suffixIcon: const Icon(Icons.email),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 hintText: 'Email',
//                 suffixIcon: const Icon(Icons.email),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Password',
//                 suffixIcon: const Icon(Icons.visibility_off),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0)),
//               ),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Re-Type Password',
//                 suffixIcon: const Icon(Icons.visibility_off),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0)),
//               ),
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   UserCredential userCredential = await FirebaseAuth.instance
//                       .createUserWithEmailAndPassword(
//                           email: emailController.text,
//                           password: passwordController.text);
//                 } on FirebaseAuthException catch (e) {
//                   if (e.code == 'weak-password') {
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(weakPasswordSnackBar);
//                   } else if (e.code == 'email-already-in-use') {
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(userExistsSnackBar);
//                   }
//                 }
//                 ScaffoldMessenger.of(context).showSnackBar(userCreatedSnackBar);
//                 users.add({
//                   'firstName': firstnameController.text,
//                   'lastName': lastnameController.text,
//                   'email': emailController.text,
//                   'userRole': 'customer',
//                   'registrationTime': DateTime.now().microsecondsSinceEpoch,
//                 });
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => Login()));
//               },
//               style: TextButton.styleFrom(
//                 textStyle: const TextStyle(color: Colors.white),
//                 // primary: Colors.lightBlue,
//               ),
//               child: const Text('Sign up!'),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             GestureDetector(
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Login()));
//                 },
//                 child: const Text.rich(
//                     TextSpan(text: 'Already have an account? ', children: [
//                   TextSpan(
//                       text: 'Login', style: TextStyle(color: Colors.lightBlue)),
//                 ]))),
//           ]),
//         ),
//       ),
    );
  }
}
