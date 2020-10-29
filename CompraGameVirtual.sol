//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.6.12;

contract SellGameItem {
    address payable owner; // atual dono do item
    string owner_name; // nome do dono atual do item
    string item_name; // nome do item vendido
    uint item_id; // id do item vendido
    uint item_price; // preço do item vendido
    
    constructor(string memory _owner_name, string memory _item_name, uint _item_id, uint _item_price) public{
        owner = msg.sender;
        owner_name = _owner_name;
        item_name = _item_name;
        item_id = _item_id;
        item_price = _item_price;
    }
    
    modifier checkOwnership() {
        require (msg.sender == owner, "Apenas o dono do item pode modificar essa informacao!");
        _;
    }
    
    // o dono pode modificar o preço do item do contrato
    function setItemPrice(uint _item_price) public checkOwnership{
         item_price = _item_price;
    }
    
    // qualquer pessoa pode checar o preço atual do item
    function getItemPrice() public view returns (uint){
        return item_price;
    }
    
    function getItemName() public view returns (string memory){
        return item_name;
    }
    
    function getOwnerName() public view returns (string memory){
        return owner_name;
    }
    
    function buyItem() payable public{
        // require (msg.value > item_price, "O valor enviado foi maior que o estipulado pelo dono do contrato.");
        require (msg.value < item_price, "O valor enviado foi menor que o estipulado pelo dono");
        
        if (msg.value >= item_price){
            uint change = msg.value - item_price;
            // se o valor pago for maior que o estipulado devolve a quantia excedente
            if (change > 0) {
                msg.sender.transfer(change);
            }
            owner.transfer(address(this).balance);
        }
    }
}
