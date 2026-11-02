-- Select this entire CREATE PACKAGE statement and execute it as one statement.
CREATE PACKAGE pkg_debug_demo.demo_pkg AS
    FUNCTION calc_amount(p_qty IN INTEGER, p_price IN NUMERIC) RETURN NUMERIC;
    PROCEDURE build_result(p_qty IN INTEGER, p_price IN NUMERIC, p_amount OUT NUMERIC);
    PROCEDURE run_demo;
END demo_pkg;
