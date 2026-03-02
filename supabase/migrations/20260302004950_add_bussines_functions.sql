CREATE OR REPLACE FUNCTION get_total_stock(p_medicine_id BIGINT)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    total_stock INTEGER;
BEGIN
    SELECT COALESCE(SUM(quantity), 0)
    INTO total_stock
    FROM medicine_batches
    WHERE medicine_id = p_medicine_id;

    RETURN total_stock;
END;
$$;

CREATE OR REPLACE FUNCTION update_batch_price(
    p_batch_id BIGINT,
    p_new_price NUMERIC,
    p_changed_by VARCHAR
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_price NUMERIC;
BEGIN
    -- Obtener precio actual
    SELECT unit_price INTO v_old_price
    FROM medicine_batches
    WHERE id = p_batch_id;

    -- Actualizar precio
    UPDATE medicine_batches
    SET unit_price = p_new_price
    WHERE id = p_batch_id;

    -- Registrar auditoría
    INSERT INTO price_audit (
        batch_id,
        old_price,
        new_price,
        changed_by
    )
    VALUES (
        p_batch_id,
        v_old_price,
        p_new_price,
        p_changed_by
    );
END;
$$;