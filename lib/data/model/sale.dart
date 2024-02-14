class Sale {
  final String name;
  late int currentAmount;
  late int outingAmount;
  final String docId;
  final int price;
  final String supplier;

  Sale({
    required this.name,
    required this.currentAmount,
    this.outingAmount = 0,
    required this.docId,
    required this.price,
    required this.supplier,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'currentAmount': currentAmount,
      'amount': outingAmount,
      'docId': docId,
      'price': price,
      'supplier': supplier,
    };
  }
}
