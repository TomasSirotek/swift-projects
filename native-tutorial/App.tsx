import { StatusBar } from "expo-status-bar";
import { StyleSheet, View, Image } from "react-native";
import Button from "./components/Button";
const PlaceholderImage = require("./assets/images/background-image.png");
import * as ImagePicker from "expo-image-picker";
import {useState} from "react";
import ImageViewer from "./components/ImageViewer";

export default function App() {
  const [selectedImage,setSelectedImage] = useState<string>('')


  const pickImage = async () => {
    let result = await ImagePicker.launchImageLibraryAsync({
      allowsEditing: true,
      quality: 1,
    });

    !result.canceled
      ? setSelectedImage(result.assets[0].uri)
      : alert("You have cancelled the action");
  };

  return (
    <View style={styles.container}>
      <View style={styles.imageContainer}>
        <ImageViewer placeholderImageSource={PlaceholderImage} selectedImage={selectedImage} style={styles.image} />
      </View>
      <View style={styles.footerContainer}>
        <Button theme="primary" label="Choose a photo" onPress={pickImage} />
        <Button label="Use this photo" />
      </View>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#111827",
    alignItems: "center",
  },
  imageContainer: {
    flex: 1,
    paddingTop: 58,
  },
  image: {
    width: 320,
    height: 440,
    borderRadius: 18,
  },
  footerContainer: {
    flex: 1 / 3,
    alignItems: "center",
  },
});
