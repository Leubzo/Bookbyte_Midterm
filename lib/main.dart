import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'package:bookbytes_buyer/pages/book_list.dart';

void main() {
  runApp(BookBytesApp());
}

class BookBytesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define your custom color
    const Color baseColor = Color.fromARGB(255, 138, 176, 191);

    // Create a ColorScheme based on your base color
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: baseColor,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'BookBytes Buyer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme, // Use the custom ColorScheme
        // You can also customize other theme aspects based on the color scheme
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: colorScheme.primary, // Button background color
            onPrimary: colorScheme.onPrimary, // Button text color
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(), // Your SplashScreen or initial screen
    );
  }
}
