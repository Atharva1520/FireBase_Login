import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/home.dart';
import 'package:firebase_login/reg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController emailtextcontroller = new TextEditingController();
  TextEditingController passtextcontroller = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final emailfield = TextFormField(
      autofocus: false,
      controller: emailtextcontroller,
      validator: ((value) {
        if (value!.isEmpty) {
          return ("Please enter your email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter valid Email");
        }
        return null;
      }),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15)),
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) {
        emailtextcontroller.text = newValue!;
      },
      textInputAction: TextInputAction.next,
    );
    final passfield = TextFormField(
      autofocus: false,
      controller: passtextcontroller,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter valid password(Min 6 character)");
        }
      },
      onSaved: (newValue) {
        passtextcontroller.text = newValue!;
      },
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.key),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15)),
    );
    final button = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.red,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailtextcontroller.text, passtextcontroller.text);
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final image = Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  "https://www.redwolf.in/image/cache/catalog/artwork-Images/mens/spiderman-logo-design-700x700.png",
                ),
                fit: BoxFit.cover)));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
            child: Container(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    image,
                    SizedBox(
                      height: 20,
                    ),
                    emailfield,
                    SizedBox(
                      height: 20,
                    ),
                    passfield,
                    SizedBox(
                      height: 20,
                    ),
                    button,
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New User?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegPage(),
                                ));
                          },
                          child: Text(
                            " SignUp",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                                fontSize: 15),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        )),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomePage(),
                ))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
        print(e);
      });
    }
  }
}
