import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'package:bookbytes_buyer/services/authentication_service.dart'; // Import the authentication service
import 'package:bookbytes_buyer/pages/main_menu.dart';
import 'package:bookbytes_buyer/Models/user.dart';
import 'package:bookbytes_buyer/widgets/common_widgets.dart'; // Import the custom widget

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final AuthenticationService _authService = AuthenticationService();

  void _login() async {
    try {
      User user = await _authService.login(_email, _password);
      // Navigate to MainScreen with User data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(user: user)),
      );
    } catch (e) {
      _showErrorDialog('Login Failed: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenHeight = mediaQueryData.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login to BookBytes'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.1),
                CustomTextField(
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextField(
                  labelText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                SizedBox(height: screenHeight * 0.04),
                ElevatedButton(
                  child: Text('Login',
                      style: TextStyle(fontSize: 20)), // Increased font size
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40), // Increased padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Less rounded corners
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _login();
                    }
                  },
                ),
                TextButton(
                  child: Text('Not a member yet? Register here'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
