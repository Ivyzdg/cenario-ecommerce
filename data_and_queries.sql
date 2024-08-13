-- inserindo os dados
use cenario_ecommerce;
show tables;

-- idClient, fname, mname, lname, address
insert into Clients (idClient, fname, mname, lname, address) values
	('1', 'Anthony', 'Edward', 'Stark', 'Stark Tower, New York'),
	('2', 'Markus', 'Sebastian', 'Grayson', 'Raccoon City, USA');

-- idClient, cpf
insert into clientperson (idClient, cpf) values
	(1, '123.456.789-00'),
	(2, '987.654.321-00');

-- idClient, nameCompany, cnpj
insert into clientcompany (idClient, companyName, CNPJ) values
	(1, 'Avengers HQ', '45.678.901/0001-33'),
	(2, 'S.T.A.R.S', '67.890.123/0001-44');

-- idSupplier, companyName, cnpj
insert into supplier (idSupplier, companyName, CNPJ) values
	(1, 'Stark Industries', '34.567.890/0001-11'),
	(2, 'Umbrella Corporation', '76.543.210/0001-22');

-- idInventory, loation
insert into inventory (idInventory, Location) values	
	(1, 'Metropolis Warehouse'),
	(2, 'Raccoon City Storage');

-- idProducts, category, descriptionProduct, price
insert into products (idProducts, category, descriptionProduct, Price) values
	(1, 'Weapons', 'Iron Man Suit', 1500000.00),
	(2, 'Biochemicals', 'T-Virus', 100000.00);

-- idOrder, idOrderClient, orderStatus, orderDescription, shippingCost
insert into orders (idOrder, idOrderClient, orderStatus, orderDescription, ShippingCost) values
(1, 1,'Em Processamento', 'Iron Man Suit order', 5000.00),
(2, 2, 'Confirmado', 'T-Virus order', 1000.00);

-- idPayment, idOrder, method, amont
insert into payment (idPayment, idOrder, method, amont) values
(1, 1, 'Cartão', 1505000.00),
(2, 2, 'Boleto', 101000.00);

-- idDelivery, statusDelivery, trackingCode, idOrder
insert into delivery (idDelivery, statusDelivery, trackingCode, idOrder) values
(1, 'Em Processamento', 'NYC123456789', 1),
(2, 'Entregue', 'RCC987654321', 2);

-- idProSeller, idSeller, idProducts
insert into productsseller (idProSeller, idSeller, idProducts) values
(1, 1, 1),  -- LexCorp selling Iron Man Suit
(2, 2, 2);  -- Oscorp selling T-Virus

-- idProInventory, quantity, idProducts, idInventory
insert into productsinventory (idProInventory, quantity, idProducts, idInventory) values
(1, 5, 1, 1),  -- 5 Iron Man Suits in Metropolis Warehouse
(2, 10, 2, 2); -- 10 T-Viruses in Raccoon City Storage

-- idSupply, idSupplier, idProducts
insert into supply (idSupply, idSupplier, idProducts) values
(1, 1, 1),  -- Stark Industries supplies Iron Man Suit
(2, 2, 2);  -- Umbrella Corporation supplies T-Virus

-- idSeller, sellerName, sellerCPF, sellerLocation, contact
insert into seller (idSeller, sellerName, sellerCPF, sellerLocation, contact) values
(1, 'Peter Parker', 123456789, 'Brooklyn',  111222333);  

-- idSeller, companyName, cnpj, thirdPS_Location
insert into thirdparty_seller (companyName, cnpj, thirdPS_Location) values
('LexCorp', '26021444000999', 'Metropolis'),
('Oscorp', '59595950000011', 'New York');

-- queries
select * from productsSeller; 

select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient;

select Fname,Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname,' ',Lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;

insert into orders (idOrder, idOrderClient, orderStatus, orderDescription, shippingCost) values 
							 (3, 2, default,'compra via aplicativo', '100');

select count(*) from clients c, orders o 
			where c.idClient = idOrderClient;

select * from orders;
select * from products;
select * from clients;

-- Recuperação de pedido com produto associado
    select * from clients c 
				inner join orders o ON c.idClient = o.idOrderClient
                inner join products p on p.idProducts = o.idOrderClient
                inner join productOrder po on po.idPOorder = o.idOrder
		group by c.idClient; 

-- Recuperar quantos pedidos foram realizados pelos clientes
select c.idClient, Fname, count(*) as Number_of_orders from clients c 
				inner join orders o ON c.idClient = o.idOrderClient
		group by idClient; 

-- Algum vendedor também é fornecedor?
select idSupplier from supplier sp
	inner join Seller s on sp.idSupplier = s.idSeller
    inner join thirdparty_seller p on sp.idSupplier = p.idtPSeller
    group by idSupplier;

-- Relação de produtos, fornecedores e estoques;
select idProducts, Category, descriptionProduct, price from products p
	inner join Supplier s on p.idProducts = s.idSupplier 
    inner join Inventory i on p.idProducts = s.idSupplier
    group by idProducts;

-- Relação de nomes dos fornecedores e nomes dos produtos;
select idProducts, category, descriptionProduct, price from products p
	inner join Supplier s on p.idProducts = s.idSupplier;
