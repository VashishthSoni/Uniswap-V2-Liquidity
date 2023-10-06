//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/src/Test.sol";
import "forge-std/src/console.sol";
import "../src/LiquidityWETHandUSDT.sol";

contract liquidityWETHandDAITest is Test {
    address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    IERC20 constant weth = IERC20(WETH);
    IERC20 constant usdt = IERC20(USDT);
    IERC20 constant pair = IERC20(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852);

    LiquidityWETHandUSDT private uni = new LiquidityWETHandUSDT();

    function testWETHandUSDT() external {
        deal(address(usdt), address(this), 1e6 * 1e6);
        assertEq(usdt.balanceOf(address(this)), 1e6 * 1e6, "USDT balaance incorrect");
        deal(address(weth), address(this), 1e6 * 1e18);
        assertEq(weth.balanceOf(address(this)), 1e6 * 1e18, "WETH balaance incorrect");

        safeApprove(weth, address(uni), 1e64);
        safeApprove(usdt, address(uni), 1e64);

        uint256 liquidity = uni.addLiquidity(address(weth), address(usdt), 1 * 1e18, 3000.05 * 1e6);
        console.log("Liquidity :", liquidity);

        (uint256 a, uint256 b) = uni.removeLiquidity(address(weth), address(usdt));

        console.log("WETH: ", a / 1e17); //1WETH = 18 Decimals 
        console.log("USDT: ", b / 1e6);  //1USDT = 6 Decimals
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
