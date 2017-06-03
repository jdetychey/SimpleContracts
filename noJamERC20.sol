/*
ICOs can easily jam the mempool because transactions 
that arrive late to the party (i.e. when the capLimit
has been reached) will throw. Throwing transactions are
very costly in gas and therefore occupy considerable
space in blocks following the end of the ICO.
This issue should be solved with EIP140's revert that
is schedule for Metropolis. Till then, this contract 
introduces the modifier gasFriendlyStop.
This modifier give back funds safely when limit is 
reached without throwing. A boolean variable over has 
to be triggered manually when the transaction rush is over
to make sure that ethereum client will properly evaluate
throw. 
*/
pragma solidity ^0.4.10;

contract noJamERC20{

    modifier gasFriendlyStop(){
        if (cap > capLimit && over==false){
            secureSend(msg.sender, msg.value);
            return;
            }
        if (over==true) throw;
        _; 
    }
// secureSend as introduced by jbaylina
// see https://gist.github.com/jbaylina/e8ac19b8e7478fd10cf0363ad1a5a4b3

    function secureSend(address a, uint v) internal {
        if (v < address(this).balance) throw;
        assembly {
            let x := mload(0x40)   //Find empty storage location using "free memory pointer"
            mstore8(x,0x7f) //PUSH32
            mstore(add(x,1), a)
            mstore8(add(x,0x21), 0xff) // SELFDESTRUCT
            let payer := create(v, x, 0x22)
    
            jumpi(err, eq(payer, 0))
        
            jump(end)
        err:
            invalid()
        end:
        }
    }

/* The rest of the contract is a just for illustration */
    
uint256 public capLimit;
uint256 public cap;
bool public over;
address public admin;
    
    function gasFriendlyRaising(uint256 _capLimit){
            capLimit = _capLimit;
            admin = msg.sender;
    }

    function isOver() {
             over=true;
    }

    function destruct() {
             selfdestruct(admin);
    }

    function raiseFunds() payable gasFriendlyStop {
             cap = msg.value + cap;
    }
}

