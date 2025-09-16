class TourExpense {
  final int expenseID;
  final String description;
  final double estimatedCost;

  TourExpense({
    required this.expenseID,
    required this.description,
    required this.estimatedCost,
  });

  factory TourExpense.fromJson(Map<String, dynamic> json) => TourExpense(
    expenseID: json['expenseID'],
    description: json['description'],
    estimatedCost: (json['estimatedCost'] as num).toDouble(),
  );
}
