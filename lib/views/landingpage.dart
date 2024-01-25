import 'package:flutter/material.dart';
import 'package:news_app/views/homescreen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/business.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.6,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 18,),
            const Text(
              'Latest News in the World',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15,),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                'Click the Get Started Button to Read',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 25,),
            GestureDetector(
              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width/1.2,
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(30)),
                    child: Center(child: Text('Get Starterd',style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
