import 'package:flutter/material.dart';
import 'create_account_screen.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/locked_house.jpg',
                height: 150,
              ),
              SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username / email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility), // Using Material Icons
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                      );
                    },
                    child: Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Forgot password action
                    },
                    child: Text('Forgot password'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Log in action
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text('Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
