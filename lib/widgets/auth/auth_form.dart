import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      print(_userEmail);
      print(_userName);
      print(_userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                      onSaved: (newValue) {
                        _userEmail = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@'))
                          return 'Please enter a correct email address';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (newValue) {
                        _userName = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length < 4)
                          return 'Please enter at least 4 characters';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      onSaved: (newValue) {
                        _userPassword = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length < 7)
                          return 'Your passowrd should be at least 7 characters long';
                        else
                          return null;
                      },
                    ),
                    SizedBox(height: 12),
                    RaisedButton(
                      child: Text('Login'),
                      onPressed: _trySubmit,
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text('Create new account'),
                      onPressed: () {},
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}