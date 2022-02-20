
-- Testfil for oppgave 2
BEGIN;
update ice_cream_inventory set available=available-1 where product_id=1;
insert into ice_cream_orders (order_id, restaurant, product_id, state, version)
values ('f846bd4e-3eed-4361-b7ba-5bb6a42e2557','Villani',1,1,1);
COMMIT;