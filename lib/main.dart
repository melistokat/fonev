import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/business_page.dart';
import 'pages/customer_page.dart';
import 'pages/property_page.dart';
import 'pages/search_page.dart';
import 'package:provider/provider.dart';
import 'providers/property_provider.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => PropertyProvider(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget { // extends komutu inheritance gibi
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2FFF4),
        fontFamily: GoogleFonts.manrope().fontFamily,

        textTheme: GoogleFonts.manropeTextTheme().copyWith(
          bodyLarge: GoogleFonts.manrope(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF112619),
          ),
          bodyMedium: GoogleFonts.manrope(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF112619),
          ),
          bodySmall: GoogleFonts.manrope(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF112619),
          ),
          labelLarge: GoogleFonts.manrope(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF112619),
          ),
          labelMedium: GoogleFonts.manrope(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF112619),
          ),
          titleLarge: GoogleFonts.manrope(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF112619),
          ),
          titleMedium: GoogleFonts.manrope(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF112619),
          ),
          titleSmall: GoogleFonts.manrope(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF112619),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.45),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF112619),
              width: 1,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF112619),
              width: 1,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF195C49),
              width: 1.8,
            ),
          ),

          labelStyle: const TextStyle(
            color: Color(0xFF112619),
            fontSize: 16,
          ),

          hintStyle: const TextStyle(
            color: Color(0xFF112619),
          ),
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF195C49),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDAF5EC),
            foregroundColor: const Color(0xFF112619),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF195C49),
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF2FFF4),
          foregroundColor: Color(0xFF112619),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> { // _ private yapar
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
Future<void> signUp() async {
  try {
    await auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }
    on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Sign up failed')),
      );
    }
}
Future<void> login() async {
  try {
    await auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
  on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Login failed')),
    );
  }
}
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Transform.translate(
            offset: const Offset(0, -35),
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/fonev_logo.png',
                height: 90,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF195C49),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Log In'),
              ),
              SizedBox(height: 16),
              Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: signUp,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Transform.translate(
            offset: const Offset(0, -25),
            child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/fonev_logo.png',
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 55),
                Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF143821),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BusinessPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Business',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF143821),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomerPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Customers',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF195C49),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PropertyPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Properties',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

            FractionallySizedBox(
              widthFactor: 0.78,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Search Properties',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ),
              ],
            ),
          ),
        ),
        ),
    );
  }
}