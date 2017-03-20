pragma solidity ^0.4.9;

contract Owned {
    
  /* owner should be a bot doing a little KYC job  and calling addAllowed */
  
  address public owner = msg.sender;
  modifier ownerOnly() {
    if (msg.sender != owner) throw;
    _;
    }
                            /* transfer ownership */
  
    function changeOwner(address _newOwner) ownerOnly {
    owner = _newOwner;
    }
}

contract Faucet is Owned {

    mapping (address => uint) public isVerified;
    
    event FundsReceived(address origin, uint amount);
    event FundsSent(address recipient, uint amount);
    event RecipientAdded(address allowed);
    
    uint GAS_TIP = 36000;
    uint DAILY_AMOUNT = 1000000000000000000;

    modifier allowedOnly() {
        if(isVerified[msg.sender] == 0 || isVerified[msg.sender] > now) return;
        _;
    }

    function verify(address candidate) ownerOnly {
        isVerified[candidate] = now;
        // adding an address send a few wei to pay for reKeth (-: 
        candidate.transfer(GAS_TIP);
        RecipientAdded(candidate);
    }

    function reKeth() allowedOnly()  { 
        // get the pun ? request - reKeth? ok I'm out.
        msg.sender.transfer(DAILY_AMOUNT);
        // kindly ask to come back in one day
        isVerified[msg.sender] = now + 1 days;
        FundsSent(msg.sender, DAILY_AMOUNT);       
    }

    function fund() payable {
        if(msg.value == 0) return;
        FundsReceived(msg.sender, msg.value);
    }
    
    function unverify(address candidate) ownerOnly {
        isVerified[candidate] = 0;
    }

    function TheMightyBackdoor() ownerOnly{
        selfdestruct(owner);
    }
}
