import 'dart:io';
import 'package:flutter/material.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    File image,
    BuildContext ctx,
  ) submitAuthForm;
  final bool isLoading;

  AuthForm(this.submitAuthForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    setState(() {
      _userImageFile = image;
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitAuthForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        _userImageFile,
        context,
      );
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
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
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
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
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
                      key: ValueKey('password'),
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
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                        textColor: Colors.white,
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                        onPressed: _trySubmit,
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'Already have an account'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
