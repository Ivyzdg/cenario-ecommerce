-- Triggers
use cenario_Ecommerce;

-- Trigger de Remoção
-- Criar a tabela de histórico de clientes excluídos
create table client_deletions (
    idClient INT,
    fname VARCHAR(25),
    mname VARCHAR(25),
    lname VARCHAR(25),
    address VARCHAR(45),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar o trigger before delete para clientes
DELIMITER //
create TRIGGER before_client_delete 
BEFORE DELETE on clients
FOR EACH ROW 
begin
    insert into client_deletions (idClient, fname, mname, lname, address)
    values (OLD.idClient, OLD.fname, OLD.mname, OLD.lname, OLD.address);
end;
//
DELIMITER ;

-- Trigger de Atualização 
-- Criar a tabela para status de pedidos
create table order_status_audit (
    idOrder INT,
    old_status ENUM('Confirmado', 'Cancelado', 'Em Processamento'),
    new_status ENUM('Confirmado', 'Cancelado', 'Em Processamento'),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar o trigger before update para atualizar o status de pedidos
DELIMITER //
create TRIGGER before_order_status_update 
BEFORE UPDATE ON orders
FOR EACH ROW 
begin
    if OLD.orderStatus <> NEW.orderStatus THEN
        insert into order_status_audit (idOrder, old_status, new_status)
        values (OLD.idOrder, OLD.orderStatus, NEW.orderStatus);
    end if;
end;
//
DELIMITER ;

-- Trigger de Inserção
-- Criar a tabela das mensagens de pedidos
create table order_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar o trigger after insert para pedidos
DELIMITER //
create TRIGGER after_order_insert 
AFTER INSERT ON orders
FOR EACH ROW 
begin
    if NEW.orderDescription IS NULL THEN
        insert into order_messages (idOrder, message)
        values (NEW.idOrder, 'A descrição do pedido está ausente. Por favor, atualize seu pedido.');
    end if;
end;
//
DELIMITER ;

show triggers from cenario_Ecommerce;
