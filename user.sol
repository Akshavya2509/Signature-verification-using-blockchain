// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

contract SignatureVerification {
    address public owner;

    struct User {
        string username;
        string firstName;
        string lastName;
        string email;
        string mobileNumber;
        string dob;
        bytes32 passwordHash; // You should hash passwords for security
        string gender;
        string ipfsSignatureHash; // IPFS hash for the user's signature image
        bool isRegistered;
    }

    mapping(address => User) public users;

    event UserRegistered(address indexed userAddress, string username);
    event SignatureUploaded(address indexed userAddress, string ipfsSignatureHash);
    event UserLoggedIn(address indexed userAddress);

    constructor() public{
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    function registerUser(
        User memory u
    ) public {
        require(!users[msg.sender].isRegistered, "User is already registered.");

        // Use keccak256 for case-insensitive email comparison
        require(keccak256(abi.encodePacked(users[msg.sender].email)) != keccak256(abi.encodePacked(u.email)), "Email is already registered.");

        // Hash the password before storing it
        bytes32 hashedPassword = keccak256(abi.encodePacked(u.passwordHash));

        users[msg.sender] = User({
            username: u.username,
            firstName: u.firstName,
            lastName: u.lastName,
            email: u.email,
            mobileNumber: u.mobileNumber,
            dob: u.dob,
            passwordHash: hashedPassword, // Update the field to hashed password
            gender: u.gender,
            ipfsSignatureHash: "",
            isRegistered: true
        });

        emit UserRegistered(msg.sender, u.username);
    }

    function uploadSignature(string memory _ipfsSignatureHash) public {
        require(users[msg.sender].isRegistered, "User is not registered.");

        users[msg.sender].ipfsSignatureHash = _ipfsSignatureHash;

        emit SignatureUploaded(msg.sender, _ipfsSignatureHash);
    }

    function loginUser(string memory _email, string memory _password) public {
        require(users[msg.sender].isRegistered, "User is not registered.");
        require(keccak256(abi.encodePacked(users[msg.sender].email)) == keccak256(abi.encodePacked(_email)), "Invalid email.");

        // Hash the provided password for comparison
        bytes32 hashedPassword = keccak256(abi.encodePacked(_password));

        // Convert the stored password to bytes32 before comparison
        bytes32 storedPassword = bytes32(uint256(users[msg.sender].passwordHash));

        require(storedPassword == hashedPassword, "Invalid password.");

        emit UserLoggedIn(msg.sender);
    }

    // Add other functions as needed for your application

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
