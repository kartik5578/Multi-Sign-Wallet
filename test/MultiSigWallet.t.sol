// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MultiSigWallet} from "../src/MultiSigWallet.sol";

contract MultiSigWalletTest is Test {
    MultiSigWallet public multiSigwallet;
    address[] public owners;

    function setUp() public {
        owners = [address(0x1), address(0x2), address(0x3)];
        multiSigwallet = new MultiSigWallet(owners);
    }

    function test_constructor() public{
        assertEq(multiSigwallet.owners(0), address(0x1));
        assertEq(multiSigwallet.Confirmnumber(), uint(2));
    }

    function testFail_constructor() public{
        assertEq(multiSigwallet.owners(0), address(0x5));
    }

    function test_submitTrasaction() public{
        uint256 initialBalance = address(multiSigwallet).balance;
        multiSigwallet.submitTrasaction{value: 1 ether}(address(this));

        uint256 newBalance = address(multiSigwallet).balance;

        assertEq(newBalance, initialBalance+1 ether);
    }

    function test_ConfirmTransaction() public{
        uint256 initialBalance = address(multiSigwallet).balance;

        multiSigwallet.submitTrasaction{value: 1 ether}(address(0x4));

        uint transactionId = multiSigwallet.totalTransactions() - 1;

        vm.prank(address(0x2));
        multiSigwallet.confirmtransaction(transactionId);
        vm.prank(address(0x1));
        multiSigwallet.confirmtransaction(transactionId);

        uint256 newBalance = address(multiSigwallet).balance;

        assertEq(initialBalance, newBalance);
    }

    
    
}
