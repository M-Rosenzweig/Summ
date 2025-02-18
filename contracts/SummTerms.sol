// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";
import "./Summ.sol";


contract SummTerms {

    event TermsResponse(address _initializedSumm, bool _created); 

    address [] public createdSumms; 

    address payable immutable creator; 
    address payable immutable opponent;

    uint public totalSoftOffersCap; 
    uint public totalFirmOffersCap;
    uint public softRange;  
    uint public firmRange; 
    uint public penaltyPercent; 

    address payable immutable summFoundation;  

    modifier onlyOpponent() {
    require(msg.sender == opponent, "Only the contract opponent can call this function.");
    _;
}

    constructor(address payable _creator, address payable _opponent, uint _totalSoftOffersCap, uint _totalFirmOffersCap, uint _softRange, uint _firmRange, uint _penaltyPercent, address payable _summFoundation) {
        require(_totalSoftOffersCap < 10 && _totalSoftOffersCap > 0, "amount of soft offers cannot exceed 10 or be below 0"); 
        require(_totalFirmOffersCap < 10, "amount of firm offers cannot exceed 10"); 
        require(_opponent != _creator, "Opponent address cannot be the same as the creator address");
        require(_softRange > 0 && _softRange < 40); 
        require(_firmRange > 0 && _firmRange < 40);
        require(_penaltyPercent > 0 && _penaltyPercent < 20, "penalty percent must be in range of 0-19%");
        
        creator = _creator; 
        opponent = _opponent; 
        totalSoftOffersCap = _totalSoftOffersCap; 
        totalFirmOffersCap = _totalFirmOffersCap; 
        softRange = _softRange; 
        firmRange = _firmRange; 
        penaltyPercent = _penaltyPercent;
        summFoundation = _summFoundation;  
    } 

    function respondToTerms(bool _response) public onlyOpponent {
        if (_response == true){
             address initalizedSumm = address(new Summ(address(this)));
             emit TermsResponse(initalizedSumm, true);
             createdSumms.push(initalizedSumm); 

        } else {
            emit TermsResponse(0x0000000000000000000000000000000000000000, false); 
        }
    }

    function getCreator() public view returns(address payable) {
        return creator; 
    }

    function getOpponent() public view returns(address payable) {
        return opponent; 
    }

    function getSummFoundation() public view returns(address payable) {
        return summFoundation; 
    }
}