import { ethers } from "hardhat";
import { expect } from "chai";
import { Todo } from "../typechain-types";

describe("Todo", () => {
  let owner: string;
  let todo: Todo;

  beforeEach(async () => {
    const Todo = await ethers.getContractFactory("Todo");
    todo = await Todo.deploy();

    if (todo.deploymentTransaction) {
      owner = todo.deploymentTransaction()!.from;
    }
  });

  describe("Constructor", () => {
    it("Should set owner address to the deployer address", async () => {
      const _owner = await todo.getOwner();

      expect(_owner).to.equal(owner);
    });
  });

  describe("Todo Creation", () => {
    it("Should let todo creation", async () => {
      const title = "My Todo";
      const description = "Hello world!";

      await todo.createTodo(title, description);
      const todos = await todo.getTodos();

      expect(todos[0].title).to.equal(title);
      expect(todos[0].description).to.equal(description);
      expect(todos[0].isCompleted).to.equal(false);
      expect(todos.length).to.equal(1);
    });
  });

  describe("Todo Delete", () => {
    it("Should throw error when deleting todo with no todos", async () => {
      const deleteTodo = todo.deleteTodo(123);
      expect(deleteTodo).to.be.revertedWithCustomError(todo, "TodoNotFound");
    });

    it("Should throw error on deleting todo with invalid id", async () => {
      await todo.createTodo("My Todo", "Hello world!");
      const deleteTodo = todo.deleteTodo(123);

      expect(deleteTodo).to.be.revertedWithCustomError(todo, "TodoNotFound");
    });

    it("Should allow deleting of a todo", async () => {
      await todo.createTodo("My Todo", "Hello world!");

      let todos = await todo.getTodos();
      expect(todos.length).to.be.equal(1);

      await todo.deleteTodo(todos[0].id);

      todos = await todo.getTodos();
      expect(todos.length).to.be.equal(0);
    });
  });

  describe("Todo Update", () => {
    it("Should allow update to existing todo", async () => {
      await todo.createTodo("My Todo", "Hello world!");
      let todos = await todo.getTodos();

      await todo.updateTodo(todos[0].id, {
        id: todos[0].id,
        title: "My Updated Todo",
        description: todos[0].description,
        isCompleted: true,
      });

      todos = await todo.getTodos();

      expect(todos[0].title).to.be.equal("My Updated Todo");
      expect(todos[0].isCompleted).to.be.equal(true);
    });
  });

  describe("Views", () => {
    it("Should return contract deployer address", async () => {
      const _owner = await todo.getOwner();

      expect(_owner).to.be.equal(owner);
    });

    it("Should return all todos", async () => {
      let todos = await todo.getTodos();

      expect(todos.length).to.be.equal(0);

      await todo.createTodo("My Todo", "Hello world!");
      todos = await todo.getTodos();

      expect(todos.length).to.be.equal(1);
    });

    it("Should return todo by id", async () => {
      await todo.createTodo("My Todo", "Hello world!");
      const todos = await todo.getTodos();

      const _todo = await todo.getTodoById(todos[0].id);

      expect(_todo.id).to.be.equal(todos[0].id);
      expect(_todo.title).to.be.equal(todos[0].title);
    });
  });
});
