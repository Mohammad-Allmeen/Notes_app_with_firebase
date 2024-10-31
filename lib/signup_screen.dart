


import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/rounded_button.dart';
import 'package:flutter_with_firebase/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formkey= GlobalKey<FormState>();


  final FirebaseAuth _auth = FirebaseAuth.instance; //initialization the instance of firebase auth, basically creating instance of firebase
  //FirebaseAuth - its a class from firebase authentication library that allows to manage authentications such as sign in out and managing user log sessions
  // _auth = its a variable name in which the instance is initialized and its private that can only be accessed within the file it is declared,
  // _auth- it acts like an object to call the methods or functions inside FirebaseAuth Class
  // FirebaseAuth.instance- return the singleton pattern this means throughout app we will work with same authentication instance

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login()
  {
    setState(() {
      loading= true;
    });

    _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value){
      setState(() {
        loading= false;
      });

    }).onError((error, stackTree){
      Utils().toastMessage(error.toString());
      setState(() {
        loading= false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text("Sign up"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.apple, size: 120, color: Colors.black,),
            Text("Hello", style: GoogleFonts.bebasNeue(fontSize: 35),),
            SizedBox(
              height: 20,
            ),
            Form(
                key: _formkey,
                child: Column(
                    children:
                    [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            label: Text('Email'),
                            hintText: 'Email your email',
                            helperText: 'Enter email- abc@gmail.com',
                            suffixIcon: Icon(Icons.mail_outline, color: Colors.deepPurple,),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.deepPurple, width: 2)
                            )
                        ),

                        //check and ensuring if the text field is not not

                        validator: (value){
                          if(value!.isNotEmpty&& value.contains('@')){
                            return null;
                          }
                          return "Enter Email";
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            suffixIcon: Icon(Icons.lock_open, color: Colors.deepPurple),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.deepPurple,width: 2
                                )
                            )
                        ),
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                    ]
                )),

            const SizedBox(
              height: 30,
            ),

            RoundButton(
              title: 'SIGN UP',
              loading: loading,
              onTap: (){
                if(_formkey.currentState!.validate()){
                 login();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account!'),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  LoginScreen()));
                }, child: Text('Login', style: TextStyle(fontWeight: FontWeight.w600),))
              ],
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 90))
          ],
        ),
      ),
    );
  }
}
