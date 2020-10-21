import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Authenthication.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

enum FormType { login, register }

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  DialogBox dialogBox = DialogBox();

  bool showSpinner = false;
  //Design
  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
          // dialogBox.information(context, "Congo", "You are Logged in Successfully");
          print("login userid = " + userId);
        } else {
          String userId = await widget.auth.signUp(_email, _password);
          // dialogBox.information(context, "Congo", "Account Created Successfully");
          print("Register userid = " + userId);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "Error!!!",
            "Wrong Email/Password Entered.\nRegister if you are new here.");
        print("Error =" + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Dream 11 Teams'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: ListView(
              children: createInputs() + createButtons(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 10,
      ),
      logo(),
      SizedBox(
        height: 10,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? 'Email is Required!!' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? 'Password is Required!!' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
      ),
      SizedBox(
        height: 10,
      )
    ];
  }

  Widget logo() {
    return Hero(
      tag: 'Hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,
        child: Image.asset('images/Analyst.png'),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () {
            validateAndSubmit();
            setState(() {
              showSpinner = true;
            });
          }, //validate and Save
        ),
        RaisedButton(
          child: Text(
            'Register if you are new here!!',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          textColor: Colors.blueGrey,
          onPressed: moveToRegister, //move to register
        )
      ];
    } else {
      return [
        RaisedButton(
          child: Text(
            'Register',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () {
            validateAndSubmit();
            setState(() {
              showSpinner = true;
            });
          }, //validate and Save
        ),
        RaisedButton(
          child: Text(
            'Already Registered ? Login',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          textColor: Colors.blueGrey,
          onPressed: moveToLogin, //move to login
        )
      ];
    }
  }
}
