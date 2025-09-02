import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/razorpay_repository.dart';
import '../viewmodel/razorpay_viewmodel.dart';

final razorpayRepositoryProvider = Provider<RazorpayRepository>((ref) {
  return RazorpayRepository();
});

final razorpayViewModelProvider =
    StateNotifierProvider.autoDispose<RazorpayViewModel, AsyncValue<String>>((
      ref,
    ) {
      final repo = ref.read(razorpayRepositoryProvider);
      return RazorpayViewModel(repo);
    });
