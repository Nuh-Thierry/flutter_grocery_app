class InventoryItem {
  final String id;
  final String result;
  final String category;
  final String quantity;
  final String quantityValue;

  InventoryItem({
    required this.id,
    required this.result,
    required this.category,
    required this.quantity,
    required this.quantityValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'result': result,
      'category': category,
      'quantity': quantity,
      'quantityValue': quantityValue,
    };
  }
}
