import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  SplashServices splashScreen = SplashServices();//object of the SplashServices
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animation duration
      vsync: this,
    );

    // Define the slide animation
    _offsetAnimation = Tween<Offset>(
      begin: Offset(-1, 0), // Start above the screen
      end: Offset(0, 0), // End at original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Define the opacity animation
    _opacityAnimation = Tween<double>(
      begin: 0, // Start fully transparent
      end: 1, // End fully visible
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _controller.forward().then((_) {
      // Navigate or call the splash service after animation
      splashScreen.isLogin(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://cdn.prod.website-files.com/64c308983b98e1ea07cc2765/6672e6b856ebd1cf72681148_Blog_%20The%20Role%20of%20Flutter%20in%20Digital%20Transformation.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SlideTransition(
            position: _offsetAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [Padding(
                   padding: const EdgeInsets.symmetric(vertical: 140,horizontal: 70),
                   child: Text(
                     "Social Media",
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
                   ),
                 ),
                 ]

              ),
            ),
          ),
        ],
      ),
    );
  }
}
