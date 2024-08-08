import 'package:json_annotation/json_annotation.dart';

part 'movie_budget.g.dart';

@JsonSerializable()
class Budget {
  final int? total;
  final List<Items>? items;

  Budget({required this.total, required this.items});

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}

@JsonSerializable()
class Items {
  final String? type;
  final int? amount;
  final String? currencyCode;

  Items({required this.type, required this.amount, required this.currencyCode});

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);
}
