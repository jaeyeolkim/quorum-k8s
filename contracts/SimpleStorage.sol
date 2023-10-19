// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SimpleStorage {
  uint public storedData;

  constructor(uint initVal) {
    storedData = initVal;
  }

  function set(uint x) public {
    storedData = x;
  }

  function get() view public returns (uint retVal) {
    return storedData;
  }
}