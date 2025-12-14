# PySpark Interview Questions and Answers

## Basic Concepts (1-50)

### Q1. What is PySpark?
**Answer:**
PySpark is the Python API for Apache Spark, an open-source, distributed computing system used for big data processing and analytics. It allows Python developers to write Spark applications using Python, leveraging Spark's ability to process large datasets in parallel across clusters. It exposes the Spark programming model to Python.

**Explanation:**
Spark itself is written in Scala. PySpark provides a Python shell and library to interact with Spark. It supports most of Spark's features like Spark SQL, DataFrame, Streaming, MLlib (Machine Learning), and Spark Core.

### Q2. What are the key features of PySpark?
**Answer:**
Key features include:
1.  **In-Memory Computation:** Processes data in memory, making it much faster than disk-based processing like MapReduce.
2.  **Distributed Processing:** Parallel processing across a cluster of nodes.
3.  **Lazy Evaluation:** Transformations are not executed until an action is triggered.
4.  **Fault Tolerance:** Handles failures via RDD lineage.
5.  **Immutability:** Data abstraction (RDD) is immutable.
6.  **Rich Ecosystem:** specific libraries for SQL, Streaming, ML, Graph.

**Explanation:**
These features collectively make PySpark a powerful tool for big data. In-memory computation is often cited as 100x faster than MapReduce for certain tasks.

### Q3. What is an RDD in PySpark?
**Answer:**
RDD stands for Resilient Distributed Dataset. It is the fundamental data structure of Spark. It is an immutable distributed collection of objects. Each dataset in RDD is divided into logical partitions to be computed on different nodes of the cluster.

**Explanation:**
*   **Resilient:** Fault-tolerant, can rebuild lost data using lineage.
*   **Distributed:** Data resides on multiple nodes.
*   **Dataset:** Collection of data objects.

### Q4. Explain the difference between `map()` and `flatMap()`.
**Answer:**
*   `map(func)`: Returns a new RDD by applying a function to each element of the parent RDD. The number of elements remains the same. One-to-one mapping.
*   `flatMap(func)`: Similar to `map`, but each input item can be mapped to 0 or more output items (so `func` should return a Seq rather than a single item). One-to-many mapping.

**Explanation:**
If you have a list of sentences:
- `map` splitting by space would give a list of lists of words.
- `flatMap` splitting by space would give a single flattened list of all words.

### Q5. What is the difference between specific Transformations and Actions?
**Answer:**
*   **Transformations:** Operations on RDDs that return a new RDD (e.g., `map`, `filter`, `join`). They are lazy; execution doesn't happen immediately.
*   **Actions:** Operations that return a value to the driver program or write data to storage (e.g., `count`, `collect`, `saveAsTextFile`). They trigger the execution of the transformations.

**Explanation:**
Spark builds a DAG (Directed Acyclic Graph) of transformations and only executes when an action is called.

### Q6. What is Lazy Evaluation in PySpark?
**Answer:**
Lazy evaluation means that when we call a transformation on an RDD (like `map`), the operation is not immediately performed. Instead, Spark records the metadata (lineage) of operations. The actual computation happens only when an action (like `collect`) is invoked.

**Explanation:**
This allows Spark to optimize the execution plan (e.g., combining adjacent maps, filtering data early) before actually running it.

### Q7. What is a SparkContext?
**Answer:**
SparkContext is the entry point to any Spark functionality. It connects to the Spark Cluster Manager. It allows you to create RDDs, accumulators, and broadcast variables on the cluster. In PySpark, it is exposed as `sc`.

**Explanation:**
In newer Spark versions (2.0+), `SparkSession` encapsulates `SparkContext`, but `SparkContext` is still the underlying connection to the cluster.

### Q8. What is SparkSession?
**Answer:**
Introduced in Spark 2.0, SparkSession is the unified entry point for reading data, working with metadata, and configuring the session. It combines functionality of `SparkContext`, `SQLContext`, and `HiveContext`.

