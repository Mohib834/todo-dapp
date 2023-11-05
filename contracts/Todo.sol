// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './TodoHelper.sol';

// Can create todo with owner
// Can delete own todo
// Can update own todo

error OnlyOwnerAllowed();

contract Todo {
    using TodoHelper for TodoHelper.TodoItem[];

    // State variables
    uint private todoCount = 1;
    mapping(address => TodoHelper.TodoItem[]) private todos;
    address private i_owner;

    // Events
    event TodoCreated(address indexed by, TodoHelper.TodoItem todo);
    event TodoDeleted(address indexed by, uint todoId);
    event TodoUpdated(address indexed by, TodoHelper.TodoItem todo);

    // Structs
    struct TodoItem {
        uint id;
        string title;
        string description;
        bool isCompleted;
    }

    constructor() {
        i_owner = msg.sender;
    }

    function createTodo(string memory _title, string memory _description) public {
        TodoHelper.TodoItem memory todo = TodoHelper.TodoItem(todoCount, _title, _description, false);
        todos[msg.sender].push(todo);
        todoCount++;
        // Notify
        emit TodoCreated(msg.sender, todo);
    }

    function deleteTodo(uint _todoId) public {
        TodoHelper.TodoItem[] storage _todos = todos[msg.sender];

        _todos.removeItem(_todoId);
        emit TodoDeleted(msg.sender, _todoId);
    }

    function updateTodo(uint _todoId, TodoHelper.TodoItem memory _todo) public {
        uint foundTodoIdx = todos[msg.sender].findIndex(_todoId);
        TodoHelper.TodoItem storage todo = todos[msg.sender][foundTodoIdx];
        
        todo.title = _todo.title;
        todo.description = _todo.description;
        todo.isCompleted = _todo.isCompleted;
        todo.id = _todoId;

        emit TodoUpdated(msg.sender, todo);
    }

    // Views
    function getOwner() public view returns(address){
        return i_owner;
    }

    function getTodos() public view returns(TodoHelper.TodoItem[] memory){
        return todos[msg.sender];
    }

    function getTodoById(uint _todoId) public view returns(TodoHelper.TodoItem memory) {
        uint todoIdx = todos[msg.sender].findIndex(_todoId);
        
        return todos[msg.sender][todoIdx];
    }
}