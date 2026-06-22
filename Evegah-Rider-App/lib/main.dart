import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 🚨 1. Import the vault package
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/auth_wrapper.dart';

Future<void> main() async { 
  // 🚨 3. Ensure Flutter engine is fully awake before reading native files
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // 🚨 4. Load your secret Razorpay keys from the hidden file!
  await dotenv.load(fileName: ".env"); 

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint("RUNTIME ERROR: ${details.exception}");
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.red.shade100,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            "ERROR:\n${details.exception}\n\n${details.stack}",
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ),
    );
  };

  runApp(const EvegahApp());
}

class EvegahApp extends StatelessWidget {
  const EvegahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evegah Rider',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
      //home: const MainNavigation(),
    );
  }
}


