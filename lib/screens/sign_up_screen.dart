import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jnjversion01windows/handlers/database_helper.dart';
import 'package:jnjversion01windows/models/user.dart';
import 'package:jnjversion01windows/screens/home_screen.dart';
import 'package:jnjversion01windows/screens/sign_in_screen.dart';
import 'package:jnjversion01windows/utilities/strings.dart';
import 'package:jnjversion01windows/utilities/univariable.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _cellController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  bool isRegisterPressed = false;
  String messageFeed = "";
  Color messageColor = Colors.redAccent;
  double paddMessage    = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/reg-01.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Dark Overlay (Optional: makes text/form easier to see)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  child: Text(Univariable.versionDisplay, style: TextStyle(fontSize: 10, color: Colors.black26),),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                      height: 150,
                      image: AssetImage('assets/images/logo-white.png'),
                      fit: BoxFit.contain
                  ),
                ),
                Flexible(
                    child: SingleChildScrollView(
                        child: withCellPassword()
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget withCellPassword(){
    return Stack(
      children: <Widget>[

        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(paddMessage),
                        child: Text(messageFeed, textAlign: TextAlign.center, style: TextStyle(color: messageColor, fontWeight: FontWeight.w600, fontSize: 18),),
                      ),
                      // NAME FIELD
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words, // Auto-capitalizes first letters
                        cursorColor: Univariable.primaryColor,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Univariable.primaryColor),
                          filled: true,
                          fillColor: Univariable.lightPimaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Univariable.primaryColor, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        validator: (val) => (val == null || val.isEmpty) ? "Please enter your name" : null,
                      ),
                      SizedBox(height: 10), // Spacing between fields
// SURNAME FIELD
                      TextFormField(
                        controller: _surnameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: Univariable.primaryColor,
                        decoration: InputDecoration(
                          labelText: "Surname",
                          labelStyle: TextStyle(color: Univariable.primaryColor),
                          filled: true,
                          fillColor: Univariable.lightPimaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Univariable.primaryColor, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        validator: (val) => (val == null || val.isEmpty) ? "Please enter your surname" : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _cellController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Univariable.primaryColor,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(color: Univariable.primaryColor), // Optional: colors label
                          filled: true,
                          fillColor: Univariable.lightPimaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none, // Removes the outline stroke
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Univariable.primaryColor, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        validator: (String? val) {
                          if (val == null || val.isEmpty) {
                            return "Please enter cellphone";
                          }
                          if (val.length != 10) {
                            return "Phone number should be 10 digits";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true, // Hides the text
                        cursorColor: Univariable.primaryColor,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Univariable.primaryColor),
                          filled: true,
                          fillColor: Univariable.lightPimaryColor,
                          // Creating the circular pill-shape
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Univariable.primaryColor, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          // Optional: Add a lock icon to match the aesthetic
                          suffixIcon: Icon(Icons.lock_outline, color: Univariable.primaryColor),
                        ),
                        validator: (String? val) {
                          if (val == null || val.isEmpty || val.length < 4) {
                            return "Incomplete field, more than 4 characters is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Univariable.primaryColor,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(color: Univariable.primaryColor),
                          filled: true,
                          fillColor: Univariable.lightPimaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Univariable.primaryColor, width: 1.5),
                          ),
                          suffixIcon: Icon(Icons.email_outlined, color: Univariable.primaryColor), // Subtle visual aid
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return "Email is required";
                          // Basic regex for email validation
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(val)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            performRegistration(
                                _cellController.text.trim(),
                                _passwordController.text.trim(),
                                _nameController.text.trim(),
                                _surnameController.text.trim(),
                                _emailController.text.trim()
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Univariable.primaryColor,
                            // Matches the 30.0 radius of your input fields
                            borderRadius: BorderRadius.circular(30.0),
                            // Optional: Add a subtle shadow to make it pop
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            "SIGN UP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2, // Makes the text look more professional
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()
                                  )
                              );
                            },
                            child: Container(
                              child: Text("Want to Sign in?",
                                style: TextStyle(
                                    color: Univariable.primaryColor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        isRegisterPressed
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Container()
      ],
    );
  }

  void performRegistration(String cellphone, String password, String name, String surname, String email) async{

    setState(() {
      isRegisterPressed = true;
    });
    //LIVE

    final Map<String, String> userObject = {
      "cell": cellphone,
      "password": password,
      "name": name,
      "surname": surname,
      "email": email
    };

    try{

      String apiUrl = BASE_API_URL + "auth/register";
      final Uri url = Uri.parse(apiUrl);

      var mydata = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json", // Crucial for sending JSON
        },
        body: jsonEncode(userObject),
      );

      if (mydata.statusCode == 200) {
        var jsonData = json.decode(mydata.body);

        final newUser = User(
          mid: jsonData['_id'],
          name: jsonData['name'],
          surname: jsonData['surname'],
          email: jsonData['email'],
          cell: jsonData['cell'],
          accessToken: jsonData['accessToken'],
          profile_url: jsonData['profile_url'],
          token: jsonData['token'],
        );

        await DatabaseHelper.instance.add(newUser);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

      } else {
        // Handle errors (e.g., show a snackbar)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
      }
    } catch (e) {
      print("Register error: $e");
      // Handle errors (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed, something went wrong, please try again later.')));
    } finally {
      setState(() {
        isRegisterPressed = false;
      });
    }
  }

}