

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/firestore/firestore_list_screen.dart';
import 'package:flutter_with_firebase/posts_pages/post_screen.dart';

import 'login_screen.dart';

class SplashServices {
  void isLogin( BuildContext context)
  {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser; // to check if the user is logged in or not

    if(user!=null)
      {
        Timer(Duration(seconds: 3),()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>FirestoreScreen()));
            }
        );
      }
    else
      {
        Timer(Duration(seconds: 3),()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen(),),
          );
        });
      }
  }
}