**Explanation:**
It simplifies interaction with Spark. You typically start a PySpark application by creating a `SparkSession` builder.

### Q9. Explain the concept of Lineage Graph in Spark.
**Answer:**
Lineage Graph (or RDD Operator Graph) acts as a recipe for RDDs. It keeps track of the dependencies between RDDs—how a child RDD is derived from parent RDDs.

**Explanation:**
This is crucial for fault tolerance. If a partition of an RDD is lost, Spark uses the lineage to recompute just that partition from the original data or parent RDDs, rather than re-running the entire job.

### Q10. What are Broadcast Variables?
**Answer:**
Broadcast variables read-only shared variables that are cached and available on all nodes in a cluster in-memory. They are used to send a large, read-only lookup table to all worker nodes efficiently.

**Explanation:**
Instead of shipping a copy of the variable with every task, Spark distributes it once to each machine.

### Q11. What are Accumulators?
**Answer:**
Accumulators are variables that are only "added" to through an associative and commutative operation. They are used to implement counters or sums efficiently in parallel.

**Explanation:**
Spark natively supports numeric accumulators. Only the driver can read the value of an accumulator, not the tasks.

### Q12. What is a DAGScheduler?
**Answer:**
The DAGScheduler is the scheduling layer of Spark that implements stage-oriented scheduling. It computes a DAG of stages for each job, keeps track of which RDDs and stage outputs are materialized, and finds a minimal schedule to run the job.

**Explanation:**
It breaks the logical graph of RDD operations into physical stages based on shuffle boundaries.

### Q13. distinguish between `reduceByKey()` and `groupByKey()`.
**Answer:**
*   `reduceByKey()`: Combines values with the same key *locally* on each mapper before sending results to the reducer. This reduces network traffic (shuffling).
*   `groupByKey()`: Shuffles all the values for each key across the network to form an iterable. This causes heavy network traffic and can lead to OOM errors if a key has many values.

**Explanation:**
`reduceByKey` is generally preferred for performance due to the map-side combine optimization.

### Q14. What are the different cluster managers supported by PySpark?
**Answer:**
1.  **Standalone:** A simple cluster manager included with Spark.
2.  **Apache Mesos:** A general cluster manager that can also run Hadoop MapReduce.
3.  **Hadoop YARN:** The resource manager in Hadoop 2.
4.  **Kubernetes:** An open-source system for automating deployment, scaling, and management of containerized applications.

**Explanation:**
"Local" mode is also available for running on a single machine, suitable for testing.

### Q15. How do you create an RDD in PySpark?
**Answer:**
1.  **Parallelizing a collection:** `sc.parallelize([1, 2, 3])`
2.  **Loading an external dataset:** `sc.textFile("path/to/file")`
3.  **From existing RDDs:** Applying transformations like `map`, `filter`.

**Explanation:**
`parallelize` is mostly used for testing/prototyping. `textFile` is used for production data loading from HDFS, S3, etc.

### Q16. What is a DataFrame in PySpark?
**Answer:**
A DataFrame is a distributed collection of data organized into named columns. It is equivalent to a table in a relational database or a data frame in Python/R, but with richer optimizations under the hood.

**Explanation:**
DataFrames are built on top of RDDs but generally provide higher performance due to the Catalyst Optimizer.

### Q17. What is the Catalyst Optimizer?
**Answer:**
The Catalyst Optimizer is the core query optimization engine in Spark SQL. It automatically optimizes the execution plan of DataFrame and Dataset operations.

**Explanation:**
It performs steps like analysis, logical optimization, physical planning, and code generation to run queries efficiently.

### Q18. How do you read a CSV file in PySpark?
**Answer:**
Using `spark.read.csv()`:
```python
df = spark.read.csv("path/to/file.csv", header=True, inferSchema=True)
```

**Explanation:**
`header=True` uses the first line as column names. `inferSchema=True` attempts to automatically guess column data types (int, double, etc.).

