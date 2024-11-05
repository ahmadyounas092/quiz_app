import 'package:flutter/material.dart';
import 'package:quiz_api_app/utils/images.dart';
import 'package:quiz_api_app/widgets/quiz_container_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: Image.asset(
              Images.bg2,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SizedBox(
              child: ListView(
                children: const [
                  SizedBox(
                    height: 50,
                  ),
                  QuizContainerWidget(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
