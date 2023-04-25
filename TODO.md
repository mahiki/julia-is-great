# TODO

## DUCKDB HIVE PARTITION READ/WRITE
[Looks like DuckDB can do it](https://duckdb.org/docs/extensions/httpfs#hive-partitioning), hive partition reads into column names, and filter pushdown.

```jl
s3://bucket/year=2012/file.parquet
s3://bucket/year=2013/file.parquet
s3://bucket/year=2014/file.parquet

sql = sql"""
SELECT * FROM parquet_scan('s3://bucket/*/file.parquet', HIVE_PARTITIONING = 1) where year=2013;
"""

sql"""
COPY table TO 's3://my-bucket/partitioned' (FORMAT PARQUET, PARTITION_BY (part_col_a, part_col_b), ALLOW_OVERWRITE TRUE);
"""

# another example
FROM read_parquet('s3://our_datalake/orders_dataset/region=*/order_date=*/product_line=*/*.parquet', HIVE_PARTITIONING = 1) as d
WHERE
    d.region = 1 and
    d.product_line = [22, 40, 121] and
    d.order_date >= '2022-01-01'
```
