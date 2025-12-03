
// Updated by Gemini on 2025-08-31. Replaced with reference file to fix issues.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/checklist/checklist_bloc.dart';
import 'package:mountain_hiking_app/src/data/models/equipment_model.dart';
import 'package:mountain_hiking_app/src/data/repositories/equipment_repository.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/main_scaffold.dart';

class EquipmentChecklistScreen extends StatelessWidget {
  const EquipmentChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChecklistBloc(RepositoryProvider.of<EquipmentRepository>(context))
        ..add(LoadChecklist()),
      child: const _EquipmentChecklistView(),
    );
  }
}

class _EquipmentChecklistView extends StatefulWidget {
  const _EquipmentChecklistView();

  @override
  State<_EquipmentChecklistView> createState() => _EquipmentChecklistViewState();
}

class _EquipmentChecklistViewState extends State<_EquipmentChecklistView> with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateTabController(int length) {
    if (_tabController.length != length) {
      _tabController.removeListener(_onTabChanged);
      _tabController.dispose();
      _tabController = TabController(length: length, vsync: this);
      _tabController.addListener(_onTabChanged);
    }
  }

  void _onTabChanged() {
    // You can add logic here if needed when a tab is changed
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistBloc, ChecklistState>(
      builder: (context, state) {
        if (state is ChecklistLoading || state is ChecklistInitial) {
          return const MainScaffold(
            appBar: null,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ChecklistError) {
          return MainScaffold(
            appBar: null,
            body: Center(child: Text('錯誤: ${state.message}')),
          );
        }
        if (state is ChecklistLoaded) {
          final mainCategories = state.checklistData.keys.toList();
          _updateTabController(mainCategories.length);

          return MainScaffold(
            appBar: AppBar(
              title: const Text('裝備盤點表'),
              bottom: TabBar(
                controller: _tabController,
                tabs: mainCategories.map((title) => Tab(text: title)).toList(),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: mainCategories.map((key) {
                final mainCategory = state.checklistData[key]!;
                final totalWeight = state.totalWeights[key] ?? 0.0;
                return _buildChecklistPage(mainCategory, totalWeight);
              }).toList(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChecklistPage(ChecklistMainCategory mainCategory, double totalWeight) {
    return Column(
      children: [
        _buildStatsHeader(totalWeight),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: mainCategory.subCategories.keys.length,
            itemBuilder: (context, index) {
              String subCategoryKey = mainCategory.subCategories.keys.elementAt(index);
              ChecklistSubCategory subCategory = mainCategory.subCategories[subCategoryKey]!;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: Text(subCategory.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  initiallyExpanded: true,
                  children: subCategory.items.map((item) => _buildChecklistItemTile(item)).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsHeader(double totalWeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '總重量: ${(totalWeight / 1000).toStringAsFixed(2)} kg',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: totalWeight > 15000 ? Colors.red.shade700 : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItemTile(ChecklistItem item) {
    final weightController = _getController(item.id, 'weight', item.weight.toStringAsFixed(1));
    final quantityController = _getController(item.id, 'quantity', item.quantity.toString());

    final weightFocusNode = _getFocusNode(item.id, 'weight', (hasFocus) {
      if (!hasFocus) {
        final double weight = double.tryParse(weightController.text) ?? item.weight;
        context.read<ChecklistBloc>().add(UpdateItemWeight(itemId: item.id, weight: weight));
      }
    });

    final quantityFocusNode = _getFocusNode(item.id, 'quantity', (hasFocus) {
      if (!hasFocus) {
        final int quantity = int.tryParse(quantityController.text) ?? item.quantity;
        context.read<ChecklistBloc>().add(UpdateItemQuantity(itemId: item.id, quantity: quantity));
      }
    });

    return ListTile(
      leading: Checkbox(
        value: item.isChecked,
        onChanged: (bool? value) {
          context.read<ChecklistBloc>().add(ToggleItemChecked(itemId: item.id, isChecked: value ?? false));
        },
      ),
      title: Text(item.name),
      subtitle: item.note != null || item.isSnowEssential
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.note != null)
                  Text(item.note!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                if (item.isSnowEssential)
                  const Text('❄️ 雪季必備', style: TextStyle(fontSize: 12, color: Colors.blueAccent)),
              ],
            )
          : null,
      isThreeLine: (item.note != null || item.isSnowEssential),
      trailing: SizedBox(
        width: 180,
        child: Row(
          children: [
            _buildTextFormField(
              controller: quantityController,
              focusNode: quantityFocusNode,
              label: '數量',
              isNumeric: true,
            ),
            const SizedBox(width: 8),
            _buildTextFormField(
              controller: weightController,
              focusNode: weightFocusNode,
              label: '重量(g)',
              isNumeric: false, // Allows decimal
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController _getController(String itemId, String field, String initialValue) {
    final key = '$itemId-$field';
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController(text: initialValue);
    }
    return _controllers[key]!;
  }

  FocusNode _getFocusNode(String itemId, String field, Function(bool) listener) {
    final key = '$itemId-$field';
    if (!_focusNodes.containsKey(key)) {
      _focusNodes[key] = FocusNode();
      _focusNodes[key]!.addListener(() => listener(_focusNodes[key]!.hasFocus));
    }
    return _focusNodes[key]!;
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required bool isNumeric,
  }) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: isNumeric ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: isNumeric
            ? [FilteringTextInputFormatter.digitsOnly]
            : [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
      ),
    );
  }
}
