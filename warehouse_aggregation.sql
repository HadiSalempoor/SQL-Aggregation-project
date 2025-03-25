select 
   warehouse.warehouse_id,
   concat (warehouse.state, ":" , warehouse.warehouse_alias) as Warehouse_name,
   count(orders.order_id) as Number_of_orders,
   (select count(*) 
      From warehous_aggregation.orders) as total_orders,
    case 
        when count(orders.order_id)/(select count(*) 
      From warehous_aggregation.orders)<= 0.2
        then "fulfilled 0-20% of orders"
        when count(orders.order_id)/(select count(*) 
      From warehous_aggregation.orders)> 0.2
             and count(orders.order_id)/(select count(*) 
      From warehous_aggregation.orders)< 0.6
        Then "fulfilled 21% -60% of orders"   
        else "fulfilled more than 60% of orders"
        end as fullfillment_summary
From warehous_aggregation. warehouse As Warehouse
left join warehous_aggregation.orders as Orders
on orders.warehouse_id=warehouse.warehouse_id
group by warehouse.warehouse_id, Warehouse_name
having
 count(orders.order_id)>0
