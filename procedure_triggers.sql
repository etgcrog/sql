DROP DATABASE MERCADINHO;
CREATE DATABASE MERCADINHO;

CREATE TABLE produto(
id int not null auto_increment primary key,
status char(1) not null default 'A',
descricao varchar(50) null default null,
estoque_minimo int null default null,
estoque_maximo int null default null);

CREATE TABLE entrada_produto(
id int auto_increment primary key,
id_produto int null default null,
quantidade int null default null,
valor_unitario decimal(9,2) null default 0.00,
data_entrada date null default null,
FOREIGN KEY (id_produto) REFERENCES produto (id));

CREATE TABLE estoque(
id int auto_increment primary key,
id_produto int null default null,
quantidade int null default null,
valor_unitario decimal(9,2) null default 0.00,
FOREIGN KEY (id_produto) REFERENCES produto (id));

CREATE TABLE saida_produto(
`id` int auto_increment primary key,
`id_produto` int null default null,
`quantidade` int null default null,
`valor_unitario` decimal(9,2) null default 0.00,
`data_saida` date null default null,
FOREIGN KEY (id_produto) REFERENCES produto (id));

insert into produto(status, descricao, estoque_minimo, estoque_maximo) values ('A', 'Mouse', 5, 100);
insert into produto(status, descricao, estoque_minimo, estoque_maximo) values ('I', 'Monitor', 7, 099);
insert into produto(status, descricao, estoque_minimo, estoque_maximo) values ('I', 'pendrive', 5, 1000);
insert into produto(status, descricao, estoque_minimo, estoque_maximo) values ('A', 'Caixa de som', 5, 50);
insert into produto(status, descricao, estoque_minimo, estoque_maximo) values ('I', 'Monitor', 7, 099);
insert into produto(status, descricao, estoque_minimo, estoque_maximo) values ('A', 'mousepad', 10, 20);
insert into produto(status, descricao, estoque_minimo, estoque_maximo) values  ('I','Memoria',10,100);

delimiter %%
	create procedure att_estoque(id_produto_procedure int, quantidade_comprada int, valor_unit decimal(9,2))
		begin
			declare contador int;
            select count(*) into contador from estoque where id_produto = id_produto_procedure;
            
            if contador > 0 then
				update estoque set quantidade = quantidade + quantidade_comprada, valor_unitario = valor_unit
					where id_produto = id_produto_procedure;
			else 
				insert into estoque (id_produto, quantidade, valor_unitario) values (id_produto_procedure, quantidade_comprada, valor_unit);
			end if;
		end;
%%

-- TRIGGERS  - BEFORE, AFTER
-- AI, AU, AD
	
DELIMITER $
	CREATE TRIGGER TGR_EntradaProduto_AI AFTER INSERT ON entrada_produto
		for each row
			begin
				call att_estoque(new.id_produto, new.quantidade, new.valor_unitario);
			end;
$

DELIMITER $
CREATE TRIGGER TGR_EntradaProduto_AU AFTER update ON entrada_produto
	for each row
		begin
			call att_estoque(new.id_produto, new.quantidade - old.quantidade, new.valor_unitario);
		end;
$

DELIMITER $
CREATE TRIGGER TGR_EntradaProduto_AD AFTER delete ON entrada_produto
	for each row
		begin
			call att_estoque(old.id_produto, old.quantidade * -1, old.valor_unitario);
		end;
$