

--- First solution
-- Change table to only allow unique order_id
-- Perform
BEGIN;
insert into ice_cream_orders (order_id, restaurant, product_id, state, version)
values ('f846bd4e-3eed-4361-b7ba-5bb6a42e2557','Villani',1,1,1);
COMMIT;
-- On success, do nothing
-- On failure rollback (You can keep going in same tx under READ_COMMITED) and do
BEGIN;
select restaurant,product_id,state,version from ice_cream_orders where order_id='f846bd4e-3eed-4361-b7ba-5bb6a42e2557';
-- If data is equal to input, do nothing
-- If not, log an error
END;



-- A different solution
-- Change table to only allow unique order_id
-- Perform
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
select count(*) from ice_cream_orders where order_id='f846bd4e-3eed-4361-b7ba-5bb6a42e2557';
-- if count=0 (do insert)
insert into ice_cream_orders (order_id, restaurant, product_id, state, version)
values ('f846bd4e-3eed-4361-b7ba-5bb6a42e2557','Villani',1,1,1);
COMMIT;

-- retry on Serialization failure

