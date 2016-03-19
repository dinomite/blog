---
title: Better Rails.cache Invalidation with Quick Queries
date: 2016-03-18
tags: Tech, Rails
---
Rails [provides a caching framework](http://guides.rubyonrails.org/caching_with_rails.html), built-in.  Just set `config.cache_store` in your `application.rb`.  The easiest way to use caching is using time-base invalidation—you compute something expensive and store it in the cache with an expiration time.  The first time you try to retrieve it after the expiration, recompute & cache the new value.

```ruby
class Product < ActiveRecord::Base
  def expensive_operation
    Rails.cache.fetch("product/expensive_operation", expires_in: 12.hours) do
      LVMH::API.do_it()
    end
  end
end
```

Many things in the world don't respond well to only being updated on a wallclock schedule.  User profiles are viewed much more often than they are updated, meaning time-based cache expiration will cause needless regeneration of unchanged values.  Furthermore, when a user does update their profile, not seeing that reflected immediately is confusing.

The first problem can be ameliorated by using very long expirations and the latter by force-expiring related cache entries when issuing updates.  That last bit leaves a huge potential pitfall: forgetting to invalidate the cache when updating the value.  Another approach for keeping your cache fresh is to use a quickly-retrieved value that indicates whether the cache needs to be regenerated.

In [our](http://www.forumforall.net) application, user profiles show friend relationships and use that information to pull in recent comments from those friends, an expensive operation spanning many tables.  One key bit that informs how much searching we need to do is those friend relationships.  If the user has new friends we need to look at all of those new friend's recent comments and build them for display.  While checking the entire friends list is expensive, checking the latest change for a single user is quick.

```ruby
class FriendsAPI
  def get_friends(user, status)
    key_prefix = "friends_api:get_friends:#{user.id}:#{status}"
    timestamp = user.most_recent_friends_time

    Rails.cache.fetch("#{key_prefix}:#{timestamp}", expires_in: 1.week) do
      Rails.cache.delete_matched("#{key_prefix}:*")

      inflated_friends = []
      friends = user.get_all_friends
      friends.each do |friend|
        inflated_friends << InflatedFriend.new(friend)
      end
      
      inflated_friends
    end
  end
end
```

The key here is that `user.most_recent_friends_time` is a fast query.  The cache key is a compound of the calling-specific values (the user and the requested status) and the timestamp for the most recent friend change time.  When the method is executed, `Rails.cache.fetch()` attempts to retrieve an entry for the last friend change time.  If the user hasn't created any new friendships since the last time the method ran (and it's been less than [one week](https://www.youtube.com/watch?v=fC_q9KPczAg)), it'll be in the cache.  If the user has made more friends, then the cache will miss.  On a miss, the first thing to do is remove any prior entries, then just do the expensive bit and return it.
