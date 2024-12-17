// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("USER");
    uint256 constant SEND_ETHER = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimunDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        // console.log(fundMe.i_owner());
        // console.log(msg.sender);
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWuthoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_ETHER}();

        uint256 amountFunded = fundMe.getaddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_ETHER);
    }

    function testAddsFunderToFunderArray() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_ETHER}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    // Making our tests more minimal
    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_ETHER}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        // vm.prank(USER);
        // fundMe.fund{value: SEND_ETHER}();

        //writting in this order because vm.expectRevert will not take vm stuff after them.
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleOwner() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Acc
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawWithMultiPleFunders() public funded {
        //ARRANGE SETUP
        uint160 numberOfFunders = 10; //TO GENERATE NUMBERS WITH ADDRESS WE HAVE TO USE UINT160
        uint160 staringOfFundersIndex = 1;
        for (uint160 i = staringOfFundersIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_ETHER); //SETS UP ADDRESS WITH SOME ETHER  LIKR VM.PRANK(); AND VM.DEAL();
            fundMe.fund{value: SEND_ETHER}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //ACT
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        //ASSERT
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
    }

    function testWithdrawWithMultiPleFundersCheaper() public funded {
        //ARRANGE SETUP
        uint160 numberOfFunders = 10; //TO GENERATE NUMBERS WITH ADDRESS WE HAVE TO USE UINT160
        uint160 staringOfFundersIndex = 1;
        for (uint160 i = staringOfFundersIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_ETHER); //SETS UP ADDRESS WITH SOME ETHER  LIKR VM.PRANK(); AND VM.DEAL();
            fundMe.fund{value: SEND_ETHER}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //ACT
        vm.startPrank(fundMe.getOwner());
        fundMe.CheaperWithdraw();
        vm.stopPrank();

        //ASSERT
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
    }
}
