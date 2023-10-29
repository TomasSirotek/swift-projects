import React from "react";
import renderer, { ReactTestRendererJSON } from "react-test-renderer";
import App from "./App";
import { render, fireEvent } from "@testing-library/react-native";
import { TouchableOpacity } from "react-native";
import { RootSiblingParent } from "react-native-root-siblings";
import Task from "./components/Task";
import Toast from "react-native-root-toast";
import { SafeAreaProvider } from "react-native-safe-area-context";

jest.mock("react-native-safe-area-context", () => ({
  SafeAreaProvider: ({ children }: any) => children,
  useSafeAreaInsets: () => ({
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
  }),
}));

describe("<App />", () => {
  it("renders correctly", () => {
    render(<App />);
  });

  it("should match snapshot", () => {
    const { toJSON } = render(
      <SafeAreaProvider>
        <RootSiblingParent>
          <App />
        </RootSiblingParent>
      </SafeAreaProvider>
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("should add a task when the add button is pressed", () => {
    const { getByTestId, getByPlaceholderText, queryByText } = render(
      <SafeAreaProvider>
        <RootSiblingParent>
          <App />
        </RootSiblingParent>
      </SafeAreaProvider>
    );

    // Input task text
    const taskInput = getByPlaceholderText("Write a task");
    fireEvent.changeText(taskInput, "New Task");

    // Click the "Add" button
    const addButton = getByTestId("pressCreateBtn");
    fireEvent.press(addButton);

    // Verify that the task has been added
    expect(queryByText("New Task")).toBeTruthy();
  });

  it("should not add a task when the input field is empty", () => {
    const { getByTestId, queryByText } = render(<App />);

    // Click the "Add" button without entering any task text
    const addButton = getByTestId("pressCreateBtn");
    fireEvent.press(addButton);

    // Verify that no task is added
    expect(queryByText("")).toBeNull();
  });

  it("should delete a task when it is pressed", () => {
    const { getByTestId, getByText, queryByText, getByPlaceholderText } =
      render(<App />);

    // Add a task
    const taskInput = getByPlaceholderText("Write a task");
    fireEvent.changeText(taskInput, "Task to be deleted");
    const addButton = getByTestId("pressCreateBtn");
    fireEvent.press(addButton);

    // Verify that the task is added
    expect(queryByText("Task to be deleted")).toBeTruthy();

    // Click the task to delete it
    const taskToDelete = getByText("Task to be deleted");
    fireEvent.press(taskToDelete);

    // Verify that the task has been deleted
    expect(queryByText("Task to be deleted")).toBeNull();
  });
});

it("should delete the correct task when the delete button is pressed", () => {
  const { getByTestId, getByText, queryByText, getByPlaceholderText } = render(
    <App />
  );

  // Add two tasks
  const taskInput = getByPlaceholderText("Write a task");
  fireEvent.changeText(taskInput, "Task 1");
  const addButton = getByTestId("pressCreateBtn");
  fireEvent.press(addButton);
  fireEvent.changeText(taskInput, "Task 2");
  fireEvent.press(addButton);

  // Verify that the tasks are added
  expect(queryByText("Task 1")).toBeTruthy();
  expect(queryByText("Task 2")).toBeTruthy();

  // // Click the delete button for the first task
  const deleteButton = getByText("Task 1").findByType(Task);
  fireEvent.press(deleteButton);
  // // Verify that the first task has been deleted
  // expect(queryByText("Task 1")).toBeNull();
  

// it("should not add a task when the input field contains only whitespace", () => {
//   const { getByTestId, queryByText, getByPlaceholderText } = render(<App />);

//   // Input whitespace
//   const taskInput = getByPlaceholderText("Write a task");
//   fireEvent.changeText(taskInput, "   ");

//   // Click the "Add" button
//   const addButton = getByTestId("pressCreateBtn");
//   fireEvent.press(addButton);

//   // Verify that no task is added
//   expect(queryByText("")).toBeNull();
});
