---
title: Reading Devise sessions in Java
date: 2016-05-02
tags: Tech, Rails
---
I have a Ruby on Rails app that uses [Devise](https://github.com/plataformatec/devise) for authentication and session management, the latter is really done by [Warden](https://github.com/hassox/warden).  We are making a server-side companion for Ruby written in [Kotlin](https://kotlinlang.org/) & Java and want to be able to share sessions between the two runtimes.

[JRuby](http://jruby.org/) makes this easy, allowing you to run Ruby on the JVM.  While JRuby supports running entire Ruby applications, for reading sessions we simply want to embed a bit of Ruby within our Java application.  This is accomplished by using [JRuby Embed (AKA Red Bridge)](https://github.com/jruby/jruby/wiki/RedBridge).

First, let's look at the Ruby required to read [Warden sessions](http://stackoverflow.com/a/23683925/17339).  Our app stores sessions in a local databae, so we don't have to deal with encryption or encoding.  If your sessions are stored in cookies, they will be encrypted—[this article](http://nipperlabs.com/rails-secretkeybase) should give you what you need to decrypt the session.

```ruby
s = Marshal.load(session)
csrfToken = s['_csrf_token']
userId = s['warden.user.user.key'][0][0]
authenticatableSalt = s['warden.user.user.key'][1]
```

The operative part of this is really just one call, `Marshal.load(session)`.  That invokes Ruby's built-in serializer, `Marshal`, to deserialize the session string.  The subsequent lines just assign variables to make extracting the desired data in Java easier.  Here is that script used in context to pull the information into Java:


```java
public Session getSession(String session) {
    container.put("session", session);
    container.runScriptlet(rubyScript);

    int userId = ((Long) container.get("userId")).intValue();
    String authenticatableSalt = ((String) container.get("authenticatableSalt"));
    String csrfToken = ((String) container.get("csrfToken"));

    return new Session(userId, authenticatableSalt, csrfToken);
}
```

The entire Java class looks like this:

```java
import org.jruby.embed.LocalContextScope;
import org.jruby.embed.LocalVariableBehavior;
import org.jruby.embed.ScriptingContainer;

public class SessionReader {
    private final ScriptingContainer container =
        new ScriptingContainer(LocalContextScope.CONCURRENT,
                               LocalVariableBehavior.PERSISTENT);
    private final String script = "s = Marshal.load(session);" +
                                  "csrfToken = s['_csrf_token'];" +
                                  "userId = s['warden.user.user.key'][0][0];" +
                                  "authSalt = s['warden.user.user.key'][1];";

    public Session getSession(String session) {
        container.put("session", session);
        container.runScriptlet(script);

        int userId = ((Long) container.get("userId")).intValue();
        String authSalt = ((String) container.get("authSalt"));
        String csrfToken = ((String) container.get("csrfToken"));
        return new Session(userId, authSalt, csrfToken);
    }
}

class Session {
    private final int userId;
    private final String authenticatableSalt;
    private final String csrfToken;

    public Session(int userId, String authenticatableSalt, String csrfToken) {
        this.userId = userId;
        this.authenticatableSalt = authenticatableSalt;
        this.csrfToken = csrfToken;
    }
}
```

Using `LocalContextScope.CONCURRENT` allows this class to be threadsafe.  JRuby creates a single runtime and shared variables for the `ScriptingContainer`, but separate variable mappings for each thread.  The other modifier, `LocalVariableBehavior.PERSISTENT`, keeps the local variables around after we call `runScriptlet()` allowing for their retrieval back in Java land.

See the [Red Bridge Examples](https://github.com/jruby/jruby/wiki/RedBridgeExamples) for more information on using Ruby within Java.
