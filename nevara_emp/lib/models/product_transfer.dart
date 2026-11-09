/// Model representing a product transfer between stores.
class ProductTransfer {
  final String id;
  final String originStore;
  final String destinationStore;
  final String product;
  final String quantity;
  final String status;
  final String date;
  final String responsible;

  const ProductTransfer({
    required this.id,
    required this.originStore,
    required this.destinationStore,
    required this.product,
    required this.quantity,
    required this.status,
    required this.date,
    required this.responsible,
  });
}
