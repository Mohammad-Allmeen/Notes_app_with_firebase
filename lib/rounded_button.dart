import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget
{
  final String title;
  final bool loading;
  final VoidCallback onTap;
  const RoundButton({Key? key,
    required this.title,
    required this.onTap,
    this.loading= false
  }): super(key:key); // constructor

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  InkWell(
      onTap: onTap,
      child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(25),
              boxShadow:[  BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.5),
                  blurRadius: 0.5,
                  offset: Offset(0.0,2.0)
              )
              ]
          ),
          child: Center(
            child: loading? CircularProgressIndicator(strokeWidth: 3, color: Colors.white,): //loading animation when signing up
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.aBeeZeeTextTheme().bodyLarge?.fontFamily,
              ),
            ),
          )
      ),
    );

  }
}