### Q19. Difference between `repartition()` and `coalesce()`.
**Answer:**
*   `repartition(n)`: Increases or decreases the number of partitions. It performs a full shuffle of data across the network.
*   `coalesce(n)`: Decreases the number of partitions. It avoids a full shuffle by merging existing partitions, making it improved for reducing partition count.

**Explanation:**
Use `coalesce` when reducing partitions (e.g., before writing to a file). Use `repartition` when you need to increase parallelism or fix skewed data.

### Q20. What is Action `collect()`?
**Answer:**
`collect()` retrieves all the elements of the RDD/DataFrame from the worker nodes to the driver program.

**Explanation:**
It should be used with caution. If the result set is larger than the driver's memory, it will cause an OutOfMemoryError. Usually used for small results or debugging.

### Q21. What is shuffling in Spark?
**Answer:**
Shuffling is the process of redistributing data across partitions (and typically across nodes) so that data with the same key ends up in the same partition. This occurs during operations like `groupByKey`, `reduceByKey`, `join`.

**Explanation:**
Shuffling involves disk I/O, network data transfer, and serialization, making it an expensive operation.

### Q22. How to cache data in PySpark?
**Answer:**
Using `.cache()` or `.persist()`.
*   `df.cache()`: Persists data in memory (MEMORY_AND_DISK storage level by default for DataFrames in newer versions, MEMORY_ONLY for RDDs).
*   `df.persist(StorageLevel)`: Allows specifying custom storage levels (e.g., MEMORY_ONLY, DISK_ONLY, MEMORY_AND_DISK_SER).

**Explanation:**
Caching is useful when an RDD/DataFrame is accessed multiple times in an application (e.g., iterative algorithms like K-Means).

### Q23. What are the storage levels in Spark?
**Answer:**
*   `MEMORY_ONLY`: Store RDD as deserialized Java objects in JVM. (Default for RDDs)
*   `MEMORY_AND_DISK`: Store in memory; if full, spill to disk.
*   `DISK_ONLY`: Store only on disk.
*   `MEMORY_ONLY_SER`: Store as serialized Java objects (more space-efficient, CPU intensive).
*   `OFF_HEAP`: Experimental.

**Explanation:**
The default for DataFrames is `MEMORY_AND_DISK`.

### Q24. Explain the `filter()` transformation.
**Answer:**
`filter(func)` returns a new RDD/DataFrame containing only the elements that satisfy the condition (where `func` returns true).

**Explanation:**
Example: `rdd.filter(lambda x: x > 10)` keeps numbers greater than 10.

### Q25. What is the difference between client and cluster mode?
**Answer:**
*   **Client Mode:** The driver runs on the machine where you submit the job (e.g., your laptop or an edge node). If that machine dies, the job dies.
*   **Cluster Mode:** The driver runs inside the cluster (on one of the worker nodes) as a managed process.

**Explanation:**
Cluster mode is preferred for production jobs to decouple the job lifetime from the submission client.

### Q26. What is a "stage" in Spark?
**Answer:**
A stage is a set of parallel tasks that can be computed with the same logic and without a full shuffle. Spark splits the job into stages at shuffle boundaries.

**Explanation:**
Operations like `map` and `filter` are pipelined into a single stage. Operations like `reduceByKey` introduce a shuffle, starting a new stage.

### Q27. What is a "task" in Spark?
**Answer:**
A task is the smallest unit of work in Spark. A stage is divided into tasks, one for each partition of the data. A task is executed by a single core on a worker node.

**Explanation:**
If an RDD has 10 partitions, the stage processing will ideally spawn 10 parallel tasks.

### Q28. What is the difference between RDD and DataFrame?
**Answer:**
*   **RDD:** Low-level API, no schema, manually optimized, good for unstructured data.
*   **DataFrame:** High-level API, has schema (columns/types), optimized by Catalyst, usually faster for structured data.

**Explanation:**
DataFrames use an internal row object format that is more efficient than Java serialization used by RDDs.

### Q29. How to view the schema of a DataFrame?
**Answer:**
Using `df.printSchema()`.

**Explanation:**
It prints the tree structure of the schema (column names, types, nullable status) to the console.

