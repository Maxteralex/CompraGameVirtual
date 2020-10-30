//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.6.12;

contract VirtualGameItemStore {
    address payable owner; // atual dono do item
    string item_name; // nome do item vendido
    string item_info; // descrição do item vendido
    uint item_id; // id do item vendido
    uint item_price; // preço do item vendido
    bool item_sold; // status vendido/não vendido
    
    constructor(string memory _item_name, string memory _item_info, uint _item_id, uint _item_price) public {
        owner = msg.sender;
        item_name = _item_name;
        item_info = _item_info;
        item_id = _item_id;
        item_price = _item_price;
        item_sold = false;
    }
    
    modifier checkOwnership() {
        require (msg.sender == owner, "Apenas o dono do item pode modificar essa informacao!");
        _;
    }
    
    // apenas o dono pode modificar o preço do item do contrato
    function setItemPrice(uint _item_price) public checkOwnership {
        item_price = _item_price;
    }

    // apenas o dono pode habilitar seu item para a venda
    function sellItem() public checkOwnership {
        item_sold = false;
    }
    
    // qualquer pessoa pode checar o preço atual do item
    function getItemPrice() public view returns (uint) {
        return item_price;
    }
    
    // qualquer pessoa pode checar o nome do item
    function getItemName() public view returns (string memory) {
        return item_name;
    }
    
    // qualquer pessoa pode checar a descrição do item
    function getItemInfo() public view returns (string memory) {
        return item_info;
    }
    
    // qualquer pessoa, com exceção do próprio dono, pode comprar o item vendido
    function buyItem() payable public {
        require (msg.sender != owner, "Você já é o dono do item.");
        require (!item_sold, "O item já foi vendido.");
        require (msg.value >= item_price, "O valor enviado foi menor que o estipulado pelo dono");
        
        uint change = msg.value - item_price;
        // se o valor pago for maior que o preço do item, é devolvida a quantia excedente
        if (change > 0) {
            msg.sender.transfer(change);
        }
        owner.transfer(address(this).balance);
        owner = msg.sender;
        item_sold = true;
    }
}
