import 'dart:io';

import 'package:chatapp/widgets/pickers/imagePicker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFun, this.isLoading);

  final void Function(String email, String password, String username,
      File? userImage, bool isLogin, BuildContext ctx) submitFun;
  bool isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";
  File? userimage = null;

  void _trySubmit(BuildContext context) {
    if (_formKey.currentState != null) {
      final isValid = _formKey.currentState?.validate();
      FocusScope.of(context).unfocus();

      if (_isLogin != true && userimage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please pick and Image."),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }

      if (isValid == true) {
        _formKey.currentState!.save();
        // print(_userEmail);
        // print(_userName);
        // print(_userPassword);

        widget.submitFun(_userEmail.trim(), _userPassword, _userName.trim(),
            userimage, _isLogin, context);
      }
    }
  }

  void setImage(File img) {
    setState(() {
      userimage = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) ImageP(imagePicked: setImage),
                  TextFormField(
                    key: ValueKey("email"),
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty && !value.contains("@")) {
                          return "Please return a valid email address";
                        }
                      } else {
                        return "Please enter a value";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty || value.length < 4) {
                            return "Please enter username of length atleast 4";
                          }
                        } else {
                          return "Please enter a username";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                      decoration: const InputDecoration(labelText: "Username"),
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    validator: (value) {
                      if (value != null) {
                        if (value.length < 7) {
                          return "Password must be 7 leters long";
                        }
                      } else {
                        return "Please enter password";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () => _trySubmit(context),
                    child: widget.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(_isLogin ? "Login" : "Signup"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? "Create new Account"
                        : "I already have account"),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
