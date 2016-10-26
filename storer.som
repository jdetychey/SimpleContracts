pragma solidity ^0.4.2;
/*'pragma' specify to the compiler what version of Solidity to use */

contract storer {
/*'contract' indicate the beginning of the contract, it is similar to 'class'
in other langages (class variables, inheritance, etc.)*/
address public owner;
string public log;
/* this two lines declare variables of the contrat and their types
'owner' is an address in Ethereum and is public (can be publicly read in the blockchain)
'log' is a string of indefinite size and is public */ 
function storer() {
    owner = msg.sender ;
}
/* 'storer' is a special function and is the constructor of the contract.
This function is executed only once that is when the contract is deployed.
Deploying a contract is a transaction and a transaction is represented in 
solidity by"msg", "msg.sender" corresponding to the address sending the transaction.  
Here when the contract is deployed the variable owner receive the address deploying the
contract */
modifier onlyOwner {
        if (msg.sender != owner)
            throw;
        _;
    }
    
/*  'modifier' imposes condition when calling functions. 
Using 'onlyOwner' allows to limit the use of certain function to the owner.*/

function store(string _log) onlyOwner() {
    log = _log;
}
/* the function 'store' receive a string in a transition variable '_log'. Should
the modifier 'onlyOwner' be removed and this function could be called by anyone.
'log' will change to '_log' after execution .*/

function changeOwner (address _newOwner)
       onlyOwner()
   {
       owner = _newOwner;
   }
 
function kill() onlyOwner() { 
  selfdestruct(owner); }
  /* This last function clean the blockchain from this code.*/
}
