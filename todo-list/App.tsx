import {
  KeyboardAvoidingView,
  Platform,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import Task from "./components/Task";
import { useState } from "react";
import { RootSiblingParent } from "react-native-root-siblings";
import Toast from "react-native-root-toast";

const behaviorSettings = Platform.OS === "ios" ? "padding" : "height";


export default function App() {
  const [tasks, setTasks] = useState<string[]>([]);
  const [text, setText] = useState<string>("");
  
  const handleAddTask = () => {
    // set tasks with new task that was passed in with the text
    if (text === "") {
      // Add a Toast on screen.
      let toast = Toast.show("Please fill the fields", {
        duration: Toast.durations.LONG,
      });

      // You can manually hide the Toast, or it will automatically disappear after a `duration` ms timeout.
      setTimeout(function hideToast() {
        Toast.hide(toast);
      }, 5000);

      return;
    }
    setTasks([...tasks, text]);
    // clear the text
    setText("");
  };

  const deleteTask = (index: number) => {
    let newTasks = [...tasks];
    newTasks.splice(index, 1);
    setTasks(newTasks);
  };

  return (
    <SafeAreaProvider>
      <RootSiblingParent>
        <View style={styles.container}>
          <View style={styles.tasksWrapper}>
            <Text style={styles.sectionTitle}>Today's Tasks</Text>
            <View style={styles.items}>
              {/* This is where the tasks will go! */}
              {tasks.map((task, index) => {
                return (
                  <TouchableOpacity
                    key={index}
                    onPress={() => deleteTask(index)}
                  >
                    <Task text={task} />
                  </TouchableOpacity>
                );
              })}
            </View>
          </View>
        </View>
       

        {/* Writing task */}
        <KeyboardAvoidingView
          behavior={behaviorSettings}
          style={styles.writeTaskWrapper}
        >
          <TextInput
            style={styles.input}
            onChangeText={(text) => setText(text)}
            placeholder={"Write a task"}
          />

          <TouchableOpacity testID="pressCreateBtn"  onPress={() => handleAddTask()}>
            <View style={styles.addWrapper}>
              <Text style={styles.addText}>+</Text>
            </View>
          </TouchableOpacity>
        </KeyboardAvoidingView>
      </RootSiblingParent>
     </SafeAreaProvider> 

  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#E8EAED",
  },
  tasksWrapper: {
    paddingTop: 80,
    paddingHorizontal: 20,
  },
  writeTaskWrapper: {
    position: "absolute",
    bottom: 60,
    width: "100%",
    flexDirection: "row",
    justifyContent: "space-around",
    alignItems: "center",
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: "bold",
  },
  items: {
    marginTop: 30,
  },
  input: {
    paddingVertical: 15,
    paddingHorizontal: 15,
    backgroundColor: "#FFF",
    borderRadius: 60,
    borderColor: "#C0C0C0",
    borderWidth: 1,
    width: 250,
  },
  addWrapper: {
    width: 60,
    height: 60,
    backgroundColor: "#FFF",
    borderRadius: 60,
    justifyContent: "center",
    alignItems: "center",
    borderColor: "#C0C0C0",
    borderWidth: 1,
  },
  addText: {
    fontSize: 25,
  },
});
