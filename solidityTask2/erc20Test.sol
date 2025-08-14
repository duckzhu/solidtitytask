// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


// import "@openzeppelin";
contract Erc20Test{

        // 代币名称（可选，仅展示用）
    string public name = "MyToken";
    // 代币符号（可选，仅展示用）
    string public symbol = "MTK";
    // 代币小数位数（标准是 18）
    uint8 public decimals = 18;
     // 总供应量
    uint256 public totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
     // 账户余额映射：地址 => 余额
    mapping(address => uint256) public balanceOf;

    // 授权映射：授权人 => (被授权人 => 授权额度)
    mapping(address => mapping(address => uint256)) public allowance;

  // 合约部署者（即代币拥有者 / 可 mint 的人）
    address public owner;

       // 构造函数：部署时给部署者 mint 初始代币（比如 1000 * 10^18）
    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * 10 ** decimals; // 比如 1000 * 10^18
        balanceOf[msg.sender] = totalSupply;         // 全部给部署者
    }



    // Modifier：仅限 owner 调用
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }


    // @notice 查询余额
    // @param account 地址
    // @return 余额
    function getBlance(address account) public view returns (uint256) {
        return balanceOf[account];
    }
    // @notice 转账代币
    // @param to 接收者地址
    // @param amount 转账数量
    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }
    // @notice 授权某个地址可以代扣自己的代币
    // @param spender 被授权地址
    // @param amount 授权额度
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

     /// @notice 由被授权人代扣转账
    /// @param from 资金来源地址
    /// @param to 接收者地址
    /// @param amount 转账数量
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        require(balanceOf[from] >= amount, "Not enough balance");
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");

//账户余额变化
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

//转账后授权额度减少
        allowance[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }


    // @notice 增发代币（仅限 owner 调用）
    // @param to 接收增发的地址
    // @param amount 增发数量
    function mint(address to, uint256 amount) public onlyOwner {
        totalSupply += amount;
        balanceOf[to] += amount;

        emit Transfer(address(0), to, amount); // 从 0 地址“铸造”出来
    }



}