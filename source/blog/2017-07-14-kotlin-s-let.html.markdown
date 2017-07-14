---
title: Kotlin's let()
date: 2017-07-14 20:05 UTC
tags: Programming, Kotlin
---

Kotlin's standard library is a [small collection](http://beust.com/weblog/2015/10/30/exploring-the-kotlin-standard-library/) of syntax sugar methods that are part of why the language is [a better Java](https://medium.com/@magnus.chatt/why-you-should-totally-switch-to-kotlin-c7bbde9e10d5).  The `let()` function creates a block within which the receiver is scoped, either as Kotlin's default `it` or a named variable you provide.  Combined with Kotlin's [safe call operator](https://kotlinlang.org/docs/reference/null-safety.html#safe-calls), only executing a block when you have a non-null value is concise:

```kotlin
    dao.user(id)?.let {
        // Do something with the user
    }
```

Cédric Beust has a [follow-up post on `let()`](http://beust.com/weblog/2016/01/14/a-close-look-at-kotlins-let/) in which he says that he is moving away from this usage of `?.let()` in favor of regular old `if-else` blocks because they make it more obvious what happens on the failing side of the `if`, when the result of the receiver is null.  I agree, but have one style of function for which I still quite like `?.let()`—cache retrieval:

```kotlin
    fun getSomethingExpensive(id: Int): String? {
        val cacheKey = "cache:$id"

        jedis.get(cacheKey)?.let { return it }

        // No cached value, do the work
        val result = someExpensiveWorkFunction()
        jedis.setex(cacheKey, result)

        return result
    }
```

I like the flow of this style; you pause to check the cache, but move on to computing the value immediately below without the extra visual complexity of assigning the result of the cache query to variable and separately checking that variable for being null.
