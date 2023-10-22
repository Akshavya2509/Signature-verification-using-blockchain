// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    function registerUser(
        string memory _username,
        string memory _firstName,
        string memory _lastName,
        string memory _email,
        string memory _mobileNumber,
        string memory _dob,
        string memory _passwordHash,
        string memory gender
    ) public {
        require(!users[msg.sender].isRegistered, "User is already registered.");

        // Use keccak256 for case-insensitive email comparison
        require(keccak256(abi.encodePacked(users[msg.sender].email)) != keccak256(abi.encodePacked(_email)), "Email is already registered.");

        // Hash the password before storing it
        bytes32 hashedPassword = keccak256(abi.encodePacked(_passwordHash));

        users[msg.sender] = User({
            username: _username,
            firstName: _firstName,
            lastName: _lastName,
            email: _email,
            mobileNumber: _mobileNumber,
            dob: _dob,
            passwordHash: hashedPassword, // Update the field to hashed password
            gender: gender,
            ipfsSignatureHash: "",
            isRegistered: true
        });

        emit UserRegistered(msg.sender, _username);
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

    function getdetails() public view returns(string memory,string memory,string memory,string memory,string memory,string memory,string memory){
        require(users[msg.sender].isRegistered, "User is not registered.");
        return (users[msg.sender].username, users[msg.sender].firstName, users[msg.sender].lastName, users[msg.sender].email, users[msg.sender].mobileNumber, users[msg.sender].dob, users[msg.sender].gender);
    }
    // Add other functions as needed for your application

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
