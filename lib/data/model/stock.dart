class Stock {
  final String name;
  final int amount;
  final String docId;
  final int price;
  final String imageUrl;
  final String supplier;
  final String uid;
  final DateTime addedAt;
  final DateTime updatedAt;

  Stock({
    required this.name,
    required this.amount,
    required this.docId,
    required this.price,
    required this.imageUrl,
    required this.supplier,
    required this.uid,
    required this.addedAt,
    required this.updatedAt,
  });
}
