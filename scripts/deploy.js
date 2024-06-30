const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const ticketPrice = hre.ethers.utils.parseEther("0.01"); // Example ticket price in ether
    const totalTickets = 100; // Example total tickets available

    const RailwayTicketBooking = await hre.ethers.getContractFactory("RailwayTicketBooking");
    const railwayTicketBooking = await RailwayTicketBooking.deploy(ticketPrice, totalTickets);

    await railwayTicketBooking.deployed();

    console.log("RailwayTicketBooking contract deployed to:", railwayTicketBooking.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });


    // npx hardhat run --network localhost scripts/deploy.js
