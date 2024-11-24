import React from 'react';
import { ChakraProvider, Box, VStack, Tabs, TabList, TabPanels, Tab, TabPanel } from '@chakra-ui/react';
import WorkoutTracker from './components/WorkoutTracker';
import DietTracker from './components/DietTracker';
import GoalsTracker from './components/GoalsTracker';

function App() {
  return (
    <ChakraProvider>
      <Box p={4}>
        <Tabs isFitted variant="enclosed">
          <TabList mb="1em">
            <Tab>Ejercicio</Tab>
            <Tab>Dieta</Tab>
            <Tab>Objetivos</Tab>
          </TabList>
          <TabPanels>
            <TabPanel>
              <WorkoutTracker />
            </TabPanel>
            <TabPanel>
              <DietTracker />
            </TabPanel>
            <TabPanel>
              <GoalsTracker />
            </TabPanel>
          </TabPanels>
        </Tabs>
      </Box>
    </ChakraProvider>
  );
}

export default App;