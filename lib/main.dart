import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whether_app/local_notifications.dart';
import 'package:whether_app/providers/default_value_provider.dart';
import 'package:whether_app/providers/location_provider.dart';
import 'package:whether_app/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => LocationProvider(),
      ),ChangeNotifierProvider(
        create: (context) => DefaultValueProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 13, 2, 33)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
