import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FitnessProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _WorkoutSummaryCard(),
              const SizedBox(height: 16),
              _WorkoutList(workouts: provider.workouts),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkoutDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddWorkoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddWorkoutDialog(),
    );
  }
}

class _WorkoutSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de Actividad',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              icon: Icons.whatshot,
              title: 'Calorías Quemadas',
              value: '350 kcal',
            ),
            _buildSummaryRow(
              icon: Icons.timer,
              title: 'Tiempo Total',
              value: '45 min',
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

class _WorkoutList extends StatelessWidget {
  final List<Workout> workouts;

  const _WorkoutList({required this.workouts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de Ejercicios',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text(workout.type),
                subtitle: Text('${workout.duration} min'),
                trailing: Text('${workout.caloriesBurned} kcal'),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AddWorkoutDialog extends StatefulWidget {
  const AddWorkoutDialog({super.key});

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
  final _formKey = GlobalKey<FormState>();
  String _type = '';
  int _duration = 0;
  int _calories = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Ejercicio'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Tipo de ejercicio'),
              onSaved: (value) => _type = value ?? '',
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Duración (minutos)'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _duration = int.tryParse(value ?? '') ?? 0,
              validator: (value) =>
                  int.tryParse(value ?? '') == null ? 'Número inválido' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Calorías quemadas'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _calories = int.tryParse(value ?? '') ?? 0,
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
      final workout = Workout(
        type: _type,
        duration: _duration,
        caloriesBurned: _calories,
        date: DateTime.now(),
      );
      context.read<FitnessProvider>().addWorkout(workout);
      Navigator.pop(context);
    }
  }
}