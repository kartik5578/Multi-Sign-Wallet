// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract MultiSigWallet {
    
    address[] public  owners;
    uint public Confirmnum;

    struct Transaction{
        address to;
        uint value;
        bool executed;
    }

    mapping (uint =>mapping (address=>bool)) isConfirmed;
    Transaction[] public transactions;


    event TransactionSubmitted(uint txId, address sender, address receiver, uint amount);
    event TransactionConfirmed(uint txId);
    event TransactionExecuted(uint txId);

    constructor(address[] memory _owners){
        require(_owners.length>0, "There must be at least one Owner");
        Confirmnum = (_owners.length/2)+1;

        require(Confirmnum>0 && Confirmnum<=_owners.length, "Number of confirmation is not proper");

        for(uint i=0; i<_owners.length; i++){
            require(_owners[i]!=address(0), "Invalid owner address");
            owners.push(_owners[i]);
        }
    }

    function submitTrasaction(address _to) public payable {
        require(_to!= address(0), "Invalid Receiver's Address");
        require(msg.value>0, "Must tranfer amount greater than 0");

        uint tx_id = transactions.length;

        transactions.push(Transaction({
            to: _to,
            value: msg.value,
            executed: false
        }));

        emit TransactionSubmitted(tx_id, msg.sender, _to, msg.value);
    }

    function confirmtransaction(uint _txId) public {
        require(_txId < transactions.length, "Invalid trasnsaction Id");
        require(!isConfirmed[_txId][msg.sender], "Transaction is already confirmed by the owner");

        isConfirmed[_txId][msg.sender]=true;

        emit TransactionConfirmed(_txId);

        if(isTrasnsactionConfirmed(_txId)){
            executeTransaction(_txId);
        }
    }

    function executeTransaction(uint _txId) internal{
        require(_txId<transactions.length, "Invalid transaction");
        require(!transactions[_txId].executed, "Transaction is already Executed");
        require(isTrasnsactionConfirmed(_txId), "Transaction is not confirmed yet");

       (bool success,) =  transactions[_txId].to.call{value: transactions[_txId].value}("");
       require(success, "transaction Failed");
       transactions[_txId].executed = true;

       emit TransactionExecuted(_txId);
    }

    function isTrasnsactionConfirmed(uint _txId) internal  view returns(bool){
        require(_txId < transactions.length, "Invalid transaction Id");
        uint confirmcount;

        for(uint i; i<owners.length; i++){
            if(isConfirmed[_txId][owners[i]]){
                confirmcount++;
            }
        }

        return confirmcount>=Confirmnum;
    }

    function totalTransactions() view public returns(uint){
        return transactions.length;
    }

    function Confirmnumber() view public returns(uint){
        return Confirmnum;
    }


}
