// Updated by Gemini on 2025-08-31. Replaced with reference file to fix issues.
part of 'checklist_bloc.dart';

@immutable
abstract class ChecklistEvent {}

class LoadChecklist extends ChecklistEvent {}

class ToggleItemChecked extends ChecklistEvent {
  final String itemId;
  final bool isChecked;

  ToggleItemChecked({required this.itemId, required this.isChecked});
}

class UpdateItemQuantity extends ChecklistEvent {
  final String itemId;
  final int quantity;

  UpdateItemQuantity({required this.itemId, required this.quantity});
}

class UpdateItemWeight extends ChecklistEvent {
  final String itemId;
  final double weight;

  UpdateItemWeight({required this.itemId, required this.weight});
}