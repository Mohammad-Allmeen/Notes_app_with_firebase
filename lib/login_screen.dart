
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/login_with_phone.dart';
import 'package:flutter_with_firebase/posts_pages/post_screen.dart';
import 'package:flutter_with_firebase/rounded_button.dart';
import 'package:flutter_with_firebase/signup_screen.dart';
import 'package:flutter_with_firebase/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formkey= GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;


  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login(){
    setState(() {
      loading= true;
    });
    _auth.signInWithEmailAndPassword(
        email:emailController.text.toString(),
        password: passwordController.text.toString()).then((value){
          setState(() {
            loading= false;
          });
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
    }).onError((error,stackTrace){
      debugPrint(error.toString());
        Utils().toastMessage(error.toString());
        setState(() {
          loading=false;
        });

      });
    }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //FaIcon(FontAwesomeIcons.apple, size: 50,color: Colors.deepPurple,), //include the dependency, import the library and then we can use
            Icon(Icons.apple,
              size: 120, color: Colors.black,),
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
              height: 40,
            ),

            RoundButton(title: 'LOGIN',
              loading: loading,
              onTap: (){
                if(_formkey.currentState!.validate()){
                  login();
                }
              },),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hey are you new user?'),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  const SignUpScreen()));
                }, child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.w600),))
              ],
            ),
            SizedBox(
              height: 10,
            ),

            // when firebase provides verify. ID, we have to add key to verify our fingerprint or we create SSh key to auto detect the OTP
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithPhone()));
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                 border: Border.all(
                   color: Colors.deepPurple
                 )
                ),
                child: Center(
                  child: Text("Login with Phone", style: TextStyle(fontWeight: FontWeight.w500),),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 80))
          ],
        ),
      ),
    );
  }
}
