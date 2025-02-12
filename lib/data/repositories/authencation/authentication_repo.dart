import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crumbles/data/repositories/authencation/user_repo.dart';
import 'package:crumbles/features/authentication/Screens_NGO/Navigation_Ngo/navigation_ngo.dart';
import 'package:crumbles/features/authentication/screens/login/login.dart';
import 'package:crumbles/features/authentication/screens/onboarding/onboarding.dart';
import 'package:crumbles/features/authentication/screens/signUp/verify_email.dart';
import 'package:crumbles/firebase/exceptions/firebase_auth_exception.dart';
import 'package:crumbles/firebase/exceptions/firebase_exception.dart';
import 'package:crumbles/firebase/exceptions/format_exception.dart';
import 'package:crumbles/firebase/exceptions/platfom_exception.dart';
import 'package:crumbles/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;


  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  Future<void> screenRedirect() async {
    User? user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        DocumentSnapshot userDoc = await _db.collection('Users').doc(user.uid).get();
        if (userDoc.exists) {
          String userType = userDoc['UserType'];
          if (userType == 'NGO') {
            Get.offAll(() => const NavigationMenuNgo()); // Navigate to NGO Navigation Menu
          } else if (userType == 'Donator') {
            Get.offAll(() => const NavigationMenu()); // Navigate to Donator Navigation Menu
          } else {
            // Handle unknown user type if necessary
            Get.offAll(() => const NavigationMenu());
          }
        } else {
          // Handle the case where user document does not exist
          Get.offAll(() => const NavigationMenu());
        }
      } else {
        Get.offAll(() => VerfiyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true ? Get.offAll(() => const LoginScreen()) : Get.offAll(() => const onBoardingScreen());
    }
  }

  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }


  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> logout() async {
  try {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const LoginScreen());
  } on FirebaseAuthException catch (e) {
    throw TFirebaseAuthException(e.code).message;
  } on FirebaseException catch (e) {
    throw TFirebaseException(e.code).message;
  } on FormatException catch (_) {
    throw const TFormatException().message;
  } on PlatformException catch (e) {
    throw TPlatformException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again.';
  }
}

// [ReAuthenticate] - RE AUTHENTICATE USER
Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
  try {
    // Create a credential
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

    // ReAuthenticate
    await _auth.currentUser!.reauthenticateWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    throw TFirebaseAuthException(e.code).message;
  } on FirebaseException catch (e) {
    throw TFirebaseException(e.code).message;
  } on FormatException catch (_) {
    throw const TFormatException().message;
  } on PlatformException catch (e) {
    throw TPlatformException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again.';
  }
}

// DELETE USER - Remove user Auth and Firestore Account.
Future<void> deleteAccount() async {
  try {
    await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
    await _auth.currentUser?.delete();
  } on FirebaseAuthException catch (e) {
    throw TFirebaseAuthException(e.code).message;
  } on FirebaseException catch (e) {
    throw TFirebaseException(e.code).message;
  } on FormatException catch (_) {
    throw const TFormatException().message;
  } on PlatformException catch (e) {
    throw TPlatformException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again.';
  }
}




}
