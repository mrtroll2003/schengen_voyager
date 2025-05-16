import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  final String Why = """Maybe you're a normal Asian with a gifted sibling/cousin studying somewhere in Europe, and now your parents want to know where they should visit after the graduation ceremony.
Maybe you just find out about your privilege as an European, and want to enjoy your life before smashing your head into the monitor for 40hrs a week.
Or maybe you're just a traveller who want to take advantage of your hard-earned Schengen visa to the fullest and don't want to listen to those pesky travel agency.
Whatever it is, I (guess) am ready to got your back!
""";
  final String AboutMe = """To be clear, I'm just an IT newgrad. Feeling too anxious about being drafted for military services, I just decide to stay home and make this, along with some "relaxing" activity (Spoiler alert: not so relaxing as an unemployed guy living with his parents). 
Anyway, hope this helps you. Have fun!
(Sending some best regards from Vietnam right now, but pretty sure Customs will keep it anyway)
P/S: Yeah, that image was from 2021, from my high school graduation. Cool, heh?
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Why does this even exist?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),textAlign: TextAlign.left,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Image.asset('lib/assets/asset1.jpg'),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Expanded(
                    flex: 2,
                    child: Text(Why),
                  )
                ],
              ),
              Text("About the creator", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),textAlign: TextAlign.right,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(AboutMe, textAlign: TextAlign.start,),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Expanded(
                    flex: 1,
                    child: Image.asset('lib/assets/asset2.jpg', height: 250),
                  )
                ],
              ),
              Text("Disclaimer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),textAlign: TextAlign.center,),
              Text("The text contents in the main page are AI-generated, and sometimes they work not quite well. Use it at your own/your parents' risks", style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
            ],
          )
        ),
      ),
    );
  }
}