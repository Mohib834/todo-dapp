// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import 'hardhat/console.sol';

error TodoNotFound();

library TodoHelper {
    // Structs
    struct TodoItem {
        uint id;
        string title;
        string description;
        bool isCompleted;
    }

    function findIndex(TodoItem[] memory _todos, uint _todoId) internal pure returns(uint){
        if(_todos.length == 0) revert TodoNotFound();

        for(uint i = 0; i <= _todos.length - 1; i++){
            if(_todos[i].id == _todoId) return i;
        }

        revert TodoNotFound();
    }

    function removeItem(TodoItem[] storage _todos, uint _todoId) internal {
        uint todoIdx = findIndex(_todos, _todoId);

        if(todoIdx >= _todos.length) revert TodoNotFound();
        
        delete _todos[todoIdx];
        // moving up the todos in index
        for(uint i = todoIdx; i < _todos.length - 1; i++){
            _todos[i] = _todos[i + 1];
        }

        _todos.pop();
    }
}