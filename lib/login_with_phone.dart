
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/rounded_button.dart';
import 'package:flutter_with_firebase/utils.dart';
import 'package:flutter_with_firebase/verify_code.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {

  final phoneNumberController = TextEditingController();
  bool loading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) { // when flutter does hot reload it starts from this line Widget build(Build Context context)
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with Phone"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                label: Text('Contact Number'),
                hintText: '+91 8800112233',
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.deepPurple,
                    width: 2
                  )
                )
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(title: 'Login' , onTap: (){
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_)
                  {

                  },
                  verificationFailed: (e){
                  Utils().toastMessage(e.toString()); //if there is some Excpetion
                  },
                  codeSent: (String verificationId, int? token){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> VerifyCodeScreen(verificationID: verificationId,)));
                  }, //
                  codeAutoRetrievalTimeout: (e){
                  Utils().toastMessage(e.toString());//if the code gets expired in one minute
                  });
            },)
          ],
        ),
      )
    );
  }
}
