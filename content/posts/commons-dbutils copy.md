---
title: "Commons Dbutils"
date: 2025-11-03T15:53:09+08:00
description: "A blog post"
image: "/images/20251103155309.png"
type: "post"
tags: ["blog"]
---

# commons-dbutils

## 1.项目介绍

commons-dbutils 是一个简化 JDBC 操作的 Java 工具包，它提供了一组数据库操作辅助类，能够极大地减少代码量，提高开发效率。该项目属于 Apache Commons 组件库的一部分，以提供简单的数据库访问API为核心，通过简单的抽象，隐藏了JDBC的复杂性，但同时保留了强大的功能。

### 1.1 项目结构和主要组件

在项目结构上， commons-dbutils 主要包括以下几个核心组件：

- **QueryRunner** ：核心类，提供简化执行SQL查询和更新的方法。
- **ResultSetHandler** ：结果集处理器，定义了处理查询结果的标准接口。
  这些组件通过提供一致的API接口和灵活的扩展性，允许开发者能够以声明式的方式与数据库进行交互，大幅减少了样板代码。

### 1.2 开始使用 commons-dbutils

```xml
<dependency>
    <groupId>commons-dbutils</groupId>
    <artifactId>commons-dbutils</artifactId>
    <version>1.7</version>
</dependency>
```

现在，您已经准备好使用 `commons-dbutils` 进行数据库操作了。接下来章节将详细介绍如何使用 `QueryRunner` 类进行数据库的增删改查操作，以及如何优化这些操作以提高性能。

## 2. QueryRunner核心类及其作用

### 2.1 QueryRunner类的定义和用途

#### 2.1.1 QueryRunner类的基本功能

QueryRunner是Apache Commons DbUtils库中的核心类之一，它为数据库操作提供了一个轻量级的解决方案。QueryRunner的职责是简化JDBC代码，使开发者能够以更少的代码量来执行SQL查询和更新。它支持两种类型的构造器：无参构造器和带DataSource参数的构造器。使用无参构造器时，用户需要手动提供Connection对象来执行数据库操作；而使用带DataSource参数的构造器，则可以直接利用DbUtils提供的自动关闭连接的功能，无需手动管理Connection的生命周期。

QueryRunner的主要特点包括：

- 简化数据库操作代码
- 支持基本的查询和更新方法
- 支持使用DataSource自动管理连接
- 提供异常处理机制

通过QueryRunner，开发者可以更加专注于业务逻辑的实现，而不是繁琐的资源管理细节。例如，执行一个简单的查询操作，通过QueryRunner类的实现可以减少很多样板代码。

#### 2.1.2 QueryRunner类在项目中的重要性

在许多Java项目中，尤其是那些需要频繁与数据库交互的应用程序中，能够有效地简化数据库操作是非常重要的。QueryRunner类作为一个工具类，提供了这些简化操作的方法，能够显著减少开发时间和提高代码的可读性与可维护性。

使用QueryRunner类，开发人员可以避免直接与JDBC打交道，减少了那些重复的模板代码，如手动开启和关闭数据库连接、异常处理等。这样不仅提高了开发效率，也降低了出错的可能性。

此外，QueryRunner支持自动提交和手动事务控制两种模式，使得它既可以用于简单的脚本程序，也可以用于需要事务管理的复杂业务场景。这意味着开发者可以根据实际需求灵活地使用QueryRunner，从而在开发过程中实现更高效的数据库操作。

### 2.2 QueryRunner与其它数据库工具类的比较

#### 2.2.1 QueryRunner与其他数据库工具类的共性和差异

在Java生态中，有许多数据库操作框架和工具类，比如JDBC、Hibernate、MyBatis等。QueryRunner与这些工具类相比，既有共性也有差异。

**共性**：

- 都是为了简化数据库操作而设计的。
- 都需要配置数据库连接参数，比如URL、用户名和密码。
- 都提供了SQL语句的执行接口。

