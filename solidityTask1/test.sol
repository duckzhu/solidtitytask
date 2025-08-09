// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Test{

// ✅ 反转字符串 (Reverse String)
// 题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"

function reverseString(string memory input) public pure returns (string memory) {
    bytes memory bytesInput = bytes(input);
    uint256 length = bytesInput.length;
    for (uint256 i = 0; i < length / 2; i++) {
        // 交换字符
        (bytesInput[i], bytesInput[length - 1 - i]) = (bytesInput[length - 1 - i], bytesInput[i]);
    }
    return string(bytesInput);
}

 
// ✅  用 solidity 实现整数转罗马数字
// 题目描述在 https://leetcode.cn/problems/roman-to-integer/description/3.
//  mapping(string => uint256) public romanToInt;
//  mapping(uint256 => string) public intToRoman;
   

 // 数值数组（从大到小）
    uint[] private val = [
        1000, 900, 500, 400,
        100, 90, 50, 40,
        10, 9, 5, 4, 1
    ];

    // 对应的罗马数字字符串数组
    string[] private sym = [
        "M", "CM", "D", "CD",
        "C", "XC", "L", "XL",
        "X", "IX", "V", "IV", "I"
    ];

    //  将整数转换为罗马数字字符串
    // 输入数字，范围建议 1 ~ 3999
    // @return 对应的罗马数字字符串
    function intToRoman(uint num) public view returns (string memory) {
        require(num > 0 && num <= 3999, "Number must be between 1 and 3999");

        bytes memory roman = new bytes(15); // 足够大的缓冲区
        uint index = 0;

        for (uint i = 0; i < val.length; i++) {
            while (num >= val[i]) {
                // 将 sym[i] 拼接到结果中
                bytes memory s = bytes(sym[i]);
                for (uint j = 0; j < s.length; j++) {
                    roman[index++] = s[j];
                }
                num -= val[i];
            }
        }

        // 创建一个刚好长度的字符串返回
        bytes memory result = new bytes(index);
        for (uint k = 0; k < index; k++) {
            result[k] = roman[k];
        }

        return string(result);
    }

    


// ✅  用 solidity 实现罗马数字转数整数
// 题目描述在 https://leetcode.cn/problems/integer-to-roman/description/

function romanToInt(string memory s) public pure returns (int) {
        bytes memory romanBytes = bytes(s); // 将 string 转为 bytes，方便按索引访问字符
        int total = 0;

        for (uint i = 0; i < romanBytes.length; i++) {
            uint currentVal = charToValue(romanBytes[i]);

            // 如果不是最后一个字符，且当前值 < 下一个值，则是减法情况（如 IV = 4）
            if (i < romanBytes.length - 1) {
                uint nextVal = charToValue(romanBytes[i + 1]);
                if (currentVal < nextVal) {
                    total -= int(currentVal);
                    continue;
                }
            }

            total += int(currentVal);
        }

        return total;
    }

  function charToValue(bytes1 c) private pure returns (uint) {
        if (c == bytes1("I")) return 1;
        if (c == bytes1("V")) return 5;
        if (c == bytes1("X")) return 10;
        if (c == bytes1("L")) return 50;
        if (c == bytes1("C")) return 100;
        if (c == bytes1("D")) return 500;
        if (c == bytes1("M")) return 1000;
        return 0;
    }

// ✅  合并两个有序数组 (Merge Sorted Array)
// 题目描述：将两个有序数组合并为一个有序数组。
function mergeSortedArrays(int[] memory a, int[] memory b) public pure returns (int[] memory) {
        uint i = 0; // 指向数组 a 的索引
        uint j = 0; // 指向数组 b 的索引
        uint k = 0; // 指向结果数组的索引

        uint n = a.length;
        uint m = b.length;

        // 创建一个新的数组，长度为两个数组之和
        int[] memory result = new int[](n + m);

        // 同时遍历 a 和 b，按顺序选择较小的元素放入结果
        while (i < n && j < m) {
            if (a[i] <= b[j]) {
                result[k] = a[i];
                i++;
            } else {
                result[k] = b[j];
                j++;
            }
            k++;
        }

        // 如果 a 还有剩余元素，全部追加到结果
        while (i < n) {
            result[k] = a[i];
            i++;
            k++;
        }

        // 如果 b 还有剩余元素，全部追加到结果
        while (j < m) {
            result[k] = b[j];
            j++;
            k++;
        }

        return result;
    }

// ✅  二分查找 (Binary Search)
// 题目描述：在一个有序数组中查找目标值。

    // @notice 在升序数组中执行二分查找
    // @param arr 已排序的升序整数数组
    // @param target 要查找的目标值
    // @return 如果找到，返回索引；否则返回 -1
    function binarySearch(int[] memory arr, int target) public pure returns (int) {
        int left = 0;
        int right = int(arr.length) - 1;

        while (left <= right) {
            int mid = left + (right - left) / 2; // 防止溢出

            if (arr[uint(mid)] == target) {
                return mid; // 找到目标，返回索引
            } else if (arr[uint(mid)] < target) {
                left = mid + 1; // 目标在右半部分
            } else {
                right = mid - 1; // 目标在左半部分
            }
        }

        return 0; // 没有找到
    }


}
