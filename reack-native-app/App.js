import React, { useState, useRef, useEffect } from 'react';
import { StyleSheet, View, ScrollView, Modal, Animated, Pressable, Dimensions } from 'react-native';
import { Provider as PaperProvider, Button, Text, TextInput, MD3LightTheme, RadioButton } from 'react-native-paper';
import BackIcon from './src/assets/icons/arrow.svg';
import CheckIcon from './src/assets/icons/check.svg';
import SettingIcon from './src/assets/icons/settings.svg';
import UpIcon from './src/assets/icons/arrow_up.svg';
import DawnIcon from './src/assets/icons/arrow_down.svg';
import FlagIcon from './src/assets/icons/flag.svg';

const theme = {
  ...MD3LightTheme,
  colors: {
    ...MD3LightTheme.colors,
    primary: '#6b5b95', 
    secondary: '#8e84a4',
  },
};

const GameScreen = () => {
  const [isModalVisible, setModalVisible] = useState(false);

  const [isModalVisiblepo, setModalVisiblepo] = useState(false);

  const openModalpo = () => setModalVisiblepo(true);
  const closeModalpo = () => setModalVisiblepo(false);

  const [isModalVisiblepp, setModalVisiblepp] = useState(false);

  const openModalpp = () => setModalVisiblepp(true);
  const closeModalpp = () => setModalVisiblepp(false);

  const [isModalVisiblew, setModalVisiblew] = useState(false);

  const openModalw = () => setModalVisiblew(true);
  const closeModalw = () => setModalVisiblew(false); 

  const [isModalVisiblepr, setModalVisiblepr] = useState(false);

  const openModalpr = () => setModalVisiblepr(true);
  const closeModalpr = () => setModalVisiblepr(false);

  const slideAnim = useRef(new Animated.Value(-Dimensions.screenWidth)).current;

  const [numberRange, setNumberRange] = useState([1, 100]);

  const generateRandomNumber = (min, max) => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  const [targetNumber, setTargetNumber] = useState(generateRandomNumber(1, 100));
  const [remainingAttempts, setRemainingAttempts] = useState(6);
  const [rangeStart, setRangeStart] = useState('');
  const [rangeEnd, setRangeEnd] = useState('');
  const [enteredNumber, setEnteredNumber] = useState("");
  const [difficulty, setDifficulty] = useState('easy');
  const [comparisonStatus, setComparisonStatus] = useState(null);


  useEffect(() => {
    if (!rangeStart || !rangeEnd) {
      setRangeStart('0');
      setRangeEnd('100');
      setComparisonStatus(null);
    }

    const newRange = [parseInt(rangeStart), parseInt(rangeEnd)];
    setNumberRange(newRange);
    setTargetNumber(generateRandomNumber(newRange[0], newRange[1]));
    setRemainingAttempts(difficulty === 'easy' ? 10 : difficulty === 'medium' ? 6 : 2);
  }, []);

  const handleReplay = () => {
    const newRangeStart = rangeStart ? parseInt(rangeStart) : 0;
    const newRangeEnd = rangeEnd ? parseInt(rangeEnd) : 100;
    setTargetNumber(generateRandomNumber(newRangeStart, newRangeEnd));
    setRemainingAttempts(difficulty === 'easy' ? 10 : difficulty === 'medium' ? 6 : 2);
    setEnteredNumber("");
    closeModalw();
  };

  const handleSaveSettings = () => {
    const newRange = [parseInt(rangeStart), parseInt(rangeEnd)];
    setNumberRange(newRange);
    setTargetNumber(generateRandomNumber(newRange[0], newRange[1]));
    setRemainingAttempts(difficulty === 'easy' ? 10 : difficulty === 'medium' ? 6 : 2);
    closeModal();
  };

  const handleNumberPress = (value) => {
    setEnteredNumber(prev => prev + value); 
  };

  const handleBackPress = () => {
    setEnteredNumber(prev => prev.slice(0, -1));  
  };

  const handleCheckPress = () => {
    setComparisonStatus(null);
    if (remainingAttempts > 0) {
      if (parseInt(enteredNumber) === targetNumber) {
        openModalw();  
      } else {
        if (parseInt(enteredNumber) > targetNumber) {
          setComparisonStatus('higher');  
        } else {
          setComparisonStatus('lower');  
        }
        setRemainingAttempts(remainingAttempts - 1); 
        if (remainingAttempts === 1) {
          openModalpp(); 
        }
      }
    } else {
      openModalpp();  
    }
  };

  useEffect(() => {
    const newRange = [parseInt(rangeStart), parseInt(rangeEnd)];
    setNumberRange(newRange);
    setTargetNumber(generateRandomNumber(newRange[0], newRange[1]));
    setRemainingAttempts(difficulty === 'easy' ? 10 : difficulty === 'medium' ? 6 : 2);
  }, [difficulty]);

  const openModal = () => {
    setModalVisible(true);
    Animated.timing(slideAnim, {
      toValue: 0,
      duration: 300,
      useNativeDriver: false,
    }).start();
  };

  const closeModal = () => {
    Animated.timing(slideAnim, {
      toValue: -Dimensions.screenWidth,
      duration: 300,
      useNativeDriver: false,
    }).start(() => {
      setModalVisible(false);
    });
  };

  return (
    <PaperProvider theme={theme}>
      <Modal
        visible={isModalVisible}
        transparent={true}
        animationType="none"
        onRequestClose={closeModal}
      >
        <View style={styles.modalContainer}>
          <View style={styles.modalContent}>
            <View>
              <Text style={styles.modalTitle}>Ustawienia</Text>
              <View style={styles.modaldiv}>
                <Text style={styles.sectionTitle}>Wybór zakresu</Text>
                <Text style={styles.inscriptionTitle}>Maksymalna liczba to 100000000</Text>
              </View>
              {/* Formularz zakresu */}
              <View style={styles.modaldiv2}>
                <Text style={styles.modaltext}>Od</Text>
                <TextInput
                  mode="outlined"
                  style={styles.input}
                  value={rangeStart} 
                  onChangeText={setRangeStart} 
                  keyboardType="numeric"
                />
              </View>
              <View style={styles.modaldiv2}>
                <Text style={styles.modaltext}>Do</Text>
                <TextInput
                  mode="outlined"
                  style={styles.input}
                  value={rangeEnd} 
                  onChangeText={setRangeEnd}
                  keyboardType="numeric"
                />
              </View>

              {/* Poziom trudności */}
              <View style={styles.modaldiv}>
                <Text style={styles.sectionTitle}>Poziom trudności</Text>
              </View>
              <RadioButton.Group onValueChange={value => setDifficulty(value)} value={difficulty}>
                <View style={styles.modaldiv2}>
                  <RadioButton.Item value="easy" />
                  <View style={{ margin: 15 }}>
                    <Text style={styles.modaltext2}>Łatwy</Text>
                    <Text style={styles.modaltext3}>Liczba prób: 10</Text>
                  </View>
                </View>
                <View style={styles.modaldiv2}>
                  <RadioButton.Item value="medium" />
                  <View style={{ margin: 15 }}>
                    <Text style={styles.modaltext2}>Średni</Text>
                    <Text style={styles.modaltext3}>Liczba prób: 6</Text>
                  </View>
                </View>
                <View style={styles.modaldiv2}>
                  <RadioButton.Item value="hard" />
                  <View style={{ margin: 15 }}>
                    <Text style={styles.modaltext2}>Trudny</Text>
                    <Text style={styles.modaltext3}>Liczba prób: 2</Text>
                  </View>
                </View>
              </RadioButton.Group>
            </View>
            <Button
              mode="contained"
              onPress={() => {
                handleSaveSettings();
              }}
              style={styles.closeButton}
              labelStyle={styles.closeButtontext}
            >
              Zapisz ustawienia
            </Button>
          </View>
        </View>
      </Modal>

      <Modal
        visible={isModalVisiblepo}
        transparent={true}
        animationType="fade"
        onRequestClose={closeModalpo}
      >
        <View style={styles.modalContainerp}>
          <View style={styles.modalContentp}>
            <Text style={styles.modalTitle}>Poddać się?</Text>
            <Text style={styles.modaltext4}>Czy na pewno chcesz się poddać?</Text>
            <Text style={styles.modaltext4}>Tej czynności nie da się cofnąć.</Text>
            <View style={styles.modalButtons}>
              <Button mode="text" onPress={() => { closeModalpo(); openModalpr(); }} style={styles.modalButton}>
                Tak
              </Button>
              <Button mode="text" onPress={closeModalpo} style={styles.modalButton}>
                Nie
              </Button>
            </View>
          </View>
        </View>
      </Modal>

      <Modal
        visible={isModalVisiblepp}
        transparent={true}
        animationType="fade"
        onRequestClose={closeModalpp}
      >
        <View style={styles.modalContainerp}>
          <View style={styles.modalContentp}>
            {/* Nagłówek */}
            <Text style={styles.modalTitle}>Przegrałeś</Text>
            
            {/* Tekst */}
            <Text style={styles.modaltext4}>Ilość prób się skończyła</Text>
            <Text style={styles.modaltext4}>Oczekiwana liczba to: {targetNumber}</Text>
            
            {/* Przycisk "Zagraj ponownie" */}
            <View style={styles.modalButtons}>
              <Button 
                mode="text" 
                onPress={() => {closeModalpp(); handleReplay();}} 
                style={styles.modalButton} 
              >
                Zagraj ponownie
              </Button>
            </View>
          </View>
        </View>
      </Modal>

      <Modal
        visible={isModalVisiblew}
        transparent={true}
        animationType="fade"
        onRequestClose={closeModalw}
      >
        <View style={styles.modalContainerp}>
          <View style={styles.modalContentp}>
            {/* Nagłówek */}
            <Text style={styles.modalTitle}>Wygrałeś!</Text>
            {/* Tekst gratulacji */}
            <Text style={styles.modaltext4}>Brawo udało ci się zgadnąć liczbę!</Text>
            
            {/* Przycisk Zagraj ponownie */}
            <View style={styles.modalButtons}>
              <Button mode="text" style={styles.modalButton}  onPress={() => { closeModalw(); handleReplay(); }}>
                Zagraj ponownie
              </Button>
            </View>
          </View>
        </View>
      </Modal>

      <Modal
        visible={isModalVisiblepr}
        transparent={true}
        animationType="fade"
        onRequestClose={closeModalpr}
      >
        <View style={styles.modalContainerp}>
          <View style={styles.modalContentp}>
            {/* Nagłówek */}
            <Text style={styles.modalTitle}>Przegrałeś</Text>
            {/* Tekst informacji */}
            <Text style={styles.modaltext4}>Poddałeś się</Text>
            <Text style={styles.modaltext4}>Oczekiwana liczba to: {targetNumber}</Text>
            
            {/* Przycisk Zagraj ponownie */}
            <View style={styles.modalButtons}>
              <Button mode="text" style={styles.modalButton}  onPress={() => { closeModalpr(); handleReplay(); }}>
                Zagraj ponownie
              </Button>
            </View>
          </View>
        </View>
      </Modal>

      <ScrollView contentContainerStyle={styles.container}>
        {/* Nagłówek z przyciskami */}
        <View style={styles.header}>
          <Button
              mode="contained"
              style={[styles.setButton]}
              onPress={openModal}
              icon={() => <SettingIcon width={25} height={25} fill="#FFFFFF" />}
            />
          <Text variant="titleMedium" style={styles.h2text}>Zgadnij liczbę</Text>
          <Button
            mode="contained"
            style={[styles.setButton]}
            onPress={openModalpo}
            icon={() => <FlagIcon width={25} height={25} fill="#FFFFFF" />} 
          />
        </View>

        {/* Wyświetlacz liczby */}
        <View style={styles.arrows}>
  <UpIcon
    style={styles.iconar}
    fill={comparisonStatus === 'lower' ? '#625B71' : '#EADDFF' }
    width={60}
    height={60}
  />
  <Text variant="displayMedium" style={styles.h1text}>{enteredNumber || "0"}</Text>
  <DawnIcon
    style={styles.iconar}
    fill={comparisonStatus === 'higher' ? '#625B71' : '#EADDFF' }
    width={60}
    height={60}
  />
</View>

        {/* Liczba prób */}
        <View style={styles.attemptsContainer}>
          <Text variant="titleMedium" style={styles.htext}>Liczba pozostałych prób: {remainingAttempts}</Text>
        </View>

        {/* Klawiatura numeryczna */}
        <View style={styles.numPad}>
          {['1', '2', '3', '4', '5', '6', '7', '8', '9'].map((value, index) => (
            <Button
              key={index}
              mode="contained"
              style={styles.numButton}
              labelStyle={styles.numButtonText}
              onPress={() => handleNumberPress(value)}
            >
              {value}
            </Button>
          ))}

          {/* Przycisk cofnięcia */}
          <Button
            mode="outlined"
            style={[styles.numButton, styles.specialButton]}
            onPress={handleBackPress}
            icon={() => <BackIcon width={50} height={50} fill="#625B71" />}
          />

          <Button
            mode="contained"
            style={styles.numButton}
            labelStyle={styles.numButtonText}
            onPress={() => handleNumberPress(0)}
          >
            0
          </Button>

          {/* Przycisk zatwierdzenia */}
          <Button
            mode="outlined"
            style={[styles.numButton, styles.specialButton]}
            onPress={handleCheckPress}
            icon={() => <CheckIcon width={50} height={50} fill="#625B71" />}
          />
        </View>
      </ScrollView>
    </PaperProvider>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
  header: {
    marginTop: 40,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width: '100%',
    height: 45,
    marginBottom: 15,
  },
  arrows: {
    width: '90%',
    alignItems: 'center',
    justifyContent: 'center',
    height: '22%',
    marginBottom: 16,
    backgroundColor: '#FFFFFFF',
    borderColor: '#CAC4D0',
    borderWidth: 1.5,
    borderRadius: 10,
  },
  attemptsContainer: {
    marginBottom: 16,
  },
  numPad: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-evenly',
    width: '100%',
  },
  numButton: {
    margin: 15,
    width: 90,
    height: 90,
    borderRadius: 45,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  specialButton: {
    backgroundColor: '#ffffff', 
    borderColor: '#6b5b95', 
    borderWidth: 1.5,
    paddingLeft: 15,
  },
  numButtonText: {
    fontFamily: 'Roboto',
    fontWeight: 'normal',
    fontSize: 50,
    lineHeight: 68, 
    color: '#ffffff', 
    textAlign: 'center', 
  },
  setButton: {
    margin: 20,
    width: 40,
    height: 40,
    borderRadius: 30,
    justifyContent: 'center',
    alignItems: 'center',
  },
  pressedButton: {
    backgroundColor: '#625B71',
  },
  htext: {
    fontFamily: 'Roboto',
    fontWeight: 'regular',
    fontSize: 20,
    color: '#4F378A'
  },
  h2text: {
    fontFamily: 'Roboto',
    fontWeight: 'regular',
    fontSize: 25,
    color: '#4F378A'
  },
  h1text: {
    fontFamily: 'Roboto',
    fontWeight: 'regular',
    fontSize: 50,
    color: '#625B71'
  },
  iconar: {
    padding: 0,
    marginTop: 5,
    marginBottom: 5,
  },
  modalContainer: {
    flex: 1, 
    backgroundColor: 'rgba(0, 0, 0, 0.5)', 
    justifyContent: 'flex-start', 
    alignItems: 'flex-start', 
  },
  modalContainer: {
    flex: 1, 
    backgroundColor: 'rgba(0, 0, 0, 0.5)', 
    justifyContent: 'flex-start', 
    alignItems: 'flex-start', 
  },
  modalContent: {
    backgroundColor: '#FFF',
    width: '90%', 
    height: '100%',
    padding: 20,
    borderTopRightRadius: 20,
    borderBottomRightRadius: 20,
    justifyContent: 'space-between', 
  },
  modalTitle: {
    fontFamily: 'Roboto',
    fontWeight: 'regular',
    fontSize: 30,
    margin: 20,
    color: '#000000',
    textAlign: 'center',
  },
  sectionTitle: {
    fontFamily: 'Roboto',
    fontWeight: 'bold',
    fontSize: 18,
    color: '#4F378A',
    textAlign: 'center',
  },
  inscriptionTitle: {
    fontFamily: 'Roboto',
    fontWeight: 'regular',
    textAlign: 'center',
    fontSize: 14,
    color: '#4F378A',
  },
  modaltext: {
    fontFamily: 'Roboto',
    fontWeight: 'bold',
    fontSize: 16,
    margin: 20,
    color: '#79747E',
  },
  modaltext2: {
    fontFamily: 'Roboto',
    fontWeight: 'bold',
    fontSize: 18,
    color: '#79747E',
  },
  modaltext3: {
    fontFamily: 'Roboto',
    fontWeight: 'regular',
    fontSize: 16,
    color: '#79747E',
  },
  modaldiv: {
    justifyContent: 'center', 
    alignItems: 'center', 
    padding: 10,
    borderColor: '#EADDFF',
    borderWidth: 1.5,
    borderRadius: 10,
    margin: 5,
  },
  modaldiv2: {
    justifyContent: 'flex-start', 
    alignItems: 'center',
    flexDirection: 'row',
    margin: 5,
    hight: 20,
  },
  input: {
    margin: 10,
    width: '70%',
    maxHeight: 45,
    borderRadius: 20,
  },
  closeButton: {
    margin: 20,
    marginBottom: 60,
    height: 50,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#E8DEF8',
  },
  closeButtontext: {
    fontFamily: 'Roboto',
    fontWeight: 'bold',
    fontSize: 18,
    color: '#4F378A',
    textAlign: 'center',
  },
  modalContainerp: {
    flex: 1, 
    backgroundColor: 'rgba(0, 0, 0, 0.5)', 
    justifyContent: 'center', 
    alignItems: 'center', 
  },
  modalContentp: {
    backgroundColor: '#ECE6F0',
    width: '80%', 
    height: '35%',
    padding: 20,
    borderRadius: 20,
    justifyContent: 'space-between', 
    alignItems: 'flex-start',
  },
  modalButtons: {
    flexDirection: 'row',  
    justifyContent: 'flex-start',  
    width: '100%',  
    paddingLeft: 100,
    paddingRight: 10,
  },
  modalButton: {
    flex: 1,
    marginHorizontal: 10,
  },
  modaltext4: {
    fontFamily: 'Roboto',
    fontWeight: 'bold',
    fontSize: 16,
    margin: 15,
    color: '#79747E',
  },
});

export default GameScreen;