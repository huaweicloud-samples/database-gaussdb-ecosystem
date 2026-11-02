-- Select this entire CREATE PACKAGE BODY statement and execute it as one statement.
CREATE PACKAGE BODY pkg_debug_demo.demo_pkg AS
    FUNCTION calc_amount(p_qty IN INTEGER, p_price IN NUMERIC) RETURN NUMERIC AS
        v_qty INTEGER := p_qty;
        v_price NUMERIC := p_price;
        v_amount NUMERIC := 0;
    BEGIN
        -- BP3: step over this statement, then inspect v_amount (expected 30).
        v_amount := v_qty * v_price;
        RETURN v_amount;
    END calc_amount;

    PROCEDURE build_result(p_qty IN INTEGER, p_price IN NUMERIC, p_amount OUT NUMERIC) AS
        v_middle_amount NUMERIC := 0;
    BEGIN
        -- BP2: step into calc_amount from here.
        v_middle_amount := calc_amount(p_qty, p_price);
        p_amount := v_middle_amount;
    END build_result;

    PROCEDURE run_demo AS
        v_qty INTEGER := 3;
        v_price NUMERIC := 10;
        v_amount NUMERIC := 0;
    BEGIN
        -- BP1: initial entry point; step into build_result from here.
        build_result(v_qty, v_price, v_amount);
        -- BP4: inspect v_amount (30, or 50 if v_qty was changed to 5 at BP1).
        INSERT INTO pkg_debug_demo.demo_result(marker, quantity, unit_price, amount)
        VALUES ('package-demo', v_qty, v_price, v_amount);
    END run_demo;
END demo_pkg;
