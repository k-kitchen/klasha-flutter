import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/core/services/card/card_service_impl.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';

class TransactionVerificationForm extends StatefulWidget {
  final String txnRef;
  final VoidCallback onVerified;

  const TransactionVerificationForm({
    super.key,
    required this.txnRef,
    required this.onVerified,
  });

  @override
  State<TransactionVerificationForm> createState() =>
      _TransactionVerificationFormState();
}

class _TransactionVerificationFormState
    extends State<TransactionVerificationForm> with TickerProviderStateMixin {
  late final Timer _timer;
  bool _processing = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) async{
        if(_processing)return;
        _processing=true;
        final r =
        await CardServiceImpl().confirmTransaction(widget.txnRef);
        if(r.status && r.data==true){
          timer.cancel();
          widget.onVerified();
        }
        _processing=false;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print('okay');
    return SafeArea(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.black,
            valueColor: AlwaysStoppedAnimation(appColors.primary),
          ),
          const SizedBox(height: 20),
          Text('Confirming Payment')
        ],
      ),
    );
  }
}
