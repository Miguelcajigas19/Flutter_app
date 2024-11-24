import { create } from 'zustand';

export const useStore = create((set) => ({
  workouts: [],
  meals: [],
  goals: {
    targetWeight: 70,
    targetCalories: 2000,
    weeklyWorkouts: 3,
    currentWorkouts: 0,
  },
  addWorkout: (workout) =>
    set((state) => ({
      workouts: [...state.workouts, workout],
      goals: {
        ...state.goals,
        currentWorkouts: state.goals.currentWorkouts + 1,
      },
    })),
  addMeal: (meal) =>
    set((state) => ({
      meals: [...state.meals, meal],
    })),
  updateGoals: (goals) =>
    set((state) => ({
      goals: { ...goals, currentWorkouts: state.goals.currentWorkouts },
    })),
}));