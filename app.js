let cursor = document.querySelector('#cursor');
let body = document.querySelector('body');
document.addEventListener('mousemove', (e) => {
    body.style.backgroundPositionX = e.pageX / -4 + 'px';
    body.style.backgroundPositionY = e.pageY / -4 + 'px';
    cursor.style.top = e.pageY + 'px';
    cursor.style.left = e.pageX + 'px';
});

// Overlay toggle
const container = document.getElementById('container');
const overlayCon = document.getElementById('overlayCon');
const overlayBtn = document.getElementById('overlayBtn');

overlayBtn.addEventListener('click', () => {
    container.classList.toggle('right-panel-active');

    overlayBtn.classList.remove('btnSacled');
    window.requestAnimationFrame(() => {
        overlayBtn.classList.add('btnScaled');
    });
});

// Form submission for the first form
const scriptURL1 = 'https://script.google.com/macros/s/AKfycbxbaBXFkDAarHlby41UdSjFIGMu53EYEjQMIImovMbrciOOxCcoKFYpnTqwYa1zBgE/exec';
const form1 = document.forms['submit-to-google-sheet'];

form1.addEventListener('submit', async (e) => {
    e.preventDefault();

    // Get user input
    const username = form1.elements['First'].value;
    const firstName = form1.elements['First'].value;
    const lastName = form1.elements['Last'].value;
    const email = form1.elements['Email'].value;
    const mobileNumber = form1.elements['Mobile'].value;
    const dob = form1.elements['File'].value; // Assuming this is the date of birth
    const passwordHash = form1.elements['Password'].value;
    const gender = form1.elements['Gender'].value;

    // Call the registerUser function with user input
    await registerUser(username, firstName, lastName, email, mobileNumber, dob, passwordHash, gender);
    
    // Additional actions if needed
});

// Form submission for the second form
const scriptURL2 = 'https://script.google.com/macros/s/AKfycbwLTlI1omkeskMsaY0SU7i2FvaYmOEoD4bLlrxrGWHK82vlyj50J5ta8WpJc0zsRuU/exec';
const form2 = document.forms['submit-to-google-sheet2'];

form2.addEventListener('submit', async (e) => {
    e.preventDefault();

    // Get user input
    const email = form2.elements['Email'].value;
    const password = form2.elements['Password'].value;

    // Call the login function with user input
    await loginUser(email, password);
    
    // Additional actions if needed
});
// Import web3 library
import Web3 from 'web3';

// Connect to the Ethereum network using a provider (e.g., MetaMask)
// Note: Make sure the user has MetaMask installed and connected to the Ethereum network
const web3 = new Web3(window.ethereum);

// Contract ABI (Generated from Solidity compiler)
const contractABI = [
    // Include the ABI of your functions here
];

// Contract address
const contractAddress = 'YOUR_CONTRACT_ADDRESS';

// Create a contract instance
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Function to register a user
async function registerUser(username, firstName, lastName, email, mobileNumber, dob, passwordHash, gender) {
    try {
        // Get the current user's Ethereum address
        const accounts = await web3.eth.getAccounts();

        // Call the registerUser function in your smart contract
        await contract.methods.registerUser(
            username, firstName, lastName, email, mobileNumber, dob, passwordHash, gender
        ).send({ from: accounts[0] });
        
        console.log(await contract.methods.getDetails());
        console.log('User registered successfully.');
    } catch (error) {
        console.error('Error registering user:', error);
    }
}

// Function to login a user
async function loginUser(email, password) {
    try {
        // Get the current user's Ethereum address
        const accounts = await web3.eth.getAccounts();

        // Call the loginUser function in your smart contract
        // Assuming your smart contract has a login function, adjust it accordingly
        await contract.methods.loginUser(email, password).send({ from: accounts[0] });

        console.log('User logged in successfully.');
    } catch (error) {
        console.error('Error logging in user:', error);
    }
}
