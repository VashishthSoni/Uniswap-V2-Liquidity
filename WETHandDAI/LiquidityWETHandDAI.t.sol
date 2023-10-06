//SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;

import "../src/LiquidityWETHandDAI.sol";
import "forge-std/src/Test.sol";
import "forge-std/src/console.sol";

contract WETHandDAITest is Test {
    address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    IERC20 constant weth = IERC20(WETH);
    IERC20 constant dai = IERC20(DAI);
    IERC20 constant pair = IERC20(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852);

    WETHandDAI private uni = new WETHandDAI();

    function testWETHandDAI() external {
        deal(address(weth), address(this), 1e6 * 1e18);
        assertEq(weth.balanceOf(address(this)), 1e6 * 1e18, "WEth balance incorrect");
        
        deal(address(dai), address(this), 1e6 * 1e18);
        assertEq(dai.balanceOf(address(this)), 1e6 * 1e18, "DAI balance incorrect");

        safeApprove(weth, address(uni), 1e64);
        safeApprove(dai, address(uni), 1e64);

        uint256 liquidity = uni.addLiquidity(address(weth), address(dai), 1 * 1e18, 3000.05 * 1e18);
        console.log("Liquidity:", liquidity);

        (uint amountA, uint amountB) = uni.removeLiquidity(address(weth), address(dai));    
        console.log("WETH :", amountA/1e17);
        console.log("DAI:", amountB/1e18);
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
