import 'dart:io';

import '../pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext context,
  ) submitAuthForm;
  // This was a new thing. Defining what kind of function it is that must be passed here

  final bool isLoading;

  AuthForm(
    this.submitAuthForm,
    this.isLoading,
  );

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  var _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _tryAndSubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    // Removes focus from all the fields and closes the keyboard.

    if (_userImageFile == null && !_isLogin) {
      // Don't want to submit the form if no image has been picked
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitAuthForm(
        // .trim() em all. We don't want excess white spaces causing any problems
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
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
                mainAxisSize: MainAxisSize
                    .min, // Column takes up only as much space as it's children need.
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    // The function passed to validator returns a String if there is an error,null if there isn't any.
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    key: ValueKey('email'),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                      key: ValueKey('username'),
                    ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    obscureText: true,
                    key: ValueKey('password'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Log in' : 'Sign Up'),
                      onPressed: _tryAndSubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
