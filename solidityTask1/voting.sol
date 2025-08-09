// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//✅ 创建一个名为Voting的合约，包含以下功能：
// 一个mapping来存储候选人的得票数
// 一个vote函数，允许用户投票给某个候选人
// 一个getVotes函数，返回某个候选人的得票数
// 一个resetVotes函数，重置所有候选人的得票数
contract Voting{

mapping (string => uint256) public votesReceived; // candidate => vote count

string[] public  users;


function vote(string memory name) public  {
    votesReceived[name] += 1;
    users.push(name);
}

function getVotes(string memory name) public view returns (uint256) {
    return votesReceived[name];
}

function resetVotes() public {
    if (users.length==0){
        return ;
    }
    for(uint256 i = 0; i < users.length; i++){
        votesReceived[users[i]] = 0;
    }
}




}