### Q30. What is `join()` in PySpark?
**Answer:**
`join()` merges two RDDs or DataFrames based on a key or condition.
In RDDs: `rdd1.join(rdd2)` performs an inner join on (K, V) and (K, W) producing (K, (V, W)).

**Explanation:**
There are various types: inner, outer, left_outer, right_outer, etc.

### Q31. What is `union()`?
**Answer:**
`union()` returns a new RDD/DataFrame containing elements from source and the argument RDD/DataFrame. It effectively appends data.

**Explanation:**
Does not remove duplicates (unlike standard SQL UNION). Use `distinct()` to remove duplicates after union if needed.

### Q32. What is `distinct()`?
**Answer:**
`distinct()` returns a new RDD/DataFrame containing the distinct elements of the source.

**Explanation:**
It involves a shuffle to identify duplicates globally.

### Q33. How does Spark handle faults?
**Answer:**
Spark uses RDD lineage to handle faults. If a worker node fails and a partition is lost, the driver finds the lost partition in the lineage graph and re-launches tasks to recompute it on another node.

**Explanation:**
This essentially "replays" the transformation steps for the missing data chunk.

### Q34. What is the driver program?
**Answer:**
The driver program is the process running the main() function of the application and creating the SparkContext.

**Explanation:**
It coordinates the execution: translates RDD operations into a DAG, schedules stages/tasks via the Cluster Manager, and collects results.

### Q35. What are Worker Nodes?
**Answer:**
Worker nodes are machines in the cluster that run the application code in the cluster.

**Explanation:**
They report available resources to the cluster manager and launch "Executors" to run tasks.

### Q36. What is an Executor?
**Answer:**
An Executor is a process launched on a worker node for an application. It runs tasks and keeps data in memory or disk storage across them.

**Explanation:**
Each application has its own set of executors.

### Q37. Diff between `mapPartitions()` and `map()`.
**Answer:**
*   `map()`: Applies function to each element. Function is called N times for N elements.
*   `mapPartitions()`: Applies function to each partition (iterator). Function is called once per partition.

**Explanation:**
`mapPartitions` is more efficient for heavy initialization (e.g., opening a DB connection) because you can do it once per partition instead of once per record.

### Q38. What is `foreach()`?
**Answer:**
`foreach(func)` is an action that applies a function to each element of the dataset.

**Explanation:**
It is usually used to perform side effects like pushing data to an external database. Note that the function runs on the worker, not the driver.

### Q39. Explain `take(n)`.
**Answer:**
`take(n)` runs an action to return the first `n` elements of the RDD/DataFrame to the driver.

**Explanation:**
Unlike `collect`, it doesn't return the whole dataset, avoiding memory issues for large data.

### Q40. What is UDF (User Defined Function)?
**Answer:**
UDF allows you to register a custom Python function to be used in Spark SQL or DataFrame queries.

**Explanation:**
```python
from pyspark.sql.functions import udf
square_udf = udf(lambda x: x*x)
df.select(square_udf(df.col))
```
Use cautiously as standard Spark SQL functions are often more optimized.

### Q41. How to drop duplicate rows in a DataFrame?
**Answer:**
Using `df.dropDuplicates()` or `df.drop_duplicates()`.

**Explanation:**
You can optionally specify a subset of columns to consider for checking duplicates: `df.dropDuplicates(['col1'])`.

### Q42. How to rename a column in a DataFrame?
**Answer:**
Using `withColumnRenamed()`:
```python
new_df = df.withColumnRenamed("old_name", "new_name")
```

**Explanation:**
This returns a new DataFrame with the column renamed.

### Q43. How to add a new column to a DataFrame?
**Answer:**
Using `withColumn()`:
```python
new_df = df.withColumn("new_col", df["old_col"] * 2)
```

**Explanation:**
This returns a new DataFrame with the new column added.

### Q44. What is `PySpark SQL`?
**Answer:**
Spark SQL is a Spark module for structured data processing. It allows you to query data via SQL or the DataFrame API.

