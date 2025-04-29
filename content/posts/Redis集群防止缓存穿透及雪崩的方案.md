---
title: 'Redis集群防止缓存穿透及雪崩的方案'
date: 2025-04-29T15:12:38+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["blog"]
---

# Redis集群防止缓存穿透及雪崩的方案

## 缓存穿透解决方案

缓存穿透是指查询一个不存在的数据，由于缓存中不存在，请求会直接打到数据库上：

1. **布隆过滤器(Bloom Filter)**
   - 在访问Redis前，先通过布隆过滤器判断key是否存在
   - 不存在则直接返回，避免查询数据库
   - 实现方式：可以使用Redis的`RedisBloom`模块

2. **空值缓存**
   - 对于查询结果为null的key，也进行缓存
   - 设置较短的过期时间(如30秒-1分钟)
   - 示例代码：
     ```java
     String value = redis.get(key);
     if (value == null) {
         value = db.get(key);
         if (value == null) {
             // 缓存空值
             redis.setex(key, 60, "NULL");
         } else {
             redis.setex(key, 300, value);
         }
     } else if ("NULL".equals(value)) {
         return null;
     }
     ```

3. **接口层校验**
   - 对请求参数进行合法性校验
   - 如ID必须为正整数，否则直接拒绝

## 缓存雪崩解决方案

缓存雪崩是指大量缓存同时失效，导致所有请求直接打到数据库：

1. **差异化过期时间**
   - 为不同key设置随机的过期时间
   - 避免大量key同时过期
   - 示例：基础过期时间+随机值(如300-600秒)

2. **多级缓存架构**
   - 本地缓存(如Caffeine) + Redis集群 + 数据库
   - 多级缓存可以分散压力

3. **热点数据永不过期**
   - 对极热点数据设置永不过期
   - 通过后台任务定期更新缓存

4. **互斥锁重建缓存**
   - 当缓存失效时，使用分布式锁控制只有一个线程去重建缓存
   - 其他线程等待或返回旧值
   - 示例伪代码：
     ```java
     public String getData(String key) {
         String value = redis.get(key);
         if (value == null) {
             if (lock.tryLock()) { // 获取分布式锁
                 try {
                     // 再次检查，防止其他线程已经更新
                     value = redis.get(key);
                     if (value == null) {
                         value = db.get(key);
                         redis.setex(key, 300, value);
                     }
                 } finally {
                     lock.unlock();
                 }
             } else {
                 // 未获取到锁，等待或返回默认值
                 Thread.sleep(100);
                 return getData(key); // 重试
             }
         }
         return value;
     }
     ```

5. **熔断降级机制**
   - 当数据库压力过大时，启动熔断机制
   - 返回默认值或缓存中的旧数据

## Redis集群特定考虑

在三节点Redis集群环境下，还需要注意：

1. **数据分片均匀性** - 确保热点key均匀分布在各个节点
2. **集群监控** - 监控每个节点的内存、CPU、网络等指标
3. **故障转移** - 确保集群的高可用性，主节点故障时能快速切换

通过以上方案的综合应用，可以有效防止Redis集群环境下的缓存穿透和雪崩问题。
