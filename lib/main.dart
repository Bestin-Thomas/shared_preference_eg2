import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel("razorpay_flutter");
  var name=TextEditingController();
  var ph=TextEditingController();
  var email=TextEditingController();
  var amt=TextEditingController();
  String _name='null';
  String _ph='null';
  String _email='null';
  int _amt=0;

  late Razorpay _razorpay;


  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

// Loading counter value on start
  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString('name') ?? 'null');
      _ph = (prefs.getString('phone') ?? 'null');
      _email = (prefs.getString('email') ?? 'nul');
      _amt = (prefs.getInt('amount') ?? 0);
    });
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Razorpay Sample App'),
        ),
        body: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter your name',
                    labelText: 'Name *',
                  ),
                  onSaved: (name) async {

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('name', name);

                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  // validator: (String? value) {
                  //   return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                  // },
        ),
                TextFormField(
                  controller: ph,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter your phone number',
                    labelText: 'Phone *',
                  ),
                  onSaved: (ph) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  // validator: (String? value) {
                  //   return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                  // },
                ),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter your email',
                    labelText: 'Email *',
                  ),
                  onSaved: (email) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  // validator: (String? value) {
                  //   return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                  // },
                ),
                TextFormField(
                  controller: ph,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter the amount',
                    labelText: 'Amount *',
                  ),
                  onSaved: (amt) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  // validator: (String? value) {
                  //   return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                  // },
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(onPressed: (){
                        final prefs =  SharedPreferences.getInstance();
                        prefs.set("email", _email);
                        openCheckout(_amt,_name,'Shirt',_ph,_email);
                        }, child: Text('CHECKOUT'))
                    ]),
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(int amt,String name,String item,String ph,String email) async {
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': amt,
      'name': '${name}',
      'description': '${item}',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '${ph}', 'email': '${email}'},
      'external': {
        'upi':['google pay'],
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }
}