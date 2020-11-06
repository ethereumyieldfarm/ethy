pragma solidity 0.6.6;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/math/SafeMath.sol";

contract Presale is Ownable {
    using SafeMath for uint256;
    IERC20 ethy;

    uint256 constant BP = 10000;

    // sale params
    uint256 price;
    uint256 ends;
    uint256 hardcap;

    // can the presale be paused;
    bool paused;

    // stats:
    uint256 totalSold;
    uint256 totalClaimed;

    mapping(address => uint256) claimable;

    // pause contract preventing further purchase.
    // pausing however has no effect on those who
    // have already purchased.
    function pause(bool _paused) public onlyOwner {
        paused = _paused;
    }

    function calculateAmountPurchased(uint256 _value) public view returns (uint256) {
        return _value.mul(BP).div(price).mul(1e18).div(BP);
    }

    // claim your purchased tokens
    function claim() public {
        //solium-disable-next-line
        require(block.timestamp > ends, "presale has not yet ended");
        require(claimable[msg.sender] > 0, "nothing to claim");
        uint256 amount = claimable[msg.sender];
        claimable[msg.sender] = 0;
        require(ethy.transfer(msg.sender, amount), "failed to claim");
    }

    // purchase tokens
    function buy() public payable {
        //solium-disable-next-line
        require(block.timestamp < ends, "presale has ended");
        require(!paused, "presale is paused");
        require(msg.value > BP*100, "amount too small");
        uint256 amount = calculateAmountPurchased(msg.value);
        _addClaimable(msg.sender, amount);
    }

    // add claimable
    function _addClaimable(address account, uint256 amount) internal {
        require(totalSold.add(amount) <= ethy.balanceOf(address(this)), "sold out");
        claimable[account] = claimable[account].add(amount);
        totalSold = totalSold.add(amount);
    }

}