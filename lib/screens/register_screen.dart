import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/profile.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isAgreed = false;

  // Form fields
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  String _phone = '';
  String _image = ''; // You might want to add image upload functionality

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      if (!_isAgreed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please agree to the terms and conditions')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final profile = Profile(
          email: _email,
          firstName: _firstName,
          lastName: _lastName,
          username: _username,
          phone: _phone,
          image: _image,
          isAgreed: _isAgreed,
        );

        final result = await _authService.register(profile, _password);
        
        if (result.success) {
          // Navigate to home screen or verification screen
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          throw Exception(result.message);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => _firstName = value ?? '',
              ),
              SizedBox(height: 16),
              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => _lastName = value ?? '',
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => _username = value ?? '',
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (!value!.contains('@')) return 'Invalid email';
                  return null;
                },
                onSaved: (value) => _email = value ?? '',
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (value!.length < 6) return 'Password too short';
                  return null;
                },
                onSaved: (value) => _password = value ?? '',
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phone = value ?? '',
              ),
              SizedBox(height: 16),

              CheckboxListTile(
                title: Text('I agree to the terms and conditions'),
                value: _isAgreed,
                onChanged: (value) {
                  setState(() => _isAgreed = value ?? false);
                },
              ),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Register'),
              ),
              
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 