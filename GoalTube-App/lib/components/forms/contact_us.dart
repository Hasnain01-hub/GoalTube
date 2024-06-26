// ignore_for_file: prefer_const_constructors

import 'package:edutube/authentication/firebase_auth_service.dart';
import 'package:edutube/generic_classes/customDialogs.dart';
import 'package:edutube/generic_classes/inputWithIcon.dart';
import 'package:edutube/generic_classes/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactScreenState();
  }
}

class ContactScreenState extends State<ContactScreen> {
  bool dialogShown = false;
  String? isoCode = "GB";
  String? phoneCode = "44";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController messages = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    name.dispose();
    emailId.dispose();
    messages.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseAuthService>(context).currentUser();
    var userData = Provider.of<Map<String, dynamic>?>(context, listen: false);

    if (user != null) {
      name = TextEditingController(text: user.displayName);
      emailId = TextEditingController(text: user.email);
      mobileNo = TextEditingController(text: userData!["phone"]);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          AppLocalizations.of(context)!.contact,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          tooltip: 'Back',
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    InputWithIcon(
                      // initialValue: user!.displayName,
                      btnIcon: Icons.person,
                      hintText: "Name",
                      myController: name,
                      onChange: (String value) {},
                      keyboardType: TextInputType.name,
                      validateFunc: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your name!";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    InputWithIcon(
                      // initialValue: user.email,
                      btnIcon: Icons.email_outlined,
                      hintText: "Email",
                      myController: emailId,
                      onChange: (String value) {},
                      validateFunc: (value) {
                        if (value!.isEmpty) {
                          return "Email Required";
                        } else if (!value.contains(RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                          return "Enter valid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    InputWithIcon(
                      btnIcon: Icons.message,
                      hintText: "Message",
                      myController: messages,
                      maxLines: 5,
                      onChange: (String value) {},
                      keyboardType: TextInputType.multiline,
                      validateFunc: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your message!";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    PrimaryButton(
                      btnText: 'Submit',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          FirebaseFirestore.instance
                              .collection("ContactUs")
                              .add({
                            "name": name.text,
                            "email": emailId.text,
                            "message": messages.text,
                            "date": DateTime.now(),
                          });

                          Dialog dialog = Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: customOkDialog(
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 70,
                                ),
                                title: "Success",
                                subtitle:
                                    "Your message has been recorded. \nWe will reach to you soon!  ",
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/home", (route) => false);
                                },
                              ));

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog;
                              });
                        }
                        //Send to API
                      },
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 12, bottom: 12),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.phoneAlt,
                      color: Theme.of(context).primaryColor,
                      size: 35,
                    ),
                    SizedBox(width: 20),
                    Text(
                      '9209522812',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  String no = "tel:9209522812";
                  launch(no);
                });
              },
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 12, bottom: 12),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Theme.of(context).primaryColor,
                      size: 35,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'goaltube.asthetech@gmail.com',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  String mail =
                      "mailto:goaltube.asthetech@gmail.com?subject=To Rentify&body=Hi Rentify Team,";
                  launch(mail);
                });
              },
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 70.0, top: 12, bottom: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.indigo,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.instagram,
                          color: Colors.pink,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.twitter,
                          color: Colors.blue,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.linkedin,
                          color: Color(0xFF031F4B),
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.youtube,
                          color: Colors.redAccent,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
