---
title: 'Spring缓存'
date: 2025-07-11T11:01:17+08:00
description: "A blog post"
image: "/images/20250711110117.png"
type: "post"
tags: ["blog","spring","cache","spring-boot","spring-cloud","Caffeine","redis","@Cacheable"]
---

# Spring缓存
### Spring缓存介绍
@Cacheable 是 Spring Framework 提供的一个注解，用于方法级别的缓存管理。当一个被标注为 @Cacheable 的方法被调用时，它会先检查缓存中是否有对应的结果。如果有，则直接返回缓存结果，而不会执行方法逻辑。如果没有，则执行方法逻辑并将结果存入缓存，以便下次调用时直接使用缓存值。
### 作用
@Cacheable 注解的作用是将方法的返回值缓存起来，以提高系统的性能。当一个方法被多次调用时，如果缓存中已经存在该方法的返回值，则可以直接从缓存中获取，而不需要再次执行方法逻辑。这样可以避免重复计算，提高系统的响应速度。
1. 提升性能：避免重复调用耗时的计算或 I/O 操作（如数据库查询或远程调用）。
2. 减少资源消耗：减少系统对外部依赖（如数据库、API）的访问频率。
3. 简单易用：通过注解配置，无需显式管理缓存逻辑。

### 使用场景
@Cacheable 注解适用于以下场景：
1. 数据库查询：对于频繁查询的数据，可以使用 @Cacheable 注解将查询结果缓存起来，避免重复查询数据库。
2. 计算密集型任务：对于计算密集型任务，可以使用 @Cacheable 注解将计算结果缓存起来，避免重复计算。
3. 外部服务调用：对于外部服务调用，可以使用 @Cacheable 注解将调用结果缓存起来，避免重复调用外部服务。
4. 高并发场景：对于高并发场景，可以使用 @Cacheable 注解将热点数据缓存起来，避免热点数据的频繁访问。
###
```
@Cacheable(
    cacheNames = ..., // 缓存的名字（可理解为缓存的分类）
    key = ...,        // 缓存的键（默认使用方法参数作为键）
    unless = ...,     // 条件表达式，返回 true 时不会缓存
    condition = ...   // 条件表达式，返回 true 时才缓存
)
```
### Caffeine 本地缓存
Caffeine 是一个高性能、本地缓存库，提供类似于 Guava Cache 的功能，并且性能更优

### 二级缓存
先查本地Caffeine缓存，未命中再查Redis缓存，最后才查数据库。缓存更新时会同时更新两级缓存。可以根据实际需求调整缓存过期时间和大小等参数。

### 代码
pom.xml
```xml
<dependencies>
    <!-- Spring Boot Starter -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- Caffeine 缓存 -->
    <dependency>
        <groupId>com.github.ben-manes.caffeine</groupId>
        <artifactId>caffeine</artifactId>
        <version>3.1.8</version>
    </dependency>

    <!-- Redis -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
</dependencies>
```

CacheConfig.java
```java
@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public CacheManager cacheManager(RedisConnectionFactory redisConnectionFactory) {
        CaffeineCacheManager caffeineCacheManager = new CaffeineCacheManager();
        caffeineCacheManager.setCaffeine(Caffeine.newBuilder()
            .initialCapacity(100)
            .maximumSize(1000)
            .expireAfterWrite(10, TimeUnit.MINUTES));

        RedisCacheManager redisCacheManager = RedisCacheManager.builder(redisConnectionFactory)
            .cacheDefaults(RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(30)))
            .build();

        return new TwoLevelCacheManager(caffeineCacheManager, redisCacheManager);
    }
}
```
TwoLevelCacheManager.java
```java
public class TwoLevelCacheManager implements CacheManager {
    private final CacheManager caffeineCacheManager;
    private final CacheManager redisCacheManager;

    public TwoLevelCacheManager(CacheManager caffeine, CacheManager redis) {
        this.caffeineCacheManager = caffeine;
        this.redisCacheManager = redis;
    }

    @Override
    public Cache getCache(String name) {
        return new TwoLevelCache(name,
            caffeineCacheManager.getCache(name),
            redisCacheManager.getCache(name));
    }

    // 其他必要方法...
}

```
TwoLevelCache.java
```java
public class TwoLevelCache implements Cache {
    private final String name;
    private final Cache caffeineCache;
    private final Cache redisCache;

    public TwoLevelCache(String name, Cache caffeine, Cache redis) {
        this.name = name;
        this.caffeineCache = caffeine;
        this.redisCache = redis;
    }

    @Override
    public ValueWrapper get(Object key) {
        ValueWrapper value = caffeineCache.get(key);
        if(value == null) {
            value = redisCache.get(key);
            if(value != null) {
                caffeineCache.put(key, value.get());
            }
        }
        return value;
    }

    // 实现其他Cache接口方法...
}

```
example
```
@Service
public class UserService {
    @Cacheable(value = "users", key = "#userId")
    public User getUserById(Long userId) {
        // 数据库查询逻辑
        return userRepository.findById(userId).orElse(null);
    }

    @CacheEvict(value = "users", key = "#userId")
    public void updateUser(User user) {
        // 更新数据库
        userRepository.save(user);
    }
}
```
