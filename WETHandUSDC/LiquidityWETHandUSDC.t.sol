//SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;

import "../src/LiquidityWETHandUSDC.sol";
import "forge-std/src/Test.sol";
import "forge-std/src/console.sol";

contract WETHandUSDCTest is Test {
    address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    IERC20 private weth = IERC20(WETH);
    IERC20 private usdc = IERC20(USDC);
    IERC20 private pair = IERC20(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852);

    WETHandUSDC private uni = new WETHandUSDC();

    function testWETHandUSDC() external {
        deal(address(usdc), address(this), 1e6 * 1e6);
        assertEq(usdc.balanceOf(address(this)), 1e6 * 1e6, "USDC balance incorrect");
        deal(address(weth), address(this), 1e6 * 1e18);
        assertEq(weth.balanceOf(address(this)), 1e6 * 1e18, "WETH balance incorrect");

        safeApprove(weth, address(uni), 1e64);
        safeApprove(usdc, address(uni), 1e64);

        uint256 liquidity = uni.addLiquidity(address(weth), address(usdc), 1 * 1e18, 3005.05 * 1e6);

        console.log("Liquidity WETH and USDC:", liquidity);

        (uint256 amountA, uint256 amountB) = uni.removeLiquidity(address(weth), address(usdc));

        console.log("WETH: ", amountA);
        console.log("USDC: ", amountB / 1e6);
    }

    function safeTransferFrom(IERC20 token, address sender, address recipient, uint256 amount) internal {
        (bool success, bytes memory returnData) =
            address(token).call(abi.encodeCall(IERC20.transferFrom, (sender, recipient, amount)));
        require(success && (returnData.length == 0 || abi.decode(returnData, (bool))), "Transfer from fail");
    }

    function safeApprove(IERC20 token, address spender, uint256 amount) internal {
        (bool success, bytes memory returnData) = address(token).call(abi.encodeCall(IERC20.approve, (spender, amount)));
        require(success && (returnData.length == 0 || abi.decode(returnData, (bool))), "Approve fail");
    }
}
