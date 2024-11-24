import React, { useState } from 'react';
import {
  VStack,
  Button,
  useDisclosure,
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalBody,
  ModalCloseButton,
  FormControl,
  FormLabel,
  Input,
  Card,
  CardBody,
  Text,
  Progress,
  Stat,
  StatLabel,
  StatNumber,
  SimpleGrid,
} from '@chakra-ui/react';
import { useStore } from '../store';

function GoalsTracker() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const { goals, updateGoals } = useStore();
  const [newGoals, setNewGoals] = useState(goals);

  const handleSubmit = (e) => {
    e.preventDefault();
    updateGoals({
      ...newGoals,
      targetWeight: parseFloat(newGoals.targetWeight),
      targetCalories: parseInt(newGoals.targetCalories),
      weeklyWorkouts: parseInt(newGoals.weeklyWorkouts),
    });
    onClose();
  };

  return (
    <VStack spacing={4} align="stretch">
      <Card>
        <CardBody>
          <SimpleGrid columns={2} spacing={4}>
            <Stat>
              <StatLabel>Peso Objetivo</StatLabel>
              <StatNumber>{goals.targetWeight} kg</StatNumber>
            </Stat>
            <Stat>
              <StatLabel>Calorías Diarias</StatLabel>
              <StatNumber>{goals.targetCalories} kcal</StatNumber>
            </Stat>
          </SimpleGrid>
        </CardBody>
      </Card>

      <Card>
        <CardBody>
          <Text mb={2}>Progreso Semanal de Ejercicios</Text>
          <Progress value={(goals.currentWorkouts / goals.weeklyWorkouts) * 100} />
          <Text mt={2}>
            {goals.currentWorkouts} de {goals.weeklyWorkouts} ejercicios completados
          </Text>
        </CardBody>
      </Card>

      <Button colorScheme="purple" onClick={onOpen}>
        Actualizar Objetivos
      </Button>

      <Modal isOpen={isOpen} onClose={onClose}>
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Actualizar Objetivos</ModalHeader>
          <ModalCloseButton />
          <ModalBody>
            <form onSubmit={handleSubmit}>
              <VStack spacing={4}>
                <FormControl isRequired>
                  <FormLabel>Peso Objetivo (kg)</FormLabel>
                  <Input
                    type="number"
                    step="0.1"
                    value={newGoals.targetWeight}
                    onChange={(e) => setNewGoals({ ...newGoals, targetWeight: e.target.value })}
                  />
                </FormControl>
                <FormControl isRequired>
                  <FormLabel>Calorías Diarias Objetivo</FormLabel>
                  <Input
                    type="number"
                    value={newGoals.targetCalories}
                    onChange={(e) => setNewGoals({ ...newGoals, targetCalories: e.target.value })}
                  />
                </FormControl>
                <FormControl isRequired>
                  <FormLabel>Ejercicios por Semana</FormLabel>
                  <Input
                    type="number"
                    value={newGoals.weeklyWorkouts}
                    onChange={(e) => setNewGoals({ ...newGoals, weeklyWorkouts: e.target.value })}
                  />
                </FormControl>
                <Button type="submit" colorScheme="purple" width="full">
                  Guardar
                </Button>
              </VStack>
            </form>
          </ModalBody>
        </ModalContent>
      </Modal>
    </VStack>
  );
}

export default GoalsTracker;