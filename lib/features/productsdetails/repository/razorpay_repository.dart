import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shopping_app/core/constants/payment_constants.dart';
import '../models/payment_model.dart';

class RazorpayRepository {
  late Razorpay _razorpay;

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void openCheckout(PaymentModel model, String apiKey) {
    var options = {
      'key': apiKey,
      'amount': (model.amount * 100).toInt(),
      'currency': model.currency,
      'name': 'Your Company',
      'description': model.description,
      'order_id': model.orderId,
      'prefill': {
        'contact': PaymentConstants.paymentContactNo,
        'email': PaymentConstants.paymentEmail,
      },
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}
