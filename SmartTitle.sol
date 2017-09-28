pragma solidity ^0.4.11;

contract Automobile{

     string  make;
     string  model;
     string  year;
     uint numberOfAccidents;
     string[] historyOfAccidents;
     uint price;
}

contract Car is Automobile{
    //About the CAR
    address public owner;

    function  Car(string _make,string _model,string _year, uint _numberOfAccidents,uint _price) public {
        make = _make;
        model = _model;
        year = _year;
        price = _price;
        numberOfAccidents = _numberOfAccidents;
    }

    function carDetails() public constant returns (string,string,string,uint,uint){
        return (make,model,year,numberOfAccidents,price);
    }

    function buyCar(uint _price){
      if(_price >= price){
        owner = msg.sender;
      }else {
        revert();
      }
    }

    function addAccident(string description) public {
        historyOfAccidents.push(description);
        numberOfAccidents = numberOfAccidents + 1;
    }

    function  accidentDetails(uint accidentNo) public constant returns (string){
      return historyOfAccidents[accidentNo];
    }


    //About the Lien
    address public lienHolder;
    uint public outStandingLoanOnCar;
    uint public monthlyDue;

    mapping (address => LienDetails) public lienDetails;

    struct LienDetails {
      bool active;
      uint since;
      uint256 loanAmount; //Ether or $
    }

    function addLienholders(address _lienHolder) {
      lienDetails[_lienHolder] = LienDetails({active: true,since: now,loanAmount: 0});
      lienHolder = _lienHolder;
    }

    function setDebt(uint _money, uint _monthlyDue){

        if(lienDetails[msg.sender].active){
            lienDetails[msg.sender].loanAmount = _money;
            outStandingLoanOnCar =  _money;
            monthlyDue = _monthlyDue;
        } else {
          revert();
        }
    }

    function reviseTotalDue(uint _money){

      if(lienDetails[msg.sender].active){
          outStandingLoanOnCar =  outStandingLoanOnCar - _money;
          if(outStandingLoanOnCar == 0){
            lienDetails[msg.sender].active = false;
            lienHolder = address(0);
          }
      } else {
        revert();
      }

    }
}

//The BANK
contract Bank {

    string public nameOfBank;

    function Bank(string _name){
      nameOfBank = _name;
    }

    function lend(address _borrowerAssetId, uint _money, uint _loanPeriod){
      Car car = Car (_borrowerAssetId);
      car.setDebt(_money,_money/_loanPeriod);
    }

    function payMonthlyDue(uint _dueAmount,address _borrowerAssetId){
      Car car = Car (_borrowerAssetId);
      car.reviseTotalDue(_dueAmount);
    }
}
