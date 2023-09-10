import 'package:acfashion_store/ui/auth/login_screen.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  late Animation<double> _opacity;

  bool _isDarkMode = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _position = Tween<double>(begin: 20, end: 50).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0, 1)),
    )..addListener(() {
        setState(() {});
      });

    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(.5, 1)),
    )..addListener(() {
        setState(() {});
      });
    // Always repeat animation
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose(); // Agrega esta línea para eliminar el objeto Ticker
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return Scaffold(
      body: Container(
        color: MyColors.myBlack,
        child: Stack(
          children: [
            Positioned(
              bottom: -250,
              child: Container(
                width: size.width,
                height: size.width + 250,
                decoration: BoxDecoration(
                    gradient: RadialGradient(radius: 0.65, colors: [
                  MyColors.myPurple,
                  MyColors.myBlack,
                ])),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                width: size.width,
                child: Image.asset(
                  "assets/images/img_acfashion_text.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(
                  left: 60,
                  right: 60,
                  top: 60,
                ),
                width: size.width,
                child: Image.asset(
                  "assets/images/img_model.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(top: 160),
                height: size.height / 2,
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Tu estilo\nTU EXPRESIÓN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 37.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text:
                              "Tu estilo propio\nes tu forma de expresarte\nsin decir una palabra",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      // onTap: (){
                      //   print("assa");
                      //   Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: DashboardScreen()));
                      // },
                      onVerticalDragUpdate: (details) {
                        int sensitivity = 8;
                        if (details.delta.dy < -sensitivity) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: Login()));
                        }
                      },
                      child: AbsorbPointer(
                        child: Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Opacity(
                                  opacity: _opacity.value,
                                  child: Icon(
                                    CommunityMaterialIcons.chevron_double_up,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: "Dezliza para empezar",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}