import 'package:aiforgood/screens/login_screen.dart';
import 'package:flutter/material.dart';


void main()  {
  WidgetsFlutterBinding.ensureInitialized();

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