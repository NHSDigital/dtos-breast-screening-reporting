import sys
from unittest.mock import MagicMock

# Mock the dlt module before importing the pipeline so tests run locally
sys.modules["dlt"] = MagicMock()

import pytest
from pyspark.sql import SparkSession


@pytest.fixture(scope="session")
def spark():
    return (
        SparkSession.builder.master("local[1]")
        .appName("test_sales_pipeline")
        .getOrCreate()
    )


def test_placeholder(spark):
    """Placeholder — replace with tests for transformation logic in sales_pipeline.py."""
    df = spark.createDataFrame([(1, "a"), (2, "b")], ["id", "value"])
    assert df.count() == 2
