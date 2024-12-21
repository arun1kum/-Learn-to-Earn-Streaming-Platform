// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract LearnToEarn {
    struct Course {
        string title;
        uint256 reward;
        bool exists;
    }

    address public owner;
    uint256 public totalCourses;
    mapping(uint256 => Course) public courses;
    mapping(address => uint256) public userRewards;

    event CourseCompleted(address indexed user, uint256 courseId, uint256 reward);
    event RewardClaimed(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalCourses = 0;
    }

    // Add a new course
    function addCourse(string memory _title, uint256 _reward) public onlyOwner {
        courses[totalCourses] = Course(_title, _reward, true);
        totalCourses++;
    }

    // Complete a course and earn a reward
    function completeCourse(uint256 _courseId) public {
        require(courses[_courseId].exists, "Course does not exist");
        userRewards[msg.sender] += courses[_courseId].reward;
        emit CourseCompleted(msg.sender, _courseId, courses[_courseId].reward);
    }

    // Claim earned rewards
    function claimRewards() public {
        uint256 reward = userRewards[msg.sender];
        require(reward > 0, "No rewards to claim");
        userRewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
        emit RewardClaimed(msg.sender, reward);
    }

    // Allow the contract to receive Ether for rewards
    receive() external payable {}
}
