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
  Select,
  Card,
  CardBody,
  Text,
  List,
  ListItem,
  Stat,
  StatLabel,
  StatNumber,
} from '@chakra-ui/react';
import { useStore } from '../store';

function DietTracker() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const { meals, addMeal } = useStore();
  const [newMeal, setNewMeal] = useState({ name: '', calories: '', type: 'breakfast' });

  const handleSubmit = (e) => {
    e.preventDefault();
    addMeal({
      ...newMeal,
      calories: parseInt(newMeal.calories),
      date: new Date(),
    });
    setNewMeal({ name: '', calories: '', type: 'breakfast' });
    onClose();
  };

  return (
    <VStack spacing={4} align="stretch">
      <Card>
        <CardBody>
          <Stat>
            <StatLabel>Calorías Consumidas Hoy</StatLabel>
            <StatNumber>
              {meals.reduce((acc, curr) => acc + curr.calories, 0)} kcal
            </StatNumber>
          </Stat>
        </CardBody>
      </Card>

      <Button colorScheme="green" onClick={onOpen}>
        Agregar Comida
      </Button>

      <Card>
        <CardBody>
          <Heading size="md" mb={4}>Registro de Comidas</Heading>
          <List spacing={3}>
            {meals.map((meal, index) => (
              <ListItem key={index} p={2} borderWidth="1px" borderRadius="lg">
                <Text fontWeight="bold">{meal.name}</Text>
                <Text fontSize="sm">
                  {meal.type} - {meal.calories} kcal
                </Text>
              </ListItem>
            ))}
          </List>
        </CardBody>
      </Card>

      <Modal isOpen={isOpen} onClose={onClose}>
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Agregar Comida</ModalHeader>
          <ModalCloseButton />
          <ModalBody>
            <form onSubmit={handleSubmit}>
              <VStack spacing={4}>
                <FormControl isRequired>
                  <FormLabel>Nombre de la Comida</FormLabel>
                  <Input
                    value={newMeal.name}
                    onChange={(e) => setNewMeal({ ...newMeal, name: e.target.value })}
                  />
                </FormControl>
                <FormControl isRequired>
                  <FormLabel>Calorías</FormLabel>
                  <Input
                    type="number"
                    value={newMeal.calories}
                    onChange={(e) => setNewMeal({ ...newMeal, calories: e.target.value })}
                  />
                </FormControl>
                <FormControl isRequired>
                  <FormLabel>Tipo de Comida</FormLabel>
                  <Select
                    value={newMeal.type}
                    onChange={(e) => setNewMeal({ ...newMeal, type: e.target.value })}
                  >
                    <option value="breakfast">Desayuno</option>
                    <option value="lunch">Almuerzo</option>
                    <option value="dinner">Cena</option>
                    <option value="snack">Snack</option>
                  </Select>
                </FormControl>
                <Button type="submit" colorScheme="green" width="full">
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

export default DietTracker;