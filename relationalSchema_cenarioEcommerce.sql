create database if not exists cenario_Ecommerce; 
use cenario_Ecommerce;

-- tabela client
CREATE TABLE clients (
	idClient INT auto_increment PRIMARY KEY,
    fname VARCHAR(25) NOT NULL,
    mname VARCHAR(25) NOT NULL,
    lname VARCHAR(25) NOT NULL,
    address VARCHAR(45) NOT NULL
);

-- tabela cliente Pessoa Física
CREATE TABLE clientPerson (
	idClient INT,
    cpf VARCHAR (11) UNIQUE NOT NULL, 
    FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);

-- tabela cliente Pessoa Jurídica
CREATE TABLE clientCompany (
	idClient INT,
    companyName varchar (50),
    cnpj varchar (14),
    FOREIGN KEY (idClient) references Clients(idClient)
);

-- tabela fornecedor
CREATE TABLE supplier (
	idSupplier INT auto_increment PRIMARY KEY,
	companyName varchar (50) NOT NULL,
    cnpj varchar (14)
);

-- tabela estoque
CREATE TABLE inventory(
	idInventory INT primary key, 
    location varchar(50) NOT NULL
);

-- tabela produtos
CREATE TABLE products(
	idProducts INT auto_increment primary key,
    category VARCHAR(45) not null,
    descriptionProduct varchar (45),
    price DECIMAL (10, 2) not null
);

-- tabela pedido
create table Orders(
	idOrder int,
    idOrderClient int,
    orderStatus enum ('Confirmado', 'Cancelado', 'Em Processamento') default 'Em Processamento',
    orderDescription varchar(255),
    shippingCost float,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
);

-- tabela pagamento
create table Payment(
	idPayment int, 
    idOrder int,
    method enum('Cartão', 'Dois Cartões', 'Boleto', 'Pix', 'Transferência') not null,
    amont DECIMAL (10, 2) not null,
	constraint fk_payment_orders FOREIGN KEY (idOrder) REFERENCES `Orders`(idOrder)
);

-- tabela entrega
create table delivery(
	idDelivery int,
    statusDelivery enum ('Em Processamento', 'Aguardando Pagamento', 'Enviado', 'Entregue', 'Cancelado') not null,
    trackingCode varchar(45) not null,
    idOrder int,
    constraint fk_delivery_orders FOREIGN KEY (idOrder) REFERENCES `Orders`(idOrder)
);

-- tabela terceiro-vendedor
create table thirdParty_Seller (
    idtPSeller INT AUTO_INCREMENT PRIMARY KEY,
    companyName VARCHAR(45) NOT NULL,
	CNPJ char(15) unique,
    thirdPS_location VARCHAR(45)
);

-- tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    sellerCPF char(9),
    sellerLocation varchar(255),
    contact char(11) not null,
    constraint unique_cpf_seller unique (sellerCPF) 
);

-- tabela produtos por vendedor
create table productsSeller(
	idProSeller INT AUTO_INCREMENT PRIMARY KEY,
    idSeller INT,
    idProducts INT,
    constraint fk_productsSeller_Seller FOREIGN KEY (idSeller) REFERENCES thirdParty_Seller(idSeller),
    constraint fk_productsSeller_Products FOREIGN KEY (idProducts) REFERENCES products(idProduct)
);

-- relação produto por pedido
CREATE TABLE productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references products(idProducts),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)
);

-- tabela disponibilizando (conexão produtos-fornecedor)
create table Supply (
idSupply int auto_increment primary key,
idSupplier int,
idProducts INT,
constraint fk_supply_idSupplier FOREIGN KEY (idSupplier) REFERENCES Supplier(idSupplier),
constraint fk_supply_Products foreign key (idProducts) references Products(idProducts)
);

-- tabela produto tem no estoque
create table productsInventory(
	idProInventory int auto_increment primary key,
	quantity int,
    idProducts int,
    idInventory int,
    constraint fk_productsInventory_Products FOREIGN KEY (idProducts) references products(idProducts),
    constraint fk_productsInventory_Inventory FOREIGN KEY (idInventory) references Inventory(idInventory)
);

show tables;