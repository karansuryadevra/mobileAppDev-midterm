import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Authentication {
  static loginEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw (e.code);
    }
  }

  static loginWithoutPassword(String email) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }

    var acs = ActionCodeSettings(
        // URL you want to redirect back to. The domain (www.example.com) for this
        // URL must be whitelisted in the Firebase Console.
        url: 'https://karanmidterm.page.link/TG78',
        // This must be true
        handleCodeInApp: true,
        iOSBundleId: 'com.example.ios',
        androidPackageName: 'com.example.android',
        // installIfNotAvailable
        androidInstallApp: true,
        // minimumVersion
        androidMinimumVersion: '8');
    var emailAuth = 'someemail@domain.com';
    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  static Future<UserCredential?> verifyEmailLink({
    required String email,
  }) async {
    var result;

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      print(deepLink.toString());

      String link = deepLink.toString();

      if (auth.isSignInWithEmailLink(link)) {
        try {
          result = await auth.signInWithEmailLink(
              email: email, emailLink: deepLink.toString());
        } catch (e) {
          print(e);
        }
      }
    }

    return result;
  }

  static anonymousLogin() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw (e);
    }
  }

  static createUserEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw (e);
    }
  }

  static Future<UserCredential> loginGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw (e);
    }
  }

  static Future<UserCredential> loginFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      print("!!!!!!!!!!!!!!!" + loginResult.accessToken.toString());
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      throw (e);
    }
  }

  static loginPhone() async {
    try {
      var objectToReturn = await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+44 7123 123 456',
        verificationCompleted: (PhoneAuthCredential credential) {
          FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) => null);
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw (e);
    }
  }
}
