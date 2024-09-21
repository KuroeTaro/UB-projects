// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract fst_erc_20 is ERC20 {
    // init the token we will use in our FSPs 
    // the name of the token is Food Safety Points - FSPs (FT)
    // FSPs can be received or sent to other people in this system
    uint256 public FSPsPool;

    //event
    event ReceivefromPool(address indexed _to, uint256 _value);
    event TransfertoPool(address indexed _from, uint256 _value);
    event send(address indexed _from, address indexed _to, uint256 _value);
    event Receive(address indexed _from, address indexed _to, uint256 _value);


    constructor() ERC20("Food Safety Points", "FSPs") {
        FSPsPool = 100000 * (10 ** uint256(decimals())); // a pool with 100000 fsps
        _mint(msg.sender, FSPsPool);
    }


    function TransferFSPsToPool(uint256 amount) external {
        require(amount <= balanceOf(msg.sender), "Insufficient FSPs");
        _transfer(msg.sender, address(this), amount);
        FSPsPool += amount;
        emit TransfertoPool(msg.sender, amount);
    }

    function ReceiveFSPsFromPool(uint256 amount) external {
        require(amount <= FSPsPool, "Insufficient FSPs in the pool");
        _transfer(address(this), msg.sender, amount);
        FSPsPool -= amount;
        emit ReceivefromPool(msg.sender, amount);
    }

    function SendTo(address to, uint256 amount) external {
        require(amount <= balanceOf(msg.sender), "Insufficient balance");
        _transfer(msg.sender, to, amount);
        emit send(msg.sender, to, amount);
    }

    function ReceiveFrom(address from, uint256 amount) external {
        _transfer(from, msg.sender, amount);
        emit Receive(from, msg.sender, amount);
    }
}