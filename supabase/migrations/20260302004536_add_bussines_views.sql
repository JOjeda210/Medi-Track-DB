CREATE VIEW view_medicine_stock AS
SELECT 
    m.id AS medicine_id,
    m.name,
    COALESCE(SUM(b.quantity), 0) AS total_stock,
    m.min_stock,
    CASE 
        WHEN COALESCE(SUM(b.quantity), 0) < m.min_stock THEN true
        ELSE false
    END AS is_low_stock
FROM medicines m
LEFT JOIN medicine_batches b 
    ON m.id = b.medicine_id
GROUP BY m.id, m.name, m.min_stock;

CREATE VIEW view_sales_detailed AS
SELECT 
    s.id AS sale_id,
    s.sale_date,
    c.name AS customer_name,
    m.name AS medicine_name,
    sd.quantity,
    sd.unit_price,
    sd.subtotal
FROM sales s
LEFT JOIN customers c ON s.customer_id = c.id
JOIN sale_details sd ON s.id = sd.sale_id
JOIN medicine_batches mb ON sd.batch_id = mb.id
JOIN medicines m ON mb.medicine_id = m.id;

CREATE VIEW view_active_delivery_orders AS
SELECT 
    d.id,
    c.name AS customer_name,
    dz.zone_name,
    d.address,
    d.order_date,
    d.status,
    d.total
FROM delivery_orders d
LEFT JOIN customers c ON d.customer_id = c.id
LEFT JOIN delivery_zones dz ON d.zone_id = dz.id
WHERE d.status IN ('pending', 'in_progress');