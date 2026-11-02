-- Normal execution smoke test: run each statement in order, outside a debug session.
-- Use a clean test connection with no pending work: ROLLBACK applies to its entire transaction.
BEGIN;
CALL pkg_debug_demo.demo_pkg.run_demo();
SELECT marker, quantity, unit_price, amount FROM pkg_debug_demo.demo_result;
-- Expected newly inserted row: package-demo | 3 | 10.00 | 30.00
ROLLBACK;
-- The newly inserted row must be absent. Any previously committed rows remain.
SELECT marker, quantity, unit_price, amount FROM pkg_debug_demo.demo_result;
