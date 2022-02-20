-- Inventory
create table ice_cream_inventory
(
    product_id bigint primary key generated always as identity,
    product_name varchar(30) unique not null,
    available int not null
);

insert into ice_cream_inventory (product_name, available) values ('vanilla',10);
insert into ice_cream_inventory (product_name, available) values ('lemon',100);
insert into ice_cream_inventory (product_name, available) values ('chocolate',10);
insert into ice_cream_inventory (product_name, available) values ('strawberry',50);


-- Order table
create table ice_cream_orders
(
    id bigint primary key generated always as identity,
    order_id varchar(40),
    restaurant varchar(40),
    product_id int not null references ice_cream_inventory (product_id),
    state int not null,
    version bigint not null
);

insert into ice_cream_orders (order_id, restaurant, product_id, state, version)
values ('f846bd4e-3eed-4361-b7ba-5bb6a42e2557','Villani',1,1,1);
insert into ice_cream_orders (order_id, restaurant, product_id, state, version)
values ('368399d1-45d0-467a-999b-554c58b210c3','Pastasentralen',1,1,1);