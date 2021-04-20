pragma solidity 0.6.6;

contract Splitwise{
    struct CreditAcc{
        address creditor; //the person who lends money
        uint32 amount; //
    }
    
    //debtor address => creditor infor
    mapping (address => CreditAcc[]) creditAccMap;
    address[] users; //store all registered user's addresses.
    
    function getUsers() public view returns(address[] memory){
        return users;
    }
    
    //The debtor borrows money from the creditor
    function lookup(address debtor, address creditor) public view returns (uint32 ret){
        if(existCreditor(debtor, creditor)){
            CreditAcc[] memory ca = creditAccMap[debtor];
            for(uint i = 0; i < ca.length; i++){
                if(ca[i].creditor == creditor){
                    return ca[i].amount;
                }
            }
        }
        
        return 0;
    }
    
    function add_IOU(address creditor, uint32 amount)public {
        require(amount > 0);
        require(msg.sender != creditor);
        
        if(!existAnyCreditor(msg.sender)){
            CreditAcc[] storage creditAccArray;
            creditAccArray.push(CreditAcc(creditor, amount));
            creditAccMap[msg.sender] = creditAccArray;
        }else if(!existCreditor(msg.sender, creditor)){
            creditAccMap[msg.sender].push(CreditAcc(creditor, amount));
        }else {
            CreditAcc[] storage caArr = creditAccMap[msg.sender];
            for(uint i = 0; i < caArr.length; i++){
                if(caArr[i].creditor == creditor)
                    caArr[i].amount += amount;
            }
        }
        
        if(!existUser(creditor)) users.push(creditor);
        if(!existUser(msg.sender)) users.push(msg.sender);
    }
    
    
    //----------------------------------------------------------
    //helper functions
    //----------------------------------------------------------
    function existAnyCreditor(address debtor) private view returns(bool){
        if(creditAccMap[debtor].length == 0) return false;
        return true;
    }
    
    function existCreditor(address debtor, address creditor) private view returns(bool){
        if(!existAnyCreditor(debtor)) return false;
        CreditAcc[] memory caArr = creditAccMap[debtor];
        for(uint i = 0; i < caArr.length; i++){
            if(caArr[i].creditor == creditor)
                return true;
        }
        return false;
    }
    
    
    function existUser(address u)private view returns(bool){
        for(uint i = 0; i < users.length; i++){
            if(users[i] == u) return true;
        }        
        return false;
    }
}