**差异**：

- **QueryRunner vs JDBC**：JDBC是一种低级的API，需要开发者手动管理数据库连接和资源，处理异常。QueryRunner是建立在JDBC之上的一层抽象，它可以自动管理资源，并简化异常处理。
- **QueryRunner vs Hibernate/MyBatis**：Hibernate和MyBatis提供了更为丰富的ORM（对象关系映射）功能，可以自动将数据库表映射到Java对象。而QueryRunner则更轻量级，专注于简化SQL执行，不涉及对象映射。

#### 2.2.2 QueryRunner的优势和局限性

QueryRunner的优势在于它的轻量级和易用性。由于其与JDBC紧密集成，它对数据库的直接操作提供了最大的灵活性。同时，它适合在那些不需要复杂ORM特性的项目中使用，因此可以作为其他大型持久层框架的补充。

然而，QueryRunner也有其局限性：

- 缺乏ORM支持：无法像Hibernate或MyBatis那样将Java对象直接映射到数据库表。
- 功能有限：不支持复杂的查询构建，比如多表联查和子查询。
- 可扩展性受限：虽然可以通过扩展QueryRunner来实现特定功能，但相对ORM框架而言，这样做仍然不够灵活。

**小结**：
QueryRunner是针对简化基本数据库操作的轻量级工具。它使得开发者能够快速实现简单的查询和更新，而且相比于其他数据库工具，它的使用门槛相对较低。然而，对于那些需要进行复杂数据模型映射和高度封装的场景，QueryRunner可能不是最佳选择。

## 3. 连接池的解耦合使用

### 3.1 连接池技术概述

#### 3.1.1 连接池的基本概念和工作原理

连接池是一种资源池化技术，它在初始化时创建一定数量的数据库连接，并将这些连接保存在内存中。这些连接供应用程序使用，当需要进行数据库操作时，应用程序不必每次都创建新的连接，而是从连接池中获取一个已经存在的连接。当操作完成后，连接被返回到连接池中，供下次使用，而不是直接关闭。这种做法大大减少了频繁创建和销毁数据库连接的开销，提高了应用性能。

连接池的基本工作原理如下：

1. 初始化：在应用程序启动时，预先创建一定数量的数据库连接，并将它们保持空闲状态，等待被使用。
2. 连接获取：当应用程序需要与数据库进行交互时，从连接池中请求一个连接。
3. 连接返回：操作完成后，应用程序将连接返回给连接池，而不是关闭连接。
4. 连接清理：连接池会定期检查连接的有效性，对无效连接进行清理和替换。
5. 资源回收：当应用程序关闭时，连接池中的连接会被关闭，连接池资源被回收。

#### 3.1.2 连接池在数据库操作中的重要性

数据库连接是一种有限且宝贵的资源，尤其是在高并发的Web应用中。频繁地打开和关闭数据库连接会消耗大量的系统资源，导致应用程序性能下降。连接池技术的引入极大地优化了这一问题：

1. 提高性能：通过重用连接，减少了数据库连接的创建和销毁时间，降低了系统开销。
2. 增强稳定性：由于连接池会管理连接的生命周期，因此可以有效避免因连接用尽而导致的系统崩溃。
3. 平衡负载：连接池可以根据实际需要动态地提供和回收连接，有助于平衡和分散数据库的负载。
4. 资源控制：能够更精细地控制数据库连接数，避免产生过多或过少的连接。

### 3.2 QueryRunner与连接池的集成使用

#### 3.2.1 配置连接池的步骤

配置连接池通常涉及以下几个步骤：

1. 选择合适的连接池实现，如HikariCP、Apache DBCP等。
2. 在项目中引入连接池依赖。
3. 配置连接池参数，如最大连接数、最小空闲连接数、连接超时时间等。
4. 创建连接池实例，并将数据库连接信息作为参数传入。
5. 在需要的地方通过连接池获取连接，并在使用完毕后归还。

