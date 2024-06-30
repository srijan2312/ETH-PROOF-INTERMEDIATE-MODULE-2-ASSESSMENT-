// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RailwayTicketBooking {
    struct Ticket {
        address passenger;
        uint256 amount;
        bool isBooked;
    }

    address public owner;
    uint256 public ticketPrice;
    uint256 public totalTickets;
    uint256 public bookedTickets;

    mapping(uint256 => Ticket) public tickets;

    event TicketBooked(uint256 ticketId, address passenger);
    event TicketCancelled(uint256 ticketId, address passenger);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor(uint256 _ticketPrice, uint256 _totalTickets) {
        owner = msg.sender;
        ticketPrice = _ticketPrice;
        totalTickets = _totalTickets;
    }

    function bookTicket(uint256 ticketId) public payable {
        require(ticketId < totalTickets, "Invalid ticket ID");
        require(!tickets[ticketId].isBooked, "Ticket already booked");
        require(msg.value == ticketPrice, "Incorrect ticket price");

        tickets[ticketId] = Ticket({
            passenger: msg.sender,
            amount: msg.value,
            isBooked: true
        });

        bookedTickets += 1;
        emit TicketBooked(ticketId, msg.sender);
    }

    function cancelTicket(uint256 ticketId) public {
        require(ticketId < totalTickets, "Invalid ticket ID");
        require(tickets[ticketId].isBooked, "Ticket not booked");
        require(tickets[ticketId].passenger == msg.sender, "Only the ticket owner can cancel the booking");

        address passenger = tickets[ticketId].passenger;
        uint256 amount = tickets[ticketId].amount;

        tickets[ticketId] = Ticket({
            passenger: address(0),
            amount: 0,
            isBooked: false
        });

        bookedTickets -= 1;
        payable(passenger).transfer(amount);

        emit TicketCancelled(ticketId, passenger);
    }

    function checkAvailability() public view returns (uint256) {
        return totalTickets - bookedTickets;
    }
}
