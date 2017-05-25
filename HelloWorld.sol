pragma solidity ^0.4.11;

contract mortal{
  address public owner;

  function mortal(){
    owner = msg.sender;
  }

  modifier ownerCallOnly(){
    if(msg.sender != owner){
      throw;
    }else{
      _;
    }
  }

  function kill() ownerCallOnly {
    suicide(owner);
  }

}

contract Hello is mortal{

  string public sayingHelloTo;

  function Hello(string _name){

       sayingHelloTo = _name;
  }

}

contract Bye is mortal{

  string public sayingByeTo;

  function Bye(string _name){

       sayingByeTo = _name;
  }

}