以HikariCP为例，配置连接池的基本代码如下：

```java
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

// 创建连接池配置对象
HikariConfig config = new HikariConfig();
config.setJdbcUrl("jdbc:mysql://localhost:3306/your_database");
config.setUsername("your_username");
config.setPassword("your_password");
config.addDataSourceProperty("cachePrepStmts", "true");
config.addDataSourceProperty("prepStmtCacheSize", "250");
config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

// 创建连接池数据源实例
HikariDataSource dataSource = new HikariDataSource(config);

// 获取连接示例
Connection connection = dataSource.getConnection();
// ... 进行数据库操作
connection.close();
```

#### 3.2.2 QueryRunner在连接池环境下操作实例

在连接池环境下使用QueryRunner时，可以通过在创建QueryRunner实例时传入连接池的连接来实现。以下是操作实例：

```java
mons.dbutils.QueryRunner; mons.dbutils.handlers.BeanHandler; mons.dbutils.handlers.BeanListHandler;

// 创建QueryRunner实例，传入连接池的数据源 QueryRunner runner = new QueryRunner(dataSource);

// 执行查询操作，获取单条记录
try {
    String sql = "SELECT * FROM users WHERE id = ?";
    User user = runner.query(sql, new BeanHandler (User.class), 1);
    System.out.println(user.getName());
} catch (SQLException e) {
    e.printStackTrace();
}
// 执行查询操作，获取多条记录
try {
    String sql = "SELECT * FROM users";
    List users = runner.query(sql, new BeanListHandler (User.class));
    users.forEach(user -> System.out.println(user.getName()));
} catch (SQLException e) {
    e.printStackTrace();
} catch (Exception e) {
    e.printStackTrace();
}
// 执行更新操作
try {
    String sql = "UPDATE users SET name = ? WHERE id = ?";
    int rows = runner.update(sql, "newName", 1);
    System.out.println("Updated " + rows + " rows.");
} catch (SQLException e) {
    e.printStackTrace();
}
```

在上述代码中，我们首先创建了一个`HikariDataSource`连接池实例，并配置了连接信息。之后在创建`QueryRunner`实例时，传入了连接池的数据源对象`dataSource`。这样，`QueryRunner`在执行数据库操作时，就会从连接池中获取和返回连接，而不需要显式地管理连接的生命周期。这种方式解耦合了数据库连接管理与业务逻辑，使得代码更加简洁高效。

请注意，实际在使用时，您需要确保已经添加了对应的依赖，并根据您的项目环境配置适当的连接池参数。

## 4. 简单查询与更新操作的执行

### 4.1 基本查询操作的实现

#### 4.1.1 使用QueryRunner执行单条SQL查询

在使用QueryRunner执行单条SQL查询时，我们首先要创建QueryRunner类的实例，并通过构造器传入数据源。然后利用execute方法来执行查询，并返回查询结果。

```java
import java.sql.Connection;
import java.sql.SQLException;

public class QueryRunnerExample {
    public static void main(String[] args) {
        // 创建数据库连接对象
        Connection conn = DatabaseConnection.getConnection();
        // 创建QueryRunner实例
        QueryRunner qr = new QueryRunner();
        // 定义SQL查询语句
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            // 执行查询操作
            Object result = qr.query(conn, sql, new ScalarHandler(), 1);
            // 输出查询结果
            System.out.println(result);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // 关闭数据库连接
            DatabaseConnection.closeConnection(conn);
        }
    }
```

**逻辑分析**： 在上述代码中，我们首先通过 DatabaseConnection.getConnection() 获取数据库连接，接着创建了 QueryRunner 的实例，并调用了其 query 方法。 query 方法的参数包括数据库连接、SQL查询语句、结果集处理器（这里使用了 ScalarHandler 来返回查询结果的单个值），以及用于查询条件的参数。

