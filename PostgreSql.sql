-- 比较运算符 <> 不等于

-- COUNT函数的结果根据参数的不同而不同。COUNT(*)会得到包含NULL的数据行数，而COUNT(<列名>)会得到NULL之外的数据行数。

-- 计算全部数据的行数, 包含NULL值
select count(*) from table_name;

-- 计算 NULL 之外的数据行数，指定列名
select count(price) from table_name;

-- COUNT(*), 只有 SELECT 子句和 HAVING 子句（以及之后将要学到的 ORDER BY 子句）中能够使用 COUNT 等聚合函数。

-- WHERE 子句 = 指定行所对应的条件

-- HAVING 子句 = 指定组所对应的条件

-- 使用 HAVING 子句时 SELECT 语句的顺序 FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY


-- 通过列名指定
SELECT product_id, product_name, sale_price, purchase_price
  FROM Product
ORDER BY sale_price DESC, product_id;

-- 通过列编号指定
SELECT product_id, product_name, sale_price, purchase_price
  FROM Product
ORDER BY 3 DESC, 1;


-- 虽然列编号使用起来非常方便，但我们并不推荐使用，原因有以下两点。

-- 第一，代码阅读起来比较难。使用列编号时，如果只看 ORDER BY 子句是无法知道当前是按照哪一列进行排序的，只能去 SELECT 子句的列表中按照列编号进行确认。上述示例中 SELECT 子句的列数比较少，因此可能并没有什么明显的感觉。但是在实际应用中往往会出现列数很多的情况，而且 SELECT 子句和 ORDER BY 子句之间，还可能包含很复杂的 WHERE 子句和 HAVING 子句，直接人工确认实在太麻烦了。

-- 第二，这也是最根本的问题，实际上，在 SQL-92{9[1992 年制定的 SQL 标准。]} 中已经明确指出该排序功能将来会被删除。因此，虽然现在使用起来没有问题，但是将来随着 DBMS 的版本升级，可能原本能够正常执行的 SQL 突然就会出错。不光是这种单独使用的 SQL 语句，对于那些在系统中混合使用的 SQL 来说，更要极力避免


CREATE TABLE ProductIns
(product_id     CHAR(4)  NOT NULL,
 sale_price      INTEGER  DEFAULT 0, -- 销售单价的默认值设定为0;
 PRIMARY KEY (product_id));

 -- 通过显式方法插入默认值
INSERT INTO ProductIns (product_id, product_name, product_type, sale_price, purchase_price, regist_date) 
VALUES ('0007', '擦菜板', '厨房用具', DEFAULT, 790, '2009-04-28');

-- 通过隐式方法插入默认值
-- 插入默认值时也可以不使用 DEFAULT 关键字，只要在列清单和 VALUES 中省略设定了默认值的列就可以了。我们可以像代码清单 4-7 那样，从 INSERT 语句中删除 sale_price 列（销售单价）。


-- 使用逗号对列进行分隔排列
UPDATE Product
   SET sale_price = sale_price * 10,
       purchase_price = purchase_price / 2
 WHERE product_type = '厨房用具';


 -- 将列用()括起来的清单形式
UPDATE Product
   SET (sale_price, purchase_price) = (sale_price * 10, purchase_price / 2)
 WHERE product_type = '厨房用具';-- 将列清单化（代码清单 4-20），这一方法在某些 DBMS 中是无法使用的 {10[可以在 PostgreSQL 和 DB2 中使用。]}

 -- 事务
 BEGIN TRANSACTION;
 -- 将T恤衫的销售单价上浮1000日元
UPDATE Product
SET sale_price = sale_price + 1000
WHERE product_name = 'T恤衫';
COMMIT;

-- ACID 特性 原子性 一致性 隔离性 持久性
-- 原子性 事务是不可分割的最小工作单元，要么全部成功，要么全部失败回滚
-- 一致性 事务执行前后，数据从一个一致性状态转移到另一个一致性状态
-- 隔离性 一个事务所做的修改在最终提交之前，对其他事务是不可见的
-- 持久性 事务一旦提交，对数据库中数据的改变就是永久性的，即使系统崩溃，事务中的数据也不会丢失 


/*
使用视图时并不会将数据保存到存储设备之中，而且也不会将数据保存到其他任何地方。实际上视图保存的是 SELECT 语句。
我们从视图中读取数据时，视图会在内部执行该 SELECT 语句并创建出一张临时表。
*/

