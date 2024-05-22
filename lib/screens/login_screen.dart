import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:academic_management/screens/main_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _studentId = '';
  String _password = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Student ID: $_studentId, Password: $_password');
      // todo login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreens()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 120.0),
                Icon(
                  Icons.all_inclusive,
                  size: 100.0,
                  color: Colors.blue,
                ),
                SizedBox(height: 20.0),
                Text(
                  "Let's sign you in",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Sign up and receive information from various \n computer engineering departments.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 60.0),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your student ID' : null,
                  onSaved: (value) => _studentId = value!,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                  onSaved: (value) => _password = value!,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // todo forgot password?
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Divider(color: Colors.grey),
                SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // todo Sign up
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black, fontSize: 14.0),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ],
                      ),
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
