pragma solidity ^0.5.7;
import "./SquareCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";
// Inherit the crowdsale contracts
contract SquareCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {
    constructor(
        uint rate, 
        SquareCoin token,  
        address payable wallet, 
        uint goal, 
        uint open,
        uint close
    )
        
    Crowdsale(rate, wallet, token)
    TimedCrowdsale(now, now + 24 weeks)
    CappedCrowdsale(goal)
    RefundableCrowdsale(goal)
        public
    {
        
    }
}
contract SquareCoinSaleDeployer {
    address public token_sale_address;
    address public token_address;
    constructor(
        string memory name,
        string memory symbol,
        address payable wallet, 
        uint goal
    )
        public
    {
        // create the SquareCoin and keep its address handy
        SquareCoin token = new SquareCoin(name, symbol, 0);
        token_address = address(token);
        //create the SquareCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        SquareCoinCrowdsale token_sale = new SquareCoinCrowdsale(1, token, wallet, goal, now, now + 24 weeks);
        token_sale_address = address(token_sale);
        
        // make the SquareCoinSale contract a minter, then have the SquareCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}











