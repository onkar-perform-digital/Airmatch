// import 'package:firebase_auth/firebase_auth.dart';

// FirebaseAuth auth = FirebaseAuth.instance;

// class AuthMethods {
  
//   void verify(String pnno, String otp) async {
//     try {
//           await auth.verifyPhoneNumber(
//       phoneNumber: pnno.toString(),

//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await auth.signInWithCredential(credential);
//       },

//       verificationFailed: (FirebaseAuthException e) {
//         if (e.code == 'invalid-phone-number') {
//           print('The provided phone number is not valid.');
//         }
//       },

//       codeSent: (String verificationId, int resendToken) async {
//         // Update the UI - wait for the user to enter the SMS code
//         String smsCode = otp.toString();

//         AuthCredential credential = PhoneAuthProvider.credential(
//             verificationId: verificationId, smsCode: smsCode);

//         await auth.signInWithCredential(credential);
//       },

//       timeout: const Duration(seconds: 60),

//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Auto-resolution timed out...
//       },
//     );
//     }catch(e) {
//       print(e.toString());
//     }
//   }
// }
