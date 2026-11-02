-- Run on a separate SQL connection after completing a debug session.
SELECT marker, quantity, unit_price, amount FROM pkg_debug_demo.demo_result;
-- Debug COMMIT: one additional row; debug ROLLBACK: no additional row.
-- Unchanged variables: 3 | 10.00 | 30.00. Set run_demo.v_qty=5 at BP1: 5 | 10.00 | 50.00.
