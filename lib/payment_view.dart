import 'package:flutter/material.dart';
import 'package:flutter_mpgs_sdk/directpay_card_view.dart';
import 'package:flutter_mpgs_sdk/support.dart';
import 'package:flutter_support_pack/flutter_support_pack.dart';

class PaymentView extends StatefulWidget {
  final int orderId;
  final double amount;

  PaymentView({Key? key, required this.orderId, required this.amount})
      : super(key: key);

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  static const TAG = 'PaymentView';
  String? _transactionId;
  String? _status;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500), () => _init());
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SafeArea(
        child: DirectPayCardInput(
          onCloseCardForm: onCloseCardForm,
          onCompleteResponse: onCompleteCardForm,
          onErrorCardForm: onErrorCardForm,
        ),
      ),
    );
  }

  @override
  void initState() {
    DirectPayCardInput.init('IS05053', Environment.SANDBOX);
    super.initState();
  }

  void onCloseCardForm() {
    Navigator.pop<Map<String, dynamic>>(
        context, {'status': _status, 'transaction_id': _transactionId});
  }

  void onErrorCardForm(String? error, String? description) {
    Log.e(TAG, '$error - $description', references: ['onErrorCardForm']);
  }

  void onCompleteCardForm(
      String? status, String? transactionId, String? description) {
    Log.d(TAG,
        'Status:$status - TransactionId:$transactionId - Description:$description',
        references: ["onCompleteCardForm"]);
    _status = status;
    _transactionId = transactionId;
  }

  void _init() {
    var _cardAction = CardAction.ONE_TIME_PAYMENT;
    var _cardData = CardData.pay(
      amount: widget.amount,
      currency: PayCurrency.LKR,
      reference: widget.orderId.toString(),
    );
    DirectPayCardInput.start(_cardAction, _cardData);
  }
}