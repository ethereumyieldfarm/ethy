pragma solidity 0.6.6;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/math/SafeMath.sol";

contract ETHYPresale is Ownable {
    using SafeMath for uint256;
    IERC20 ethy;

    // BP
    uint256 constant BP = 10000;

    // sale params
    bool    public started;
    uint256 public price;
    uint256 public ends;
    uint256 public hardcap;
    bool    public paused;
    uint256 public minimum;

    // stats:
    uint256 public totalOwed;
    uint256 public weiRaised;

    mapping(address => uint256) public claimable;

    constructor (address addr) public { ethy = IERC20(addr); }

    // pause contract preventing further purchase.
    // pausing however has no effect on those who
    // have already purchased.
    function pause(bool _paused)            public onlyOwner { paused = _paused;}
    function setPrice(uint256 _price)       public onlyOwner { price = _price; }
    function setHardCap(uint256 _hardcap)   public onlyOwner { hardcap = _hardcap; }
    function setMinimum(uint256 _minimum)   public onlyOwner { minimum = _minimum; }
    function unlock()                       public onlyOwner { ends = 0; }

    function withdrawETH(uint256 amount) public onlyOwner {
        msg.sender.transfer(amount);
    }

    function withdrawUnsold(uint256 amount) public onlyOwner {
        require(amount <= ethy.balanceOf(address(this)).sub(totalOwed), "insufficient balance");
        ethy.transfer(msg.sender, amount);
    }

    // start the presale
    function startPresale(uint256 _ends) public onlyOwner {
        require(!started, "already started!");
        require(price > 0, "set price first!");
        require(hardcap > 0, "set hardcap first!");
        require(minimum > 0, "set minimum first!");

        started = true;
        paused = false;
        ends = _ends;
    }

    // the amount of ethy purchased
    function calculateAmountPurchased(uint256 _value) public view returns (uint256) {
        return _value.mul(BP).div(price).mul(1e18).div(BP);
    }

    // claim your purchased tokens
    function claim() public {
        //solium-disable-next-line
        require(block.timestamp > ends, "presale has not yet ended");
        require(claimable[msg.sender] > 0, "nothing to claim");

        uint256 amount = claimable[msg.sender];

        // update user and stats
        claimable[msg.sender] = 0;
        totalOwed = totalOwed.sub(amount);

        // send owed tokens
        require(ethy.transfer(msg.sender, amount), "failed to claim");
    }

    // purchase tokens
    function buy() public payable {
        //solium-disable-next-line
        require(block.timestamp < ends, "presale has ended");
        require(!paused, "presale is paused");
        require(msg.value > minimum, "amount too small");
        require(weiRaised.add(msg.value) < hardcap, "hardcap exceeded");

        uint256 amount = calculateAmountPurchased(msg.value);
        require(totalOwed.add(amount) <= ethy.balanceOf(address(this)), "sold out");

        // update user and stats:
        claimable[msg.sender] = claimable[msg.sender].add(amount);
        totalOwed = totalOwed.add(amount);
        weiRaised = weiRaised.add(msg.value);
    }
}