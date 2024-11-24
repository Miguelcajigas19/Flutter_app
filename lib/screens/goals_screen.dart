import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FitnessProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _GoalsCard(goal: provider.currentGoal),
              const SizedBox(height: 16),
              _ProgressChart(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditGoalsDialog(context),
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _showEditGoalsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const EditGoalsDialog(),
    );
  }
}

class _GoalsCard extends StatelessWidget {
  final Goal goal;

  const _GoalsCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mis Objetivos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGoalRow(
              icon: Icons.monitor_weight,
              title: 'Peso Objetivo',
              value: '${goal.targetWeight} kg',
            ),
            _buildGoalRow(
              icon: Icons.local_fire_department,
              title: 'Calorías Diarias',
              value: '${goal.targetCalories} kcal',
            ),
            _buildGoalRow(
              icon: Icons.fitness_center,
              title: 'Ejercicios Semanales',
              value: '${goal.weeklyWorkouts}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalRow({
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

class _ProgressChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 200,
        child: Center(
          child: Text('Gráfico de Progreso'),
        ),
      ),
    );
  }
}

class EditGoalsDialog extends StatefulWidget {
  const EditGoalsDialog({super.key});

  @override
  State<EditGoalsDialog> createState() => _EditGoalsDialogState();
}

class _EditGoalsDialogState extends State<EditGoalsDialog> {
  final _formKey = GlobalKey<FormState>();
  double _targetWeight = 0;
  int _targetCalories = 0;
  int _weeklyWorkouts = 0;

  @override
  void initState() {
    super.initState();
    final currentGoal = context.read<FitnessProvider>().currentGoal;
    _targetWeight = currentGoal.targetWeight;
    _targetCalories = currentGoal.targetCalories;
    _weeklyWorkouts = currentGoal.weeklyWorkouts;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Objetivos'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Peso Objetivo (kg)'),
              initialValue: _targetWeight.toString(),
              keyboardType: TextInputType.number,
              onSaved: (value) => _targetWeight = double.tryParse(value ?? '') ?? 0,
              validator: (value) =>
                  double.tryParse(value ?? '') == null ? 'Número inválido' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Calorías Diarias'),
              initialValue: _targetCalories.toString(),
              keyboardType: TextInputType.number,
              onSaved: (value) => _targetCalories = int.tryParse(value ?? '') ?? 0,
              validator: (value) =>
                  int.tryParse(value ?? '') == null ? 'Número inválido' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Ejercicios por Semana'),
              initialValue: _weeklyWorkouts.toString(),
              keyboardType: TextInputType.number,
              onSaved: (value) => _weeklyWorkouts = int.tryParse(value ?? '') ?? 0,
              validator: (value) =>
                  int.tryParse(value ?? '') == null ? 'Número inválido' : null,
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
      final goal = Goal(
        targetWeight: _targetWeight,
        targetCalories: _targetCalories,
        weeklyWorkouts: _weeklyWorkouts,
      );
      context.read<FitnessProvider>().updateGoal(goal);
      Navigator.pop(context);
    }
  }
}