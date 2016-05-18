---
title: Optional Authentication with Dropwizard
date: 2016-05-18
tags: Tech, Java, Kotlin, Dropwizard
---
[Dropwizard](http://dropwizard.io) provides a great framework for authentication & authorization.  [`Authenticator`](http://www.dropwizard.io/0.9.2/dropwizard-auth/apidocs/io/dropwizard/auth/Authenticator.html)s do what their name implies, returning a [`Principal`](http://docs.oracle.com/javase/7/docs/api/java/security/Principal.html?is-external=true) (probably your `User` object) that servlets can use for building responses.  The [`Authorizer`](http://www.dropwizard.io/0.9.2/dropwizard-auth/apidocs/io/dropwizard/auth/Authorizer.html) interface has a single methoed, `authorize()`, which takes a `Principal` and a string role to authorize access for.  These get wrapped in an [`AuthFilter`](http://www.dropwizard.io/0.9.2/dropwizard-auth/apidocs/io/dropwizard/auth/AuthFilter.html) which extracts credentials from the requst and passed on to the `Authenticator`.

With the authen & authz classes in place protecting resources is easy: you simply annotate them with one of `@PermitAll`, `@RolesAllowed`, or `@DenyAll`.  The last one does exactly what it says on the tin.  A specific role or set of roles can be permitted access with the `@RolesAllowed` annotation, to which you pass a `String` or `String[]` of roles.  `@PermitAll` allows any _authenticated_ user to access the resource.  What is missing here is an annotation to allow optionally authenticated resources—allowing you to customize a response for a known user but deliver a generic response to anonymous visitors.

# Optionally protected resources

The Dropwizard manual gives a [cursory explanation](http://www.dropwizard.io/0.9.2/docs/manual/auth.html#protecting-resources) of how to implement optional authentication:

<tt>
If you have a resource which is optionally protected (e.g., you want to display a logged-in user’s name but not require login), you need to implement a custom filter which injects a security context containing the principal if it exists, without performing authentication.
</tt>

The process for optional resources involves two `AuthFilter`s: one to check & process credentials for a logged-in user and a second that provides a default user.  These can be hit in turn with a [`ChainedAuthFilter`](http://www.dropwizard.io/0.9.2/dropwizard-auth/apidocs/io/dropwizard/auth/chained/ChainedAuthFilter.html).

I'll show the important parts of how I accomplished this with code examples written in a mix of Java and [Kotlin](https://kotlinlang.org/).

# Wiring

Setting up Dropwizard's authentication involves creating an `AuthFilter` to which you pass the `Authenticator` and `Authorizer` that it will use.  Creating a `ChainedAuthFilter` is easy, just pass a `List<AuthFilter>` with the filters in the order they should be executed.  Dropwizard tries each of the `AuthFilter`s in turn until one returns successfully.

In the application's `run()` method:

```java
// Application.java
ApiKeyAuthFilter apiKey = new ApiKeyAuthFilter.Builder()
        .setAuthenticator(apiKeyAuthenticator)
        .setAuthorizer(authorizer)
        .setPrefix("API key")
        .buildAuthFilter();
DefaultAuthFilter default = new DefaultAuthFilter.Builder()
        .setAuthenticator(defaultAuthenticator)
        .setAuthorizer(authorizer)
        .setPrefix("default")
        .buildAuthFilter();

List<AuthFilter> filterList = Lists.newArrayList(apiKey, default);
ChainedAuthFilter chainedAuthFilter = new ChainedAuthFilter<>(filterList)

environment.jersey().register(new AuthDynamicFeature(chainedAuthFilter));
environment.jersey().register(RolesAllowedDynamicFeature.class);
```

The `AuthFilter`s and their respective `Authenticator`s are described below.

# API key authentication

As mentioned, my user authentication is done with an API key that is passed in the Authorization HTTP header.  The filter extracts the value and passes it to the `authenticate()` method of `ApiKeyAuthenticator`.

```java
// ApiKeyAuthFilter.kt
override fun filter(requestContext: ContainerRequestContext) {
    val credentials = requestContext.headers.getFirst(HttpHeaders.AUTHORIZATION)
    if (!authenticate(requestContext, credentials, API_KEY_AUTH)) {
        throw WebApplicationException(unauthHandler.buildResponse(prefix, realm))
    }
}
```

The API key authenticator checks the databse to see if the given API key exists.  If the key is found, the matching `User` is returned; if not found, an empty `Optional` is returned instead.

```java
// ApiKeyAuthenticator.kt
@Throws(AuthenticationException::class)
override fun authenticate(credentials: ApiKey): Optional<User> {
    val userId = apiKeyDao.getUserIdForAccessToken(credentials.accessToken)
    if (userId != 0) {
        val user = userDao.getUser(userId)
        return Optional.of(user)
    }

    return Optional.empty<User>()
}
```

# Default authentication

If API key authentication fails, either because the user provided invalid credentials or no credentials at all, then the next `AuthFilter` configured in the `ChainedAuthFilter` is invoked.  Authentication for the default user doesn't actually check anything, so `Unit` is passed instead of credentials:

```java
// DefaultAuthFilter.kt
override fun filter(requestContext: ContainerRequestContext) {
    if (!authenticate(requestContext, Unit, "DEFAULT")) {
        throw WebApplicationException(unauthHandler.buildResponse(prefix, realm))
    }
}
```

As the last authenticator to run in the chain, the DefaultAuthenticator never fails, it simply returns a default-constructed `User` object.

```java
// DefaultAuthenticator.kt
@Throws(AuthenticationException::class)
override fun authenticate(credentials: Unit): Optional<User> {
    logger.debug("Using default auth");

    val user = User()
    return Optional.of(user)
}
```

# Usage in servlets

The `User` object looks like this:

```java
// User.kt
data class User(val id: Int, roles: List<Role>) : Principal {
    constructor() : this(0, emptyList())

    init {
        var theRoles = mutableListOf<Role>()

        if (id != 0) theRoles.add(Role.USER)

        roles = theRoles.toList()
    }

    fun hasRole(role: Role): Boolean {
        return roles.contains(role)
    }
}
```

Which allows me to check whether valid authentication was provided within a servlet:

```java
// SomeResource.kt
fun optionallyAuthenticatedResource(@Context context: SecurityContext) {
    user = context.getUserPrincipal()

    if (user != null && user.hasRole(Role.USER)) {
        // Do something for authenticated users
    }

    // Do other stuff for all users
}
```