**Explanation:**
It provides a common way to access a variety of data sources (Hive, Avro, Parquet, ORC, JSON, JDBC).

### Q45. What is a Parquet file?
**Answer:**
Parquet is a columnar storage file format. Spark is highly optimized for Parquet. It supports schema evolution and compression.

**Explanation:**
It is the default file format for Spark SQL. It saves storage space and speeds up queries by reading only required columns.

### Q46. Difference between `sample()` and `takeSample()`.
**Answer:**
*   `sample(withReplacement, fraction, seed)`: Transformation. Returns a sampled RDD (approximate size).
*   `takeSample(withReplacement, num, seed)`: Action. Returns a fixed-size sample list to the driver.

**Explanation:**
`takeSample` collects data to driver, so keep the sample size small.

### Q47. What is `pipe()`?
**Answer:**
`pipe()` is an RDD transformation that pipes the contents of each partition through an external command (like a shell script or C helper) and returns the output as an RDD of strings.

**Explanation:**
Useful for leveraging legacy code or non-JVM tools.

### Q48. What is `zip()`?
**Answer:**
`zip()` zips two RDDs together. `rdd1.zip(rdd2)` returns an RDD of pairs.

**Explanation:**
Both RDDs must have the same number of partitions and the same number of elements in each partition.

### Q49. What is Serialization in Spark?
**Answer:**
Serialization is converting objects into a binary format for network transfer or disk storage.

**Explanation:**
PySpark mainly uses `Pickle` for serializing Python objects. Java/Scala Spark uses Java serialization or Kryo.

### Q50. How to stop a SparkSession?
**Answer:**
Using `spark.stop()`.

**Explanation:**
It releases resources (executors, listeners) held by the Spark application.

## RDDs & DataFrames (51-100)

### Q51. What is the difference between `GroupByKey` in RDD and `groupBy` in DataFrame?
**Answer:**
*   `RDD.groupByKey`: Groups values for each key into a sequence. It involves shuffling all data across the network, which can be inefficient for large datasets.
*   `DataFrame.groupBy`: Used with aggregation functions (e.g., `df.groupBy("col").count()`). It uses the Catalyst optimizer to perform optimized aggregations, often pushing down predicates or using partial aggregations (combiners) to reduce shuffle data.

**Explanation:**
DataFrame `groupBy` is generally much faster than RDD `groupByKey` because of the optimizer and Tungsten execution engine.

### Q52. Explain `aggregateByKey()` in PySpark.
**Answer:**
`aggregateByKey(zeroValue, seqOp, combOp)` aggregates the values of each key using two functions and a neutral "zero value".
*   `seqOp`: Merges values within a partition (acts like map-side combine).
*   `combOp`: Merges results from different partitions (reduce-side).

**Explanation:**
It is more efficient than `groupByKey` because it computes partial results locally before shuffling.

### Q53. What is `foldByKey()`?
**Answer:**
`foldByKey(zeroValue, func)` is a variation of `aggregateByKey` where the `seqOp` and `combOp` are the same. It aggregates the values of each key using an associative function and a zero value.

**Explanation:**
Similar to `reduceByKey` but allows providing a zero value.

### Q54. What is `glom()`?
**Answer:**
`glom()` transforms an RDD by coalescing all elements within each partition into a list. It returns an RDD of lists, where each list contains all elements of a specific partition.

**Explanation:**
Useful when you need to process a whole partition at once (e.g., specific heavy initialization per partition) or inspect partition contents.

### Q55. How do you convert an RDD to a DataFrame?
**Answer:**
1.  **Using `toDF()`:** `rdd.toDF(["col1", "col2"])`
2.  **Using `spark.createDataFrame()`:** `spark.createDataFrame(rdd, schema)`

**Explanation:**
If the RDD contains Row objects or tuples, Spark can infer the schema. Using `createDataFrame` allows specifying a strict schema (StructType).

### Q56. How do you convert a DataFrame to an RDD?
**Answer:**
Using the `.rdd` property: `df.rdd`.

**Explanation:**
It returns an RDD of `Row` objects. You might lose some of the optimizations present in DataFrames by forcing conversion to RDD.

### Q57. What is `Row` in PySpark?
**Answer:**
`Row` is a generic row object used in DataFrames. It can be accessed like a dictionary or an object (e.g., `row.field` or `row['field']`).

**Explanation:**
When converting DataFrame to RDD, the elements are `Row` objects.

### Q58. Explain `explode()` function.
**Answer:**
`explode()` is a function used to flatten an array or map column. It creates a new row for each element in the given array or map column.

**Explanation:**
If a row has `[1, 2]` in column `A`, `explode(A)` will generate two rows: one with `1` and one with `2`.

### Q59. What is `pivot()` in PySpark?
**Answer:**
`pivot()` is used to rotate data from one column into multiple columns (transposing row values to columns). It is typically used after `groupBy`.

**Explanation:**
`df.groupBy("A").pivot("B").sum("C")` makes distinct values of "B" into new columns.

### Q60. What is `rollup()`?
**Answer:**
`rollup()` is an extension of `groupBy` that calculates subtotals and a grand total for the grouped columns, moving from right to left.

**Explanation:**
`df.rollup("A", "B").sum("C")` calculates sum for (A, B), then (A, null), then (null, null).

### Q61. What is `cube()`?
**Answer:**
`cube()` is similar to `rollup` but calculates subtotals for *all combinations* of the grouping columns.

**Explanation:**
`df.cube("A", "B").sum("C")` calculates sum for (A, B), (A, null), (null, B), and (null, null).

### Q62. How to handle missing values (NULLs) in DataFrame?
**Answer:**
Using the `DataFrameNaFunctions` accessed via `df.na`:
*   `df.na.drop()`: Remove rows with nulls.
*   `df.na.fill(value)`: Replace nulls with specific value.
*   `df.na.replace()`: Replace specific values.

**Explanation:**
You can specify `how='any'` or `'all'`, and subset of columns.

### Q63. What is `approxQuantile()`?
**Answer:**
It calculates the approximate quantiles (percentiles) of a numerical column.

**Explanation:**
Useful for understanding data distribution without a full sort, which is expensive.

### Q64. distinguish between `orderBy()` and `sort()`.
**Answer:**
In PySpark DataFrames, `orderBy()` and `sort()` are synonyms. They both sort the DataFrame by one or more columns.

**Explanation:**
They trigger a global sort, which involves a shuffle unless `sortWithinPartitions` is used.

### Q65. What is `sortWithinPartitions()`?
**Answer:**
It sorts the data within each partition locally, without causing a global shuffle.

**Explanation:**
Faster than `sort()` if global ordering isn't required, or as a pre-step to other operations.

### Q66. What is `monotonically_increasing_id()`?
**Answer:**
A function that generates unique, monotonically increasing 64-bit integers. The generated IDs are guaranteed to be unique and increasing, but not consecutive.

**Explanation:**
Useful for assigning a unique ID to each row efficiently without a global lock.

### Q67. How to use SQL queries on a DataFrame?
**Answer:**
First, register the DataFrame as a temporary view using `df.createOrReplaceTempView("table_name")`. Then use `spark.sql("SELECT * FROM table_name")`.

**Explanation:**
This allows mixing DataFrame API and raw SQL in the same application.

### Q68. What is the difference between `createTempView` and `createGlobalTempView`?
**Answer:**
*   `createTempView`: The view is valid only within the current SparkSession. If the session terminates, the view disappears.
*   `createGlobalTempView`: The view is shared across all SparkSessions in the application and is kept alive until the application terminates.

**Explanation:**
Global temp views are stored in the `global_temp` database (e.g., `SELECT * FROM global_temp.view1`).

### Q69. What is a UDAF?
**Answer:**
User Defined Aggregate Function (UDAF) allows you to define custom aggregation logic (like weighted average) to use with `groupBy`.

**Explanation:**
In PySpark, UDAFs were historically slower/harder to implement than Scala, but Pandas UDFs in newer versions make them efficient.

### Q70. What are Pandas UDFs (Vectorized UDFs)?
**Answer:**
Introduced in Spark 2.3, Pandas UDFs use Apache Arrow to transfer data and Pandas to work with data, providing much higher performance than standard row-at-a-time Python UDFs.

**Explanation:**
They allow you to write functions that take pandas Series as input and output pandas Series, operating on batches of rows.

### Q71. How to get the summary statistics of a DataFrame?
**Answer:**
Using `df.describe()`.

**Explanation:**
It computes count, mean, stddev, min, and max for numeric columns.

### Q72. What is `corr()` function?
**Answer:**
Calculates the Pearson Correlation Coefficient between two columns.

**Explanation:**
`df.stat.corr("col1", "col2")`.

### Q73. What is `cov()` function?
**Answer:**
Calculates the sample covariance for two columns.

**Explanation:**
`df.stat.cov("col1", "col2")`.

### Q74. How to perform a Left Outer Join?
**Answer:**
`df1.join(df2, on="key", how="left")` or `how="left_outer"`.

**Explanation:**
Returns all rows from the left DataFrame and matched rows from the right DataFrame.

### Q75. What is a Broadcast Join?
**Answer:**
A join optimization where the smaller DataFrame is broadcasted (sent to all nodes) to avoid shuffling the larger DataFrame.

**Explanation:**
Spark automatically uses it if a table is smaller than `spark.sql.autoBroadcastJoinThreshold`. You can force it using `broadcast(df)`.

### Q76. How to force a Broadcast Join?
**Answer:**
```python
from pyspark.sql.functions import broadcast
df_large.join(broadcast(df_small), "key")
```

**Explanation:**
Helps avoid data skew and huge shuffles when one table is small.

### Q77. What is `window` function in PySpark?
**Answer:**
Window functions allow you to calculate results (like rank, moving average) over a sliding window of data (a set of rows related to the current row).

**Explanation:**
Defined using `Window.partitionBy(...).orderBy(...)`.

### Q78. Explain `rank()` vs `dense_rank()`.
**Answer:**
*   `rank()`: Skips ranks if there are ties (e.g., 1, 1, 3).
*   `dense_rank()`: Does not skip ranks (e.g., 1, 1, 2).

**Explanation:**
Used within a Window spec.

### Q79. What is `row_number()`?
**Answer:**
Assigns a unique sequential number to each row, starting at 1, within a window partition.

**Explanation:**
Useful for handling duplicates (e.g., keeping only row_number=1).

### Q80. How to calculate a running total?
**Answer:**
Using `sum()` over a window ordered by time/sequence.
```python
w = Window.orderBy("time")
df.withColumn("running_total", sum("amount").over(w))
```

**Explanation:**
Unbounded preceding is implied if not specified explicitly with range.

### Q81. What is `lag()` and `lead()`?
**Answer:**
*   `lag(col, n)`: Accesses the value from `n` rows before the current row.
*   `lead(col, n)`: Accesses the value from `n` rows after the current row.

**Explanation:**
Useful for calculating differences between consecutive events.

### Q82. What is `toJSON()`?
**Answer:**
Converts a DataFrame into an RDD of JSON strings (one for each row).

**Explanation:**
Useful for exporting data to systems that expect JSON.

### Q83. What is `struct()` function?
**Answer:**
Creates a new struct column (Row) from other columns.

**Explanation:**
`df.select(struct("col1", "col2").alias("new_struct"))`. Creates a nested column.

### Q84. What is `array()` function?
**Answer:**
Creates a new array column from multiple columns.

**Explanation:**
`df.select(array("col1", "col2"))`. All inputs must have the same data type.

### Q85. How to flatten a nested dataframe?
**Answer:**
By selecting the nested fields using dot notation (`col.field`).

**Explanation:**
`df.select("student.name", "student.age")`.

### Q86. What is methods to write a DataFrame to Hive?
**Answer:**
`df.write.saveAsTable("table_name")`.

