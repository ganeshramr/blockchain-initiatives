pragma solidity ^0.4.11;

contract Automobile{

     string  make;
     string  model;
     string  year;
     uint numberOfAccidents;
     string[] historyOfAccidents;
}

contract Car is Automobile{

   //About the CAR
    address public owner;
    function  Car(string _make,string _model,string _year, uint _numberOfAccidents) public {
      make = _make;
      model = _model;
      year = _year;
      numberOfAccidents = _numberOfAccidents;
   }

    function carDetails() public constant returns (string,string,string,uint){
      return (make,model,year,numberOfAccidents);
    }

    function addAccident(string description) public {
      historyOfAccidents.push(description);
      numberOfAccidents = numberOfAccidents + 1;
    }

  function  accidentDetails(uint accidentNo) public constant returns (string){
      return historyOfAccidents[accidentNo];
    }

  function buyCar(){
    owner = msg.sender;
  }

  //About the Lien
   address lienHolder;

    struct LienDetails {
      bool active;
      uint since;
      uint256 loanAmount; //Ether
    }

    uint public outStandingLoanOnCar;


    mapping (address => LienDetails) public lienDetails;

    function addLienholders(address _lienHolder) {

      lienDetails[_lienHolder] = LienDetails({active: true,since: now,loanAmount: 0});
      lienHolder = _lienHolder;
    }

    function setDebt(uint _money){

        if(lienDetails[msg.sender].active){

          lienDetails[msg.sender].loanAmount = _money;
          outStandingLoanOnCar = outStandingLoanOnCar + _money;

        }else{
          revert();
        }
      }


}

contract DCU {

    string public nameOfBank;

    function DCU(string _name){
      nameOfBank = _name;
    }

    function lend(address _borrowerAssetId, uint _money){
      Car car = Car (_borrowerAssetId);
      car.setDebt(_money);
    }

}
