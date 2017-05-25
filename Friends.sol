pragma solidity ^0.4.8;

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

contract Me is mortal{

  string public myName;


  struct Friendship {
    bool active;
    uint since;
    uint256 iowehim; //Ether
  }

  mapping (address => Friendship) public friends;

  function Me(string _name){

    myName = _name;
  }

  function addFriend(address _friendAdress) ownerCallOnly{
     friends[_friendAdress] = Friendship({active: true,since: now,iowehim: 0});
  }


}

contract Friend is mortal{

  string public friendName;
  string public friendProfile;

  function Friend(string _name,string _friendProfile){

       friendName = _name;
       friendProfile = _friendProfile;
  }

}
