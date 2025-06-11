class SupplyDataModel {
  final int amount;
  final String? id;
  final String name;
  final String? processedBy;
  final String unit;

  SupplyDataModel(
      {required this.amount,
       this.id,
      required this.name,
       this.processedBy,
      required this.unit});
}

class SupplyHistoryDataModel {
  final int? amount;
  final DateTime inDate;
  final String processedBy;

  SupplyHistoryDataModel(
      {required this.amount, required this.inDate, required this.processedBy});
}
