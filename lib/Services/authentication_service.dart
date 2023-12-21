import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookbytes_buyer/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookbytes_buyer/Utilities/constants.dart';

class AuthenticationService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login.php'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Login Server response: $jsonResponse');

      if (jsonResponse['success']) {
        User user = User.fromJson(jsonResponse['user']);
        await _saveCredentials(email, password); // Save credentials
        return user;
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    await prefs.setString('userPassword', password); // Save password
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register.php'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Register Server response: $jsonResponse');
      if (jsonResponse['success']) {
        return true;
      } else {
        // Additional condition for user already registered
        if (jsonResponse['message'] == 'User already exists') {
          throw Exception('User already registered');
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
}
