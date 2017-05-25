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

  function payItAll(address _friendAdress){

    _friendAdress.transfer(friends[_friendAdress].iowehim);
    friends[_friendAdress].iowehim = 0;
  }

    function setDebt(uint _money){
      if(friends[msg.sender].active){

        friends[msg.sender].iowehim = _money;

      }else{
        throw;
      }
    }


}

contract Friend is mortal{

  string public friendName;
  string public friendProfile;

  function Friend(string _name,string _friendProfile){

       friendName = _name;
       friendProfile = _friendProfile;
  }

  function lend(address _friendAdress, uint _money){
    Me person = Me (_friendAdress);
    person.setDebt(_money);

  }


}
