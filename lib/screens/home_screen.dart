import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import 'workout_screen.dart';
import 'diet_screen.dart';
import 'goals_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fitness Tracker'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.fitness_center), text: 'Ejercicio'),
              Tab(icon: Icon(Icons.restaurant_menu), text: 'Dieta'),
              Tab(icon: Icon(Icons.track_changes), text: 'Objetivos'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WorkoutScreen(),
            DietScreen(),
            GoalsScreen(),
          ],
        ),
      ),
    );
  }
}