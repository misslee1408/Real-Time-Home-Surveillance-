import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isActive = true; // Default value

  final ApiService _apiService = ApiService();

  void _addUser() async {
    final fullName = _fullNameController.text;
    final username = _userNameController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    try {
      await _apiService.addUser(fullName, username, phone, password, _isActive);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added successfully')));
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add user')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: ' Email',
                  border: OutlineInputBorder(),
                ),
              ),
              // SizedBox(height: 10),
              // TextField(
              //   controller: _phoneController,
              //   decoration: InputDecoration(
              //     labelText: 'Phone number',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
               SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                ),
              ), 
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('* Minimum of 8 characters'),
                  Text('* Maximum of 20 characters (optional, based on preference)'),
                  Text('* Must include at least one uppercase letter (A-Z)'),
                  Text('* Must include at least one lowercase letter (a-z)'),
                  Text('* Must include at least one digit (0-9)'),
                  Text('* Must include at least one special character (e.g., !, @, #,  %, ^, &, *)'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addUser,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text('Register'),
              ),
              SizedBox(height: 10),
              Text(
                'By signing up, you agree to our Terms and Conditions\nRead our Privacy Policy',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApiService {
  Future<void> addUser(String fullName, String username, String phone, String password, bool isActive) async {
    // Implement your API call here to register the user
  }
}
