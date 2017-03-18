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
                            /* the mapping */

mapping (address => uint) public verifiedAddress;

                            /*the events*/

event funded(address origin, uint amount);
event newAllowed(address allowed);

                            /* adding allowed address */

    function addAllowed(address _newAllowed) ownerOnly {
        verifiedAddress[_newAllowed]=1;
         if (!_newAllowed.call.value(36000)()) throw;
         // adding an address send a few wei to pay for reKeth (-: 
        newAllowed(_newAllowed);
    }

                /*internal function checking if the msg.sender
                        is allowed to use the faucet*/

    function isAllowed (address _isAllowed) internal returns (bool) {
        if (verifiedAddress[_isAllowed] != 0) {
            if (verifiedAddress[_isAllowed]<block.timestamp) 
            return true ;}
        return false;
    }

    function reKeth()  { //get the pun ? request - reKeth? ok I'm out.
        if (isAllowed(msg.sender)){
            verifiedAddress[msg.sender]=block.timestamp + 86400;
            //86400=24*60*60 secondes therefore allowing for a daily reKeth
        if (!msg.sender.call.value(1000000000000000000)()) throw;
        funded(msg.sender, 1000000000000000000);       
        }    
    }

                        /* funding the faucet*/
    
    function fund() payable {
    funded(msg.sender,msg.value);
    }
    
                        /*Panic cleaning*/

    function removeAllowed(address _removeAllowed) ownerOnly {
        verifiedAddress[_removeAllowed]=0;
    }

    function TheMightyBackdoor() ownerOnly{
        selfdestruct(owner);
    }
}