#### 4.1.2 查询结果的封装和处理

查询操作完成之后，通常需要对查询结果进行封装和处理。这通常涉及到结果集的映射，将结果集中的列转换为Java对象的属性。

```java
import java.sql.Connection;
import java.sql.SQLException;

public class QueryRunnerExample {
    public static void main(String[] args) {
        // 创建数据库连接对象
        Connection conn = DatabaseConnection.getConnection();
        // 创建QueryRunner实例
        QueryRunner qr = new QueryRunner();
        // 定义SQL查询语句
        String sql = "SELECT * FROM users WHERE id = ?";
        try { // 执行查询操作并获取用户对象
            User user = qr.query(conn, sql, new BeanHandler<>(User.class), 1);
            // 输出用户信息
            System.out.println(user.getName() + " " + user.getEmail());
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { // 关闭数据库连接
           DatabaseConnection.closeConnection(conn);
        }
    }
}
```

**逻辑分析：**
在这段代码中，我们使用了`BeanHandler`作为结果集处理器，它能够将结果集中的每一行映射为一个`User`类的实例。通过传递`User.class`到`BeanHandler`的构造器中，我们告诉`QueryRunner`如何将结果集中的数据转换为`User`对象。

## 4.2 更新操作的实现

### 4.2.1 使用QueryRunner执行数据更新

使用`QueryRunner`进行数据更新操作和查询操作类似，但更新操作使用的是`update`方法而非`query`方法。下面的示例演示了如何插入一条新的用户记录到数据库。

```java
import java.sql.Connection;
import java.sql.SQLException;

public class QueryRunnerExample {
    public static void main(String[] args) {
        // 创建数据库连接对象
        Connection conn = DatabaseConnection.getConnection();
        // 创建QueryRunner实例
        QueryRunner qr = new QueryRunner();
        // 定义SQL更新语句
        String sql = "INSERT INTO users(name, email) VALUES(?, ?)";
        try {
            // 执行更新操作
            int affectedRows = qr.update(conn, sql, "Alice", "***");
            // 输出受影响的行数
            System.out.println("插入数据成功，受影响的行数：" + affectedRows);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // 关闭数据库连接
            DatabaseConnection.closeConnection(conn);
        }
    }
}
```

逻辑分析： 在这段代码中，我们使用了 update 方法来执行插入操作。 update 方法同样需要数据库连接、SQL语句以及SQL语句中所需的参数。查询返回的是一个整数，表示受影响的行数。

#### 4.2.2 更新操作的事务处理和结果验证

事务处理在数据库更新操作中非常重要，它确保了一系列操作要么完全成功，要么完全失败，以维护数据的一致性。

````java
import org.apache.commons.dbutils.QueryRunner;
import java.sql.Connection;
import java.sql.SQLException;

public class QueryRunnerExample {
    public static void main(String[] args) {
    // 创建数据库连接对象
    Connection conn = DatabaseConnection.getConnection();
    // 创建QueryRunner实例
    QueryRunner qr = new QueryRunner();
    try {
        // 开启事务
        conn.setAutoCommit(false);
        // 定义SQL更新语句
        String insertSql = "INSERT INTO users(name, email) VALUES(?, ?)";
        String updateSql = "UPDATE users SET email = ? WHERE id = ?";
        // 执行插入操作
        qr.update(conn, insertSql, "Bob", " ");
        // 执行更新操作
        qr.update(conn, updateSql, "bob_ ", 2);
        // 所有操作成功后提交事务
        conn.commmit();
        System.out.println("事务提交成功，数据更新完毕。");
        } catch (SQLException e) {

        try { // 如果发生异常回滚事务
            conn.rollback();
        } catch (SQLException ex) {
            ex.printStackTrace(); } e.printStackTrace();
        } finally {
            // 关闭数据库连接
            DatabaseConnection.closeConnection(conn);
        }
    }
}
````