/*
从SQL的角度来看，视图和表是相同的，两者的区别在于表中保存的是实际的数据，而视图中保存的是SELECT语句（视图本身并不存储数据）。
使用视图，可以轻松完成跨多表查询数据等复杂操作。
可以将常用的SELECT语句做成视图来使用。
创建视图需要使用CREATE VIEW语句。
视图包含“不能使用ORDER BY”和“可对其进行有限制的更新”两项限制。
删除视图需要使用DROP VIEW语句。
*/
-- 创建视图的CREATE VIEW 语句

CREATE VIEW 视图名称(<视图列名1>, <视图列名2>, ……)
AS
<SELECT语句>


-- 标量子查询
SELECT product_id, product_name, sale_price,(SELECT AVG(sale_price)
	  FROM Product) as avg_price
	  FROM Product

-- 使用标量子查询时的注意事项，那就是该子查询绝对不能返回多行结果。
-- 也就是说，如果子查询返回了多行结果，那么它就不再是标量子查询，
-- 而仅仅是一个普通的子查询了，因此不能被用在 = 或者 <> 等需要单一输入值的运算符当中，也不能用在 SELECT 等子句当中。



-- 函数
-- 算术函数（用来进行数值计算的函数）
-- +（加法）
-- -（减法）
-- *（乘法）
-- /（除法）
-- ABS——绝对值
-- MOD——求余
-- ROUND 四舍五入
-- ||——拼接 eg:  字符串1||字符串2
-- LENGTH(字符串)
-- LOWER(字符串)
-- UPPER(字符串)
-- REPLACE(字符串, 旧字符串, 新字符串)
-- SUBSTRING(字符串, 开始位置, 长度)
-- CURRENT_DATE
-- CURRENT_TIME——当前时间
-- EXTRACT——截取日期元素
SELECT CURRENT_TIMESTAMP,
       EXTRACT(YEAR   FROM CURRENT_TIMESTAMP)  AS year,
       EXTRACT(MONTH  FROM CURRENT_TIMESTAMP)  AS month,
       EXTRACT(DAY    FROM CURRENT_TIMESTAMP)  AS day,
       EXTRACT(HOUR   FROM CURRENT_TIMESTAMP)  AS hour,
       EXTRACT(MINUTE FROM CURRENT_TIMESTAMP)  AS minute,
       EXTRACT(SECOND FROM CURRENT_TIMESTAMP)  AS second;
-- cast
	SELECT CAST('0001' AS INTEGER) AS int_col;
-- COALESCE SQL 特有的函数。该函数会返回可变参数中,左侧开始第 1 个不是 `NULL` 的值。参数个数是可变的，因此可以根据需要无限增加。


-- 字符串函数（用来进行字符串操作的函数）

-- 日期函数（用来进行日期操作的函数）

-- 转换函数（用来转换数据类型和值的函数）

-- 聚合函数（用来进行数据聚合的函数）


-- case when then else end
CASE WHEN <求值表达式> THEN <表达式>
     WHEN <求值表达式> THEN <表达式>
     WHEN <求值表达式> THEN <表达式>
       .
       .
       .
     ELSE <表达式>
END


-- 并集 
-- UNION 和 UNION ALL 

-- 交集
-- INTERSECT

-- 差集
-- EXCEPT

-- 连接
-- INNER JOIN
-- LEFT JOIN
-- RIGHT JOIN
-- FULL JOIN

-- 窗口函数也称为 OLAP 函数 {1[在 Oracle 和 SQL Server 中称为分析函数。]}。
/*
窗口函数也称为 OLAP 函数 {1[在 Oracle 和 SQL Server 中称为分析函数。]}。
窗口函数可以分为以下 3 种。
RANK函数
DENSE_RANK函数
ROW_NUMBER函数
*/

<窗口函数> OVER ([PARTITION BY <列清单>]
                         ORDER BY <排序用列清单>)


-- `GROUPING`运算符 GROUPING 函数——让 NULL 更加容易分辨

-- ROLLUP——同时得出合计和小计

-- CUBE——同时得出合计、小计和明细
-- CUBE，就是将 GROUP BY 子句中聚合键的“所有可能的组合”的汇总结果集中到一个结果中。
-- GROUPING SETS  CUBE 的结果就是根据聚合键的所有可能的组合计算而来的。
-- 如果希望从中选取出将“商品种类”和“登记日期”各自作为聚合键的结果，
-- 或者不想得到“合计记录和使用 2 个聚合键的记录”时，可以使用 GROUPING SETS

SELECT CASE WHEN GROUPING(product_type) = 1
            THEN '商品种类 合计'
            ELSE product_type END AS product_type,
       CASE WHEN GROUPING(regist_date) = 1
            THEN '登记日期 合计'
            ELSE CAST(regist_date AS VARCHAR(16)) END AS regist_date,
       SUM(sale_price) AS sum_price
  FROM Product
 GROUP BY GROUPING SETS (product_type, regist_date);





