**Explanation:**
This creates a managed or external Hive table depending on configuration.

### Q87. How to control the number of files generated when writing?
**Answer:**
By controlling the number of partitions using `repartition(n)` or `coalesce(n)` before writing.

**Explanation:**
`df.repartition(1).write.csv(...)` writes a single CSV file.

### Q88. What is partitioning in Hive/File output?
**Answer:**
`df.write.partitionBy("col").parquet("path")`.
It stores data in subdirectories like `col=value1/`, `col=value2/`.

**Explanation:**
Improves read performance for queries filtering on the specific column (partition pruning).

### Q89. What is Bucketing?
**Answer:**
Bucketing distributes data across a fixed number of buckets (files) by hashing the bucket column.
`df.write.bucketBy(n, "col").saveAsTable("table")`.

**Explanation:**
Useful for efficient joins on the bucketed column (Join elimination/Bucketed Join).

### Q90. Difference between Partitioning and Bucketing.
**Answer:**
*   **Partitioning:** Creates directory structure. Good for low-cardinality columns (e.g., date, country). Can create too many small files if cardinality is high.
*   **Bucketing:** Creates fixed number of files. Good for high-cardinality columns (e.g., ID).

**Explanation:**
They can be used together.

### Q91. What is `pyspark.sql.functions`?
**Answer:**
A module containing a huge list of built-in functions for DataFrame operations (e.g., `col`, `lit`, `sum`, `avg`, `to_date`, `regexp_extract`).

**Explanation:**
Usually imported as `F`: `import pyspark.sql.functions as F`.

### Q92. What is `lit()`?
**Answer:**
Creates a Column of literal value.

**Explanation:**
`df.withColumn("const", lit(10))`. Adds a column with value 10 for all rows.

### Q93. How to check if a column contains a string?
**Answer:**
Using `contains()` method on a Column.
`df.filter(col("name").contains("John"))`.

**Explanation:**
Similar to SQL `LIKE '%John%'`.

### Q94. How to convert a String column to Date?
**Answer:**
Using `to_date()` or `to_timestamp()`.
`df.withColumn("date", to_date("date_str", "yyyy-MM-dd"))`.

**Explanation:**
Requires specifying the format if it's not standard.

### Q95. What is `when().otherwise()`?
**Answer:**
Conditional logic, similar to SQL CASE WHEN.
```python
df.withColumn("status", when(col("age") > 18, "Adult").otherwise("Minor"))
```

**Explanation:**
Can chain multiple `when` clauses.

### Q96. How to cache a table in Spark SQL?
**Answer:**
`spark.sql("CACHE TABLE table_name")`.

**Explanation:**
Caches the table in memory. `UNCACHE TABLE table_name` removes it.

### Q97. Explain `schema` enforcement.
**Answer:**
When reading data (like CSV/JSON), Spark can either infer schema (expensive) or usage a user-defined schema (fast, safer). If data doesn't match the defined schema, it handles it based on mode (PERMISSIVE, DROPMALFORMED, FAILFAST).

**Explanation:**
Production jobs should usually define schema explicitly.

### Q98. What are the read modes in Spark?
**Answer:**
*   `PERMISSIVE` (default): Sets null for corrupted fields, puts malformed record in `_corrupt_record`.
*   `DROPMALFORMED`: Drops rows with malformed records.
*   `FAILFAST`: Throws exception immediately upon seeing malformed data.

**Explanation:**
Configured via `.option("mode", "FAILFAST")`.

### Q99. How to get the execution plan?
**Answer:**
Using `df.explain()`.

**Explanation:**
`df.explain(True)` or `df.explain(mode="extended")` shows Parsed, Analyzed, Optimized, and Physical plans.

### Q100. What is RDD `checkpoint()`?
**Answer:**
`checkpoint()` truncates the RDD lineage by saving the RDD to a reliable distributed file system (like HDFS).

**Explanation:**
Unlike `cache()`, it breaks the lineage. Useful for very long lineages to avoid StackOverflowError during recovery.
