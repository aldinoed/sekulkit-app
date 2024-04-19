import 'package:flutter/material.dart';
import 'package:sekulkit/view/splashscreen//splashscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://ozuoelyzkckdgxrocxcn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96dW9lbHl6a2NrZGd4cm9jeGNuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI1NDM5ODYsImV4cCI6MjAyODExOTk4Nn0.dXdsmLp3L0I-NAbsETfAXmRVl7cGfrlWZ5E2r-CSUi8',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
