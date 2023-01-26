// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

// ADAPTED FROM QuillCTF - https://quillctf.super.site/challenges/quillctf-challenges/collatz-puzzle

interface ICollatz {
  function collatzIteration(uint256 n) external pure returns (uint256);
}

contract CollatzPuzzle is ICollatz {
  function collatzIteration(uint256 n) public pure override returns (uint256) {
    if (n % 2 == 0) {
      return n / 2;
    } else {
      return 3 * n + 1;
    }
  }

  function callMe(address addr) external view returns (bool) {
    // check code size
    uint256 size;
    assembly {
      size := extcodesize(addr)
    }
    console.log("size", size);
    require(size > 0 && size <= 32, "bad code size!");

    // check results to be matching
    uint p;
    uint q;
    for (uint256 n = 1; n < 200; n++) {
      // local result
      p = n;
      for (uint256 i = 0; i < 5; i++) {
        p = collatzIteration(p);
      }
      // your result
      q = n;
      for (uint256 i = 0; i < 5; i++) {
        q = ICollatz(addr).collatzIteration{gas: 100}(q);
      }
      require(p == q, "result mismatch!");
    }

    return true;
  }
}


contract CollatzTest is Test {
    CollatzPuzzle public puzzle;
    ICollatz public solution0;
    ICollatz public solution1;

    /// @dev Setup the testing environment.
    function setUp() public {
        puzzle = new CollatzPuzzle();
        solution0 = ICollatz(HuffDeployer.deploy("Collatz0"));
        solution1 = ICollatz(HuffDeployer.deploy("Collatz1"));
    }

    function testCollatzFirstTry() public {
        puzzle.callMe(address(solution0));
    }

    function testCollatzSecondTry() public {
        puzzle.callMe(address(solution1));
    }
}

interface SimpleStore {
    function setValue(uint256) external;
    function getValue() external returns (uint256);
}
