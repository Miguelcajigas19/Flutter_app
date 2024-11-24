import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FitnessProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _DietSummaryCard(),
              const SizedBox(height: 16),
              _MealsList(meals: provider.meals),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddMealDialog(),
    );
  }
}

class _DietSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen Diario',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              icon: Icons.local_fire_department,
              title: 'Calorías Consumidas',
              value: '1,500 kcal',
            ),
            _buildSummaryRow(
              icon: Icons.flag,
              title: 'Objetivo Diario',
              value: '2,000 kcal',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _MealsList extends StatelessWidget {
  final List<Meal> meals;

  const _MealsList({required this.meals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comidas de Hoy',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.restaurant),
                title: Text(meal.name),
                subtitle: Text(meal.type),
                trailing: Text('${meal.calories} kcal'),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AddMealDialog extends StatefulWidget {
  const AddMealDialog({super.key});

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _calories = 0;
  String _type = 'breakfast';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Comida'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nombre de la comida'),
              onSaved: (value) => _name = value ?? '',
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Calorías'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _calories = int.tryParse(value ?? '') ?? 0,
              validator: (value) =>
                  int.tryParse(value ?? '') == null ? 'Número inválido' : null,
            ),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Tipo de comida'),
              items: const [
                DropdownMenuItem(
                  value: 'breakfast',
                  child: Text('Desayuno'),
                ),
                DropdownMenuItem(
                  value: 'lunch',
                  child: Text('Almuerzo'),
                ),
                DropdownMenuItem(
                  value: 'dinner',
                  child: Text('Cena'),
                ),
                DropdownMenuItem(
                  value: 'snack',
                  child: Text('Snack'),
                ),
              ],
              onChanged: (value) => setState(() => _type = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _submitForm,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final meal = Meal(
        name: _name,
        calories: _calories,
        type: _type,
        date: DateTime.now(),
      );
      context.read<FitnessProvider>().addMeal(meal);
      Navigator.pop(context);
    }
  }
}