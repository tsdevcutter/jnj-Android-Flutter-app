
import 'package:flutter/material.dart';
import 'package:jnjversion01windows/handlers/database_helper.dart';
import 'package:jnjversion01windows/models/user.dart';
import 'package:jnjversion01windows/screens/home_screen.dart';
import 'package:jnjversion01windows/utilities/strings.dart';
import 'package:jnjversion01windows/utilities/univariable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jnjversion01windows/screens/sign_reset_password.dart';
import 'package:jnjversion01windows/screens/sign_up_screen.dart';
import 'package:url_launcher/link.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _cellController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  bool isLoginPressed   = false;
  String messageFeed    = "";
  Color messageColor    = Colors.redAccent;
  double paddMessage    = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Univariable.whiteColor,
      key: _scafoldKey,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/login-01.jpg',
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
                const Spacer(),
                Container(
                  child: Text(Univariable.versionDisplay, style: TextStyle(fontSize: 10, color: Univariable.whiteColor),),
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

                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(paddMessage),
                        child: Text(messageFeed, textAlign: TextAlign.center, style: TextStyle(color: messageColor, fontWeight: FontWeight.w600, fontSize: 18),),
                      ),
                      TextFormField(
                        controller: _cellController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Univariable.primaryColor,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(color: Univariable.primaryColor), // Optional: colors label
                          filled: true,
                          fillColor: Univariable.lightPimaryColor,
                          // Use border: InputBorder.none if you want no border at all,
                          // or OutlineInputBorder for rounded edges
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none, // Removes the outline stroke
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Univariable.primaryColor, width: 1.5),
                          ),
                          suffixIcon: Icon(Icons.phone, color: Univariable.primaryColor),
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
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            performLogin(_cellController.text.trim(), _passwordController.text.trim());
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
                            "SIGN IN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2, // Makes the text look more professional
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignResetPassword()
                                  )
                              );
                            },
                            child: Container(
                              child: Text("Forgot password?",
                                style: TextStyle(
                                    color: Univariable.primaryColor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()
                                  )
                              );
                            },
                            child: Container(
                              child: Text("Sign Up?",
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
        isLoginPressed
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Container()
      ],
    );
  }

  void performLogin(String cellphone, String password) async{

    setState(() {
      isLoginPressed = true;
    });
    //LIVE

    final Map<String, String> userObject = {
      "cell": cellphone,
      "password": password
    };

    try{

      String apiUrl = BASE_API_URL + "auth/login";
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
          print(jsonData);

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
      }
    } catch (e) {
      print("Login error: $e");
      // Handle errors (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed, something went wrong, please try again later.')));
    } finally {
      setState(() {
        isLoginPressed = false;
      });
    }
  }

}