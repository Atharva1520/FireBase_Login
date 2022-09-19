import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/assets/models/userModel.dart';
import 'package:firebase_login/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegPage extends StatefulWidget {
  const RegPage({Key? key}) : super(key: key);

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  TextEditingController name1textcontroller = new TextEditingController();
  TextEditingController name2extcontroller = new TextEditingController();
  TextEditingController emailtextcontroller = new TextEditingController();
  TextEditingController passtextcontroller = new TextEditingController();
  TextEditingController conpasstextcontroller = new TextEditingController();

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
    final name1field = TextFormField(
      autofocus: false,
      controller: name1textcontroller,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name is cannot be empty.");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter valid Name(Min 3 character)");
        }
        return null;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: "First Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15)),
      onSaved: (newValue) {
        name1textcontroller.text = newValue!;
      },
      textInputAction: TextInputAction.next,
    );
    final name2field = TextFormField(
      autofocus: false,
      controller: name2extcontroller,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Second Name is cannot be empty.");
        }
        return null;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: "Second Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15)),
      onSaved: (newValue) {
        name2extcontroller.text = newValue!;
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
    final conpassfield = TextFormField(
      autofocus: false,
      controller: conpasstextcontroller,
      validator: (value) {
        if (conpasstextcontroller.text != passtextcontroller.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (newValue) {
        conpasstextcontroller.text = newValue!;
      },
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.key),
          hintText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15)),
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
    final button = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.red,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailtextcontroller.text, passtextcontroller.text);
        },
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
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
                    name1field,
                    SizedBox(
                      height: 20,
                    ),
                    name2field,
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
                    conpassfield,
                    SizedBox(
                      height: 20,
                    ),
                    button,
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
          ),
        )),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFireStore(),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email!;
    userModel.uid = user.uid;
    userModel.firstName = name1textcontroller.text;
    userModel.secondName = name2extcontroller.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created Successfully");
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => HomePage())));
  }
}
