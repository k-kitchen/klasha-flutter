import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klasha_checkout/klasha_checkout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klasha Checkout Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFE85243),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? email, amount;
  var formKey = GlobalKey<FormState>();
  CheckoutCurrency _checkoutCurrency = CheckoutCurrency.NGN;

  void _launchKlashaPay() async {
    if ((formKey.currentState?.validate() ?? false) &&
        email != null &&
        amount != null) {
      KlashaCheckout.checkout(
        context,
        email: email!,
        amount: int.parse(amount!),
        checkoutCurrency: _checkoutCurrency,
        onComplete: (KlashaCheckoutResponse klashaCheckoutResponse) {
          print(
              'checkout response transaction reference is  ${klashaCheckoutResponse.transactionReference}');
          print('checkout response status is ${klashaCheckoutResponse.status}');
          print(
              'checkout response message is ${klashaCheckoutResponse.message}');
        },
      );
    }
  }

  void _onRadioChanged(CheckoutCurrency? checkoutCurrency) {
    if (checkoutCurrency == null) return;
    setState(() => _checkoutCurrency = checkoutCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfaf1f0),
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Klasha Checkout Demo'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Text('Customer Email'),
              SizedBox(height: 5),
              TextFormField(
                onChanged: (val) => setState(() => email = val),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'john@doe.com',
                  filled: true,
                  fillColor: Color(0xFFFCE5E3),
                ),
                validator: validateEmail,
              ),
              const SizedBox(height: 25),
              Text('Currency'),
              SizedBox(height: 5),
              RadioListTile(
                value: CheckoutCurrency.NGN,
                groupValue: _checkoutCurrency,
                onChanged: _onRadioChanged,
                title: Text('NGN'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile(
                value: CheckoutCurrency.KES,
                groupValue: _checkoutCurrency,
                onChanged: _onRadioChanged,
                title: Text('KES'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile(
                value: CheckoutCurrency.GHS,
                groupValue: _checkoutCurrency,
                onChanged: _onRadioChanged,
                title: Text('GHS'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 25),
              Text('Amount'),
              SizedBox(height: 5),
              TextFormField(
                onChanged: (val) => setState(() => amount = val),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '10,000',
                  filled: true,
                  fillColor: Color(0xFFFCE5E3),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  return val?.isEmpty ?? true ? 'Amount is required' : null;
                },
              ),
              const SizedBox(height: 30),
              FlatButton(
                height: 55,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textColor: Colors.white,
                color: Color(0xFFE85243),
                onPressed: _launchKlashaPay,
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? email) {
    String source =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(source);
    if (email?.trim().isEmpty ?? true) {
      return 'Email is required';
    } else if (!regExp.hasMatch(email!)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }
}
