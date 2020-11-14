pragma solidity 0.6.6;

import "./DeflationaryERC20.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

/**
 * ETHY is an Ethereum Yield farming utility and governance coin.
 * It will allow holders to access unique Ethereum farming opportunities,
 * and collect a percentage of the farming platform fees.
 *
 * The ETHY Token itself is just a standard ERC20, with:
 * No minting.
 * Public burning.
 * Transfer fee applied.
 */
contract ETHY is DeflationaryERC20 {

    constructor() public DeflationaryERC20("Ethereum Yield", "ETHY") {
        // symbol           = ETHY
        // name             = ETHEREUM YEILD
        // maximum supply   = 500000 ETHY
        _mint(msg.sender, 500000e18);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}