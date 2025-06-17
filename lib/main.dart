import 'package:aiforgood/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( AiForGood());
}
class AiForGood extends StatelessWidget{
   AiForGood({ Key? key}): super(key: key);
  @override
  Widget build(BuildContext context){
   
    return MaterialApp(
       debugShowCheckedModeBanner: false,
          home: LoginScreen()
    );
  }
}