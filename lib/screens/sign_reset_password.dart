
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jnjversion01windows/screens/sign_in_screen.dart';
import 'package:jnjversion01windows/utilities/strings.dart';
import 'package:jnjversion01windows/utilities/univariable.dart';


class SignResetPassword extends StatefulWidget {
  const SignResetPassword({Key? key}) : super(key: key);

  @override
  State<SignResetPassword> createState() => _SignResetPasswordState();
}

class _SignResetPasswordState extends State<SignResetPassword> {
  bool isLoginPressed = false;
  TextEditingController _cellController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  bool isResetPressed = false;
  String messageFeed = "";
  Color messageColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Univariable.whiteColor,
      key: _scafoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40,),
              Container(
                child: Text(Univariable.versionDisplay, style: TextStyle(fontSize: 10, color: Colors.black26),),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Image(
                        height: 150,
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.contain
                    ),
                  ),
                ),
              ),
              resetWithCellNumber()
            ],
          ),
        ),
      ),
    );
  }

  Widget resetWithCellNumber(){
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
                        alignment: Alignment.center,
                        child: const Text("RESET WITH PHONE NUMBER", style: TextStyle(fontWeight:FontWeight.w800),),
                      ),
                      SizedBox(height: 10,),
                      Text(messageFeed, style: TextStyle(color: messageColor, fontWeight: FontWeight.w600, fontSize: 18),),
                      SizedBox(height: 10,),
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

                      SizedBox(height: 25,),
                      GestureDetector(
                        onTap: () {

                          if(_formKey.currentState!.validate()){
                            //await _signIn(_emailController.text.trim(), _passwordController.text.trim());
                            performForgotPassword(_cellController.text.trim());
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
                            "PASSWORD RESET",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2, // Makes the text look more professional
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30,),
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
                              child: Text("Sign in?",
                                style: TextStyle(
                                    color: Univariable.primaryColor
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
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

  Future<void> performForgotPassword(cell) async {
        setState(() {
          isLoginPressed = true;
        });
      try{
          String apiUrl = BASE_API_URL + "auth/reset/password";
          final Uri url = Uri.parse(apiUrl);

          var mydata = await http.get(url, headers: {"Accept": "application/json"});

          var jsonData = json.decode(mydata.body);
          if (jsonData.statusCode == 200) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reset was successful, please check sms.')));

          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reset did not go through.')));
          }
        }catch (e) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong, please try again later.')));
        } finally {
          setState(() {
            isLoginPressed = false;
          });
      }
  }
}