pragma solidity 0.6.6;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";


/**
 * ETHY is an Ethereum Yield farming utility and governance coin.
 * It will allow holders to access unique Ethereum farming oppurtinties,
 * and collect a percentage of the farming platform fees.
 *
 * The ETHY Token itself is just a standard ERC20, with limited supply.
 * No minting.
 */
contract ETHY is ERC20 {

    constructor() public ERC20("Ethereum Yield", "ETHY") {
        // symbol           = ETHY
        // name             = ETHEREUM YEILD
        // maximum supply   = 100000 ETHY
        _mint(msg.sender, 100000e18);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

}