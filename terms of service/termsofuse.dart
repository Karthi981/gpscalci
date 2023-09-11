
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mainpage.dart';
import '../policy.dart';


class Termsofuse extends StatefulWidget {
  const Termsofuse({Key? key}) : super(key: key);

  @override
  State<Termsofuse> createState() => _TermsofuseState();
}

class _TermsofuseState extends State<Termsofuse> {

  var isChecked = false;
  var ischecked1 = false;
  late SharedPreferences AgreedUser;
  late bool nonAgreedUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_if_Agreed();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(width: 100),
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                TextButton(onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PolicyDialog(
                        mdFileName: 'Privacy_policy.md',
                      );
                    },
                  );
                }, child: Row(
                  children: [
                    Text("Privacy policy"),
                    Text(" Click here to view"),
                  ],
                ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(width: 100),
                Checkbox(
                  value: ischecked1,
                  onChanged: (value) {
                    setState(() {
                      ischecked1 = value!;
                    });
                  },
                ),
                TextButton(onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PolicyDialog(
                        mdFileName: 'Terms_and_conditions.md',
                      );
                    },
                  );
                }, child: Row(
                  children: [
                    Text("Terms and Conditions"),
                    Text(" Click here to View"),
                  ],
                ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "By Using our App , You Agree to our\n",
                children: [
                  TextSpan(
                    text: "Terms & Conditions ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PolicyDialog(
                              mdFileName: 'Terms_and_conditions.md',
                            );
                          },
                        );
                      },
                  ),
                  TextSpan(text: "and "),
                  TextSpan(
                    text: "Privacy Policy! ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PolicyDialog(
                              mdFileName: 'Privacy_policy.md',
                            );
                          },
                        );
                      },
                  ),
                ],
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            width: 90,
            child: ElevatedButton(
              onPressed: () {
                // Add your logic here for what to do when the OK button is pressed.
                if (isChecked && ischecked1) {
                  // Checkbox is checked, perform the desired action.
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(

                        content: Text('You Agreed to our Privacy policy and \nTerms and Conditions of the app'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              AgreedUser.setBool("agree", true);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Mainpage()));
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
                else {
                  // Checkbox is not checked, handle this case if needed.
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Agree to our Terms and Conditions of our App'),
                        content: Text('You did not check the checkbox.\n'
                            'View our terms and condition by clicking on Terms and Conditions'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('OK'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green[500]),
              ),
            ),
          ),
        ],
      ),

    );
  }
  void check_if_Agreed() async {
    AgreedUser = await SharedPreferences.getInstance();
    nonAgreedUser = AgreedUser.getBool("agree")?? false ;
    if (nonAgreedUser == true){

     Navigator.push(context, MaterialPageRoute(builder: (context)=>Mainpage()));
    }
  }
}
