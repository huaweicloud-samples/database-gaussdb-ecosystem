-- ORA/A compatibility mode. Run in a dedicated test database as the test object owner.
-- This schema must not already exist. No existing objects are dropped automatically.
CREATE SCHEMA pkg_debug_demo;

CREATE TABLE pkg_debug_demo.demo_result (
    marker VARCHAR(40),
    quantity INTEGER,
    unit_price NUMERIC(12,2),
    amount NUMERIC(12,2)
);
