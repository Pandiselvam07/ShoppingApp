import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/payment_model.dart';
import '../repository/razorpay_repository.dart';

class RazorpayViewModel extends StateNotifier<AsyncValue<String>> {
  final RazorpayRepository _repo;

  RazorpayViewModel(this._repo) : super(const AsyncValue.data("Idle")) {
    _repo.init(
      onSuccess: _handlePaymentSuccess,
      onError: _handlePaymentError,
      onExternalWallet: _handleExternalWallet,
    );
  }

  void startPayment(PaymentModel model, String apiKey) {
    state = const AsyncValue.loading();
    try {
      _repo.openCheckout(model, apiKey);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    state = AsyncValue.data("SUCCESS: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    state = AsyncValue.error(
      "ERROR: ${response.code} - ${response.message}",
      StackTrace.current,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    state = AsyncValue.data("EXTERNAL WALLET: ${response.walletName}");
  }

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }
}
