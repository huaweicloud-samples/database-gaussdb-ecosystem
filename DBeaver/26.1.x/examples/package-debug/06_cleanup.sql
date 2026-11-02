-- Optional destructive cleanup, ONLY for this example's objects after all debugging has ended.
-- Read and select these statements deliberately. No CASCADE is used.
DROP PACKAGE pkg_debug_demo.demo_pkg;
DROP TABLE pkg_debug_demo.demo_result;
DROP SCHEMA pkg_debug_demo RESTRICT;
