use cenario_ecommerce;
SET autocommit = 0;

-- Iniciando a transação
START TRANSACTION;

-- inserindo modificações
INSERT INTO clients (fname, mname, lname, address) VALUES ('John', 'D.', 'Doe', '123 Main St');
INSERT INTO orders (idOrder, idOrderClient, orderStatus, orderDescription, shippingCost) VALUES (1, LAST_INSERT_ID(), 'Confirmado', 'Pedido de Teste', 50.00);

rollback; -- caso haja algum problema
commit; -- confirmando as mudanças

-- Transação com Procedure
DELIMITER $$
CREATE PROCEDURE InsertOrderAndPayment(
    IN clientId INT, 
    IN orderDesc VARCHAR(255), 
    IN shipCost FLOAT, 
    IN paymentAmount DECIMAL(10, 2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        rollback;
    END;

    START TRANSACTION;

    INSERT INTO orders (idOrder, idOrderClient, orderStatus, orderDescription, shippingCost)
    values (null, clientId, 'Em Processamento', orderDesc, shipCost);

    set @orderId = LAST_INSERT_ID();

    SAVEPOINT before_payment;

    INSERT INTO payment (idPayment, idOrder, method, amont)
    values (null, @orderId, 'Cartão', paymentAmount);

    -- Condição de erro para demonstração
    if paymentAmount > 1000 THEN
        ROLLBACK TO before_payment;
    END IF;

    COMMIT;
END$$
DELIMITER ;

call InsertOrderAndPayment(1, 'Compra de Teste', 30.00, 500.00);
show PROCEDURE status where Db = 'cenario_Ecommerce';

