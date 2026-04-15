import dlt
from pyspark.sql.functions import col, to_date
from pyspark.sql.types import (
    StructType,
    StructField,
    IntegerType,
    StringType,
    FloatType,
    TimestampType,
)

# Schema names are injected via pipeline configuration so that per-dev deploys
# write to isolated schemas (e.g. bronze_samwalsh) while CI/prod use the
# canonical names (bronze, silver, gold).
bronze_schema = spark.conf.get("pipeline.bronze_schema")
silver_schema = spark.conf.get("pipeline.silver_schema")
gold_schema = spark.conf.get("pipeline.gold_schema")


# ---------------------------------------------------------------------------
# BRONZE — Ingest raw CSV files from ADLS using Auto Loader
# New files landing in the raw container are picked up incrementally
# ---------------------------------------------------------------------------
@dlt.table(
    name=f"{bronze_schema}.sales_bronze",
    comment="Raw sales data ingested from ADLS Gen2 via Auto Loader",
)
def sales_bronze():
    schema = StructType(
        [
            StructField("order_id", IntegerType(), True),
            StructField("customer_name", StringType(), True),
            StructField("region", StringType(), True),
            StructField("amount", FloatType(), True),
            StructField("order_date", TimestampType(), True),
        ]
    )
    return (
        spark.readStream.format("cloudFiles")
        .option("cloudFiles.format", "csv")
        .option(
            "cloudFiles.schemaLocation",
            "abfss://raw@bsrtestdatalake.dfs.core.windows.net/checkpoints/sales/schema",
        )
        .option("header", "true")
        .schema(schema)
        .load("abfss://raw@bsrtestdatalake.dfs.core.windows.net/sales/")
    )


# ---------------------------------------------------------------------------
# SILVER — Clean, validate, and deduplicate
# Bad rows (null order_id, non-positive amount) are dropped
# ---------------------------------------------------------------------------
@dlt.table(
    name=f"{silver_schema}.sales_silver",
    comment="Cleaned and validated sales data",
)
@dlt.expect_or_drop("valid_order_id", "order_id IS NOT NULL")
@dlt.expect_or_drop("positive_amount", "amount > 0")
def sales_silver():
    return (
        dlt.read_stream(f"{bronze_schema}.sales_bronze")
        .withColumn("order_date", to_date(col("order_date")))
        .withColumn("amount", col("amount").cast("double"))
        .dropDuplicates(["order_id"])
    )


# ---------------------------------------------------------------------------
# GOLD — Aggregate for reporting
# Batch read from silver (no longer streaming at this layer)
# ---------------------------------------------------------------------------
@dlt.table(
    name=f"{gold_schema}.sales_by_region",
    comment="Total sales and order count aggregated by region",
)
def sales_by_region():
    return (
        dlt.read(f"{silver_schema}.sales_silver")
        .groupBy("region")
        .agg({"amount": "sum", "order_id": "count"})
        .withColumnRenamed("sum(amount)", "total_amount")
        .withColumnRenamed("count(order_id)", "order_count")
    )
