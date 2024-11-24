import React, { useState } from 'react';
import {
  VStack,
  Heading,
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
  List,
  ListItem,
  Stat,
  StatLabel,
  StatNumber,
  SimpleGrid,
} from '@chakra-ui/react';
import { useStore } from '../store';

function WorkoutTracker() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const { workouts, addWorkout } = useStore();
  const [newWorkout, setNewWorkout] = useState({ type: '', duration: '', calories: '' });

  const handleSubmit = (e) => {
    e.preventDefault();
    addWorkout({
      ...newWorkout,
      duration: parseInt(newWorkout.duration),
      calories: parseInt(newWorkout.calories),
      date: new Date(),
    });
    setNewWorkout({ type: '', duration: '', calories: '' });
    onClose();
  };

  return (
    <VStack spacing={4} align="stretch">
      <Card>
        <CardBody>
          <SimpleGrid columns={2} spacing={4}>
            <Stat>
              <StatLabel>Calorías Quemadas Hoy</StatLabel>
              <StatNumber>
                {workouts.reduce((acc, curr) => acc + curr.calories, 0)} kcal
              </StatNumber>
            </Stat>
            <Stat>
              <StatLabel>Tiempo Total de Ejercicio</StatLabel>
              <StatNumber>
                {workouts.reduce((acc, curr) => acc + curr.duration, 0)} min
              </StatNumber>
            </Stat>
          </SimpleGrid>
        </CardBody>
      </Card>

      <Button colorScheme="blue" onClick={onOpen}>
        Agregar Ejercicio
      </Button>

      <Card>
        <CardBody>
          <Heading size="md" mb={4}>Historial de Ejercicios</Heading>
          <List spacing={3}>
            {workouts.map((workout, index) => (
              <ListItem key={index} p={2} borderWidth="1px" borderRadius="lg">
                <Text fontWeight="bold">{workout.type}</Text>
                <Text fontSize="sm">
                  {workout.duration} minutos - {workout.calories} kcal
                </Text>
              </ListItem>
            ))}
          </List>
        </CardBody>
      </Card>

      <Modal isOpen={isOpen} onClose={onClose}>
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Agregar Ejercicio</ModalHeader>
          <ModalCloseButton />
          <ModalBody>
            <form onSubmit={handleSubmit}>
              <VStack spacing={4}>
                <FormControl isRequired>
                  <FormLabel>Tipo de Ejercicio</FormLabel>
                  <Input
                    value={newWorkout.type}
                    onChange={(e) => setNewWorkout({ ...newWorkout, type: e.target.value })}
                  />
                </FormControl>
                <FormControl isRequired>
                  <FormLabel>Duración (minutos)</FormLabel>
                  <Input
                    type="number"
                    value={newWorkout.duration}
                    onChange={(e) => setNewWorkout({ ...newWorkout, duration: e.target.value })}
                  />
                </FormControl>
                <FormControl isRequired>
                  <FormLabel>Calorías Quemadas</FormLabel>
                  <Input
                    type="number"
                    value={newWorkout.calories}
                    onChange={(e) => setNewWorkout({ ...newWorkout, calories: e.target.value })}
                  />
                </FormControl>
                <Button type="submit" colorScheme="blue" width="full">
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

export default WorkoutTracker;