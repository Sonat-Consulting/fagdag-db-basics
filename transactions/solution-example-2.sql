

--- First solution
-- Change table to only allow unique order_id
-- Perform
BEGIN;
select available from ice_cream_inventory where product_name='vanilla' for update;
-- If available is 0 or no row found, rollback and respond "nothing available"

insert into ice_cream_orders (order_id, restaurant, product_id, state, version)
values ('f846bd4e-3eed-4361-b7ba-5bb6a42e2557','Villani',1,1,1);

-- Update inventory
update ice_cream_inventory set available=available-1 where product_name='vanilla';

COMMIT;
-- On success, do nothing
-- On failure rollback then do.
BEGIN;
select restaurant,product_id,state,version from ice_cream_orders where order_id='f846bd4e-3eed-4361-b7ba-5bb6a42e2557';
-- If data is equal to input, do nothing
-- If not, log an error
COMMIT;




-- A different solution
-- Change table to only allow unique order_id
-- Perform
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE ;
select available from ice_cream_inventory where product_name='vanilla';
select restaurant,product_id,state,version from ice_cream_orders where order_id='f846bd4e-3eed-4361-b7ba-5bb6a42e2557';
-- if no rows insert and update inventory else check equality and do nothing or log
insert into ice_cream_orders (order_id, restaurant, product_id, state, version)
values ('f846bd4e-3eed-4361-b7ba-5bb6a42e2557','Villani',1,1,1);
update ice_cream_inventory set available=available-1 where product_name='vanilla';
COMMIT;
-- retry on Serialization failure





-- Another short and sweet solution
-- Change table to only allow unique order_id
-- Perform
BEGIN;
insert into ice_cream_orders (order_id, restaurant, product_id, state, version)
values ('f846bd4e-3eed-4361-b7ba-5bb6a42e2557','Villani',1,1,1);
update ice_cream_inventory set available=available-1 where product_name='vanilla' returning available;
-- if returned available is under 0 rollback and report "Not availabe"
COMMIT;

-- If unique constraint error on insert
BEGIN;
select restaurant,product_id,state,version from ice_cream_orders where order_id='f846bd4e-3eed-4361-b7ba-5bb6a42e2557';
-- If data is equal to input, do nothing
-- If not, log an error
COMMIT;