
-- banco de dados para um sistema de e-commerce

-- Criando o banco de dados
CREATE DATABASE ecommerce;
USE ecommerce;

-- Tabela de Clientes
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    clientType ENUM('PF', 'PJ') NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    registrationDate DATETIME DEFAULT CURRENT_TIMESTAMP
);



-- Tabela de Clientes Pessoa Física
CREATE TABLE clientPF (
    idClientPF INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    cpf CHAR(11) UNIQUE NOT NULL,
    birthDate DATE,
    FOREIGN KEY (idClient) REFERENCES clients(idClient)
);

-- Tabela de Clientes Pessoa Jurídica
CREATE TABLE clientPJ (
    idClientPJ INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    cnpj CHAR(14) UNIQUE NOT NULL,
    companyName VARCHAR(100) NOT NULL,
    stateRegistration VARCHAR(20),
    FOREIGN KEY (idClient) REFERENCES clients(idClient)
);

-- Tabela de Endereços
CREATE TABLE addresses (
    idAddress INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    street VARCHAR(100) NOT NULL,
    number VARCHAR(10),
    complement VARCHAR(50),
    neighborhood VARCHAR(50),
    city VARCHAR(50) NOT NULL,
    state CHAR(2) NOT NULL,
    zipCode CHAR(8) NOT NULL,
    addressType ENUM('Residencial', 'Comercial', 'Entrega') DEFAULT 'Residencial',
    FOREIGN KEY (idClient) REFERENCES clients(idClient)
);

-- Tabela de Produtos
CREATE TABLE products (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    description TEXT,
    category ENUM('Eletrônicos', 'Roupas', 'Livros', 'Casa', 'Esportes') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    rating FLOAT DEFAULT 0,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Fornecedores
CREATE TABLE suppliers (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    companyName VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    contactName VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- Tabela de Vendedores
CREATE TABLE sellers (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    companyName VARCHAR(100),
    cpf CHAR(11),
    cnpj CHAR(14),
    contactName VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    sellerType ENUM('PF', 'PJ') NOT NULL
);

-- Tabela de Estoque
CREATE TABLE productStorage (
    idStorage INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 0
);

-- Tabela de Pedidos
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    totalAmount DECIMAL(10,2) DEFAULT 0,
    orderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    estimatedDeliveryDate DATE,
    FOREIGN KEY (idClient) REFERENCES clients(idClient)
);

-- Tabela de Pagamentos
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    paymentType ENUM('Cartão', 'Boleto', 'PIX', 'Transferência') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    paymentStatus ENUM('Pendente', 'Aprovado', 'Recusado') DEFAULT 'Pendente',
    paymentDate DATETIME,
    installments INT DEFAULT 1,
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- Tabela de Entregas
CREATE TABLE deliveries (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    trackingCode VARCHAR(50) UNIQUE,
    deliveryStatus ENUM('Preparando', 'Enviado', 'Em trânsito', 'Entregue') DEFAULT 'Preparando',
    shippingDate DATETIME,
    deliveryDate DATETIME,
    shippingCost DECIMAL(10,2) DEFAULT 0,
    carrier VARCHAR(50),
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- Tabelas de Relacionamento
CREATE TABLE productSupplier (
    idProduct INT,
    idSupplier INT,
    supplyPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idProduct, idSupplier),
    FOREIGN KEY (idProduct) REFERENCES products(idProduct),
    FOREIGN KEY (idSupplier) REFERENCES suppliers(idSupplier)
);

CREATE TABLE productSeller (
    idProduct INT,
    idSeller INT,
    sellerPrice DECIMAL(10,2) NOT NULL,
    sellerQuantity INT DEFAULT 1,
    PRIMARY KEY (idProduct, idSeller),
    FOREIGN KEY (idProduct) REFERENCES products(idProduct),
    FOREIGN KEY (idSeller) REFERENCES sellers(idSeller)
);

CREATE TABLE productOrder (
    idProduct INT,
    idOrder INT,
    quantity INT DEFAULT 1,
    unitPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idProduct, idOrder),
    FOREIGN KEY (idProduct) REFERENCES products(idProduct),
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

CREATE TABLE storageLocation (
    idProduct INT,
    idStorage INT,
    locationQuantity INT DEFAULT 0,
    PRIMARY KEY (idProduct, idStorage),
    FOREIGN KEY (idProduct) REFERENCES products(idProduct),
    FOREIGN KEY (idStorage) REFERENCES productStorage(idStorage)
);

alter table clients auto_increment = 1;

-- Inserindo dados de teste

-- Clientes
INSERT INTO clients (clientType, name, email, phone) VALUES
('PF', 'João Silva', 'joao.silva@email.com', '(11) 99999-1111'),
('PF', 'Maria Santos', 'maria.santos@email.com', '(11) 99999-2222'),
('PJ', 'Tech Solutions LTDA', 'contato@techsolutions.com', '(11) 3333-4444'),
('PF', 'Carlos Oliveira', 'carlos.oliveira@email.com', '(11) 99999-3333'),
('PJ', 'Global Import', 'vendas@globalimport.com', '(11) 5555-6666');

-- Clientes PF
INSERT INTO clientPF (idClient, cpf, birthDate) VALUES
(1, '12345678901', '1985-03-15'),
(2, '23456789012', '1990-07-22'),
(4, '34567890123', '1988-11-30');

-- Clientes PJ
INSERT INTO clientPJ (idClient, cnpj, companyName, stateRegistration) VALUES
(3, '12345678000195', 'Tech Solutions LTDA', '123.456.789.110'),
(5, '23456789000186', 'Global Import', '987.654.321.220');

-- Endereços
INSERT INTO addresses (idClient, street, number, complement, neighborhood, city, state, zipCode, addressType) VALUES
(1, 'Rua das Flores', '123', 'Apto 101', 'Centro', 'São Paulo', 'SP', '01234000', 'Residencial'),
(2, 'Av. Paulista', '1500', 'Sala 502', 'Bela Vista', 'São Paulo', 'SP', '01311000', 'Comercial'),
(3, 'Rua Augusta', '2000', NULL, 'Consolação', 'São Paulo', 'SP', '01304000', 'Comercial');

-- Produtos
INSERT INTO products (productName, description, category, price, rating) VALUES
('Smartphone Galaxy S20', 'Smartphone Android com 128GB', 'Eletrônicos', 1999.99, 4.5),
('Notebook Dell Inspiron', 'Notebook i5 8GB RAM 256GB SSD', 'Eletrônicos', 3499.99, 4.7),
('Camiseta Nike Dry-Fit', 'Camiseta esportiva tecnologia dry-fit', 'Roupas', 89.90, 4.3),
('Livro Dom Casmurro', 'Romance de Machado de Assis', 'Livros', 29.90, 4.8),
('Cafeteira Elétrica', 'Cafeteira 110V com timer digital', 'Casa', 159.90, 4.2);

-- Fornecedores
INSERT INTO suppliers (companyName, cnpj, contactName, email, phone) VALUES
('EletroTech Distribuidora', '11222333000144', 'Roberto Alves', 'vendas@eletrotech.com', '(11) 4444-5555'),
('Moda Brasil Fornecedor', '22333444000155', 'Ana Costa', 'compras@modabrasil.com', '(11) 6666-7777'),
('Livraria Cultural', '33444555000166', 'Paulo Mendes', 'contato@livrariacultural.com', '(11) 8888-9999');

-- Vendedores
INSERT INTO sellers (companyName, cpf, cnpj, contactName, email, phone, sellerType) VALUES
(NULL, '44555666777', NULL, 'Fernando Lima', 'fernando.lima@email.com', '(11) 77777-8888', 'PF'),
('TechStore Comércio', NULL, '44555666000177', 'Juliana Rocha', 'vendas@techstore.com', '(11) 3333-2222', 'PJ'),
(NULL, '55666777888', NULL, 'Ricardo Santos', 'ricardo.santos@email.com', '(11) 88888-9999', 'PF');

-- Estoque
INSERT INTO productStorage (location, quantity) VALUES
('Centro de Distribuição SP', 1000),
('Armazém Zona Norte', 500),
('CD Santos', 300);

-- Pedidos
INSERT INTO orders (idClient, orderStatus, orderDescription, totalAmount, orderDate, estimatedDeliveryDate) VALUES
(1, 'Confirmado', 'Pedido de eletrônicos', 2089.89, '2024-01-15 10:30:00', '2024-01-20'),
(2, 'Em processamento', 'Compra de livros e roupas', 119.80, '2024-01-16 14:20:00', '2024-01-22'),
(3, 'Confirmado', 'Compra corporativa', 3499.99, '2024-01-17 09:15:00', '2024-01-25'),
(1, 'Cancelado', 'Segundo pedido', 89.90, '2024-01-18 16:45:00', '2024-01-23');

-- Pagamentos
INSERT INTO payments (idOrder, paymentType, amount, paymentStatus, paymentDate, installments) VALUES
(1, 'Cartão', 2089.89, 'Aprovado', '2024-01-15 10:35:00', 3),
(2, 'PIX', 119.80, 'Pendente', NULL, 1),
(3, 'Boleto', 3499.99, 'Aprovado', '2024-01-17 09:20:00', 1);

-- Entregas
INSERT INTO deliveries (idOrder, trackingCode, deliveryStatus, shippingDate, deliveryDate, shippingCost, carrier) VALUES
(1, 'BR123456789SP', 'Em trânsito', '2024-01-16 08:00:00', NULL, 25.90, 'Correios'),
(3, 'BR987654321SP', 'Preparando', NULL, NULL, 45.90, 'Transportadora Express');

-- Relacionamentos
INSERT INTO productSupplier (idProduct, idSupplier, supplyPrice) VALUES
(1, 1, 1500.00),
(2, 1, 2800.00),
(3, 2, 60.00),
(4, 3, 18.00),
(5, 1, 110.00);

INSERT INTO productSeller (idProduct, idSeller, sellerPrice, sellerQuantity) VALUES
(1, 1, 1999.99, 5),
(2, 2, 3499.99, 3),
(3, 3, 89.90, 10),
(4, 1, 29.90, 20),
(5, 2, 159.90, 8);

INSERT INTO productOrder (idProduct, idOrder, quantity, unitPrice) VALUES
(1, 1, 1, 1999.99),
(5, 1, 1, 159.90),
(3, 2, 1, 89.90),
(4, 2, 1, 29.90),
(2, 3, 1, 3499.99),
(3, 4, 1, 89.90);

INSERT INTO storageLocation (idProduct, idStorage, locationQuantity) VALUES
(1, 1, 50),
(2, 1, 30),
(3, 2, 100),
(4, 3, 200),
(5, 1, 40);

-- Valor total de pedidos por cliente com informações de desconto hipotético
SELECT 
    c.name AS Cliente,
    COUNT(o.idOrder) AS 'Total de Pedidos',
    SUM(o.totalAmount) AS 'Valor Total',
    ROUND(SUM(o.totalAmount) * 0.1, 2) AS 'Desconto Potencial (10%)',
    CASE 
        WHEN SUM(o.totalAmount) > 1000 THEN 'Cliente Premium'
        ELSE 'Cliente Regular'
    END AS 'Categoria Cliente'
FROM clients c
LEFT JOIN orders o ON c.idClient = o.idClient
WHERE o.orderStatus != 'Cancelado' OR o.orderStatus IS NULL
GROUP BY c.idClient, c.name
ORDER BY SUM(o.totalAmount) DESC;

-- Clientes PJ que fizeram pedidos acima de R$ 2.000
SELECT 
    c.name AS Empresa,
    c.email,
    cj.cnpj,
    COUNT(o.idOrder) AS 'Qtd Pedidos',
    SUM(o.totalAmount) AS 'Valor Total'
FROM clients c
INNER JOIN clientPJ cj ON c.idClient = cj.idClient
INNER JOIN orders o ON c.idClient = o.idClient
WHERE o.orderStatus = 'Confirmado'
    AND o.totalAmount > 2000
GROUP BY c.idClient, c.name, c.email, cj.cnpj
HAVING COUNT(o.idOrder) >= 1
ORDER BY SUM(o.totalAmount) DESC;

-- Relação completa de pedidos com produtos, clientes e entregas
SELECT 
    o.idOrder AS 'Nº Pedido',
    c.name AS Cliente,
    CASE 
        WHEN c.clientType = 'PF' THEN pf.cpf
        WHEN c.clientType = 'PJ' THEN pj.cnpj
    END AS 'CPF/CNPJ',
    p.productName AS Produto,
    po.quantity AS Quantidade,
    po.unitPrice AS 'Preço Unitário',
    (po.quantity * po.unitPrice) AS 'Subtotal',
    o.totalAmount AS 'Total Pedido',
    d.deliveryStatus AS 'Status Entrega',
    d.trackingCode AS 'Código Rastreio',
    py.paymentType AS 'Forma Pagamento',
    py.paymentStatus AS 'Status Pagamento'
FROM orders o
INNER JOIN clients c ON o.idClient = c.idClient
LEFT JOIN clientPF pf ON c.idClient = pf.idClient AND c.clientType = 'PF'
LEFT JOIN clientPJ pj ON c.idClient = pj.idClient AND c.clientType = 'PJ'
INNER JOIN productOrder po ON o.idOrder = po.idOrder
INNER JOIN products p ON po.idProduct = p.idProduct
LEFT JOIN deliveries d ON o.idOrder = d.idOrder
LEFT JOIN payments py ON o.idOrder = py.idOrder
WHERE o.orderStatus != 'Cancelado'
ORDER BY o.orderDate DESC, o.idOrder;

-- Análise de margem de lucro por fornecedor e produto
SELECT 
    s.companyName AS Fornecedor,
    p.productName AS Produto,
    p.category AS Categoria,
    ps.supplyPrice AS 'Preço Fornecedor',
    AVG(ps2.sellerPrice) AS 'Preço Médio Venda',
    ROUND(AVG(ps2.sellerPrice) - ps.supplyPrice, 2) AS 'Margem Bruta',
    ROUND(((AVG(ps2.sellerPrice) - ps.supplyPrice) / ps.supplyPrice) * 100, 2) AS 'Margem %',
    SUM(sl.locationQuantity) AS 'Estoque Total'
FROM suppliers s
INNER JOIN productSupplier ps ON s.idSupplier = ps.idSupplier
INNER JOIN products p ON ps.idProduct = p.idProduct
INNER JOIN productSeller ps2 ON p.idProduct = ps2.idProduct
INNER JOIN storageLocation sl ON p.idProduct = sl.idProduct
GROUP BY s.idSupplier, p.idProduct, s.companyName, p.productName, p.category, ps.supplyPrice
HAVING AVG(ps2.sellerPrice) - ps.supplyPrice > 0
ORDER BY s.companyName, ((AVG(ps2.sellerPrice) - ps.supplyPrice) / ps.supplyPrice) DESC;

-- Identificando vendedores que também podem ser fornecedores
SELECT 
    'Vendedor/Fornecedor Potencial' AS Tipo,
    s.contactName AS Nome,
    s.companyName AS Empresa,
    COALESCE(s.cpf, s.cnpj) AS Documento,
    s.email,
    s.phone,
    COUNT(DISTINCT ps.idProduct) AS 'Produtos Vendidos',
    SUM(ps.sellerQuantity) AS 'Estoque Vendedor'
FROM sellers s
INNER JOIN productSeller ps ON s.idSeller = ps.idSeller
WHERE s.cnpj IN (SELECT cnpj FROM suppliers) 
    OR s.companyName IN (SELECT companyName FROM suppliers)
GROUP BY s.idSeller, s.contactName, s.companyName, s.cpf, s.cnpj, s.email, s.phone

UNION

-- Fornecedores que também podem ser vendedores
SELECT 
    'Fornecedor/Vendedor Potencial' AS Tipo,
    sup.contactName AS Nome,
    sup.companyName AS Empresa,
    sup.cnpj AS Documento,
    sup.email,
    sup.phone,
    COUNT(DISTINCT ps.idProduct) AS 'Produtos Fornecidos',
    SUM(sl.locationQuantity) AS 'Estoque Total'
FROM suppliers sup
INNER JOIN productSupplier ps ON sup.idSupplier = ps.idSupplier
INNER JOIN storageLocation sl ON ps.idProduct = sl.idProduct
WHERE sup.cnpj IN (SELECT cnpj FROM sellers WHERE sellerType = 'PJ')
    OR sup.companyName IN (SELECT companyName FROM sellers WHERE sellerType = 'PJ')
GROUP BY sup.idSupplier, sup.contactName, sup.companyName, sup.cnpj, sup.email, sup.phone;

-- Performance de vendas por categoria com métricas detalhadas
SELECT 
    p.category AS Categoria,
    COUNT(DISTINCT po.idOrder) AS 'Pedidos com Categoria',
    COUNT(DISTINCT po.idProduct) AS 'Produtos Vendidos',
    SUM(po.quantity) AS 'Total Itens Vendidos',
    ROUND(AVG(p.price), 2) AS 'Preço Médio Produto',
    MIN(p.price) AS 'Produto Mais Barato',
    MAX(p.price) AS 'Produto Mais Caro',
    SUM(po.quantity * po.unitPrice) AS 'Receita Total',
    ROUND(AVG(p.rating), 2) AS 'Avaliação Média',
    COUNT(DISTINCT s.idSeller) AS 'Vendedores Ativos'
FROM products p
INNER JOIN productOrder po ON p.idProduct = po.idOrder
INNER JOIN orders o ON po.idOrder = o.idOrder
INNER JOIN productSeller ps ON p.idProduct = ps.idProduct
INNER JOIN sellers s ON ps.idSeller = s.idSeller
WHERE o.orderStatus != 'Cancelado'
GROUP BY p.category
HAVING SUM(po.quantity * po.unitPrice) > 0
ORDER BY SUM(po.quantity * po.unitPrice) DESC;

-- Relação entre status de pagamento e entrega
SELECT 
    py.paymentStatus AS 'Status Pagamento',
    d.deliveryStatus AS 'Status Entrega',
    COUNT(o.idOrder) AS 'Quantidade Pedidos',
    ROUND(AVG(o.totalAmount), 2) AS 'Valor Médio Pedido',
    SUM(o.totalAmount) AS 'Valor Total',
    ROUND(AVG(DATEDIFF(COALESCE(d.deliveryDate, CURDATE()), o.orderDate)), 2) AS 'Dias Médios Entrega'
FROM orders o
LEFT JOIN payments py ON o.idOrder = py.idOrder
LEFT JOIN deliveries d ON o.idOrder = d.idOrder
WHERE o.orderStatus != 'Cancelado'
GROUP BY py.paymentStatus, d.deliveryStatus
ORDER BY py.paymentStatus, d.deliveryStatus;

-- Clientes que utilizam múltiplas formas de pagamento
SELECT 
    c.name AS Cliente,
    c.email,
    COUNT(DISTINCT py.paymentType) AS 'Formas Pagamento Diferentes',
    GROUP_CONCAT(DISTINCT py.paymentType) AS 'Tipos de Pagamento',
    COUNT(o.idOrder) AS 'Total Pedidos',
    SUM(o.totalAmount) AS 'Valor Total Gasto',
    MAX(o.orderDate) AS 'Última Compra'
FROM clients c
INNER JOIN orders o ON c.idClient = o.idClient
INNER JOIN payments py ON o.idOrder = py.idOrder
WHERE o.orderStatus != 'Cancelado'
GROUP BY c.idClient, c.name, c.email
HAVING COUNT(DISTINCT py.paymentType) > 1
ORDER BY COUNT(DISTINCT py.paymentType) DESC, SUM(o.totalAmount) DESC;


