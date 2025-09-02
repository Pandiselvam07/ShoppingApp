class PaymentModel {
  final String orderId;
  final double amount;
  final String currency;
  final String description;

  PaymentModel({
    required this.orderId,
    required this.amount,
    this.currency = "INR",
    this.description = "",
  });
}
