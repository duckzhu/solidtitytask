// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BeggingConract{
    //记录owner
    address payable private owner;
    //1 捐赠列表
    mapping(address => uint256) private donations;
    // 2. 所有捐过款的地址（用于遍历）
    address[] private donors;
    // 3. 记录某地址是否已经捐过款（避免重复加入 donors 数组）
    mapping(address => bool) private hasDonated;
    
    
    //捐赠明细
    struct DonationInfo{
        address _address;
        uint256 _amount;
        uint256 currentTimestamp;
    }

    //捐赠事件记录
    DonationInfo[] private donationInfos;

    //捐赠事件
    event Donation(address indexed from, uint256 amount);

    error CallFailed();

    constructor(){
        owner =  payable (msg.sender);
    }
   
    //校验
    modifier onlyOwner() {
    require(owner == msg.sender, "Only owner can withdraw");
    _;
    }
    //校验
    modifier balanceCheck(uint256 _amount) {
    require(address(this).balance >= _amount, "Not enough balance");
    _;
    }    

    //捐赠，记录捐赠信息，更改捐赠列表
     function donate() external payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        donations[msg.sender] += msg.value;
        address donor = msg.sender;
        DonationInfo memory donation = DonationInfo(donor,msg.value,block.timestamp);
        donationInfos.push(donation);
        emit Donation(donor, msg.value);
         // 如果是第一次捐款，才加入 donors 列表
        if (!hasDonated[donor]) {
            hasDonated[donor] = true;
            donors.push(donor);
        }
    }

    //提取余额
     function withdraw(uint256 _amount) public onlyOwner balanceCheck(_amount) {
        (bool success,) = owner.call{value: _amount}("");
        if(!success){
            revert CallFailed();
        }
    }

    //查看余额
    function getBlance() external view returns(uint256){
        return address(this).balance;
    }

    //查看捐赠信息
     function getDonation(address _address) external view returns(uint256) {
        return donations[_address];
    }

     //查看捐赠日志
     function getDonationEvent(address _address) external view returns(DonationInfo[] memory) {
        DonationInfo[] memory d = new DonationInfo[](donationInfos.length);
    
        uint count = 0;
        for(uint i=0;i<donationInfos.length;i++){
            if(donationInfos[i]._address == _address){
                count++;
                d[count]= donationInfos[i];
            }
        }
        return d;
    }


    //  获取捐款金额最高的 3 个地址及其金额
    function getTop3Donors() public view returns (
        address[3] memory topAddresses,
        uint256[3] memory topAmounts
    ) {
        // 初始化默认值（可以为 0 地址和 0 值）
        topAddresses = [address(0), address(0), address(0)];
        topAmounts = [uint256(0), uint256(0), uint256(0)];

        // 遍历所有捐过款的地址
        for (uint i = 0; i < donors.length; i++) {
            address currentDonor = donors[i];
            uint256 currentAmount = donations[currentDonor];

            // 检查并更新 top 1
            if (currentAmount > topAmounts[0]) {
                topAddresses[2] = topAddresses[1];
                topAmounts[2] = topAmounts[1];

                topAddresses[1] = topAddresses[0];
                topAmounts[1] = topAmounts[0];

                topAddresses[0] = currentDonor;
                topAmounts[0] = currentAmount;
            }
            // 检查并更新 top 2
            else if (currentAmount > topAmounts[1]) {
                topAddresses[2] = topAddresses[1];
                topAmounts[2] = topAmounts[1];

                topAddresses[1] = currentDonor;
                topAmounts[1] = currentAmount;
            }
            // 检查并更新 top 3
            else if (currentAmount > topAmounts[2]) {
                topAddresses[2] = currentDonor;
                topAmounts[2] = currentAmount;
            }
        }
    }

}