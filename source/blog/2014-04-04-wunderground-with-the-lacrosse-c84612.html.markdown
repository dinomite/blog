---
title: "Wunderground with the LaCrosse C84612"
date: 2014-04-04
comments: true
tags: 
---

I got a [La Crosse C84612](http://www.lacrossetechnology.com/c84612/) weather station as a gift.  Costco sold this model sometime last year, though now the closest thing they have is a quite expensive [Oregon Scientific unit](http://www.costco.com/Oregon-Scientific-WMR300-Ultra-Precision-Professional-Weather-System.product.100086588.html).

The La Crosse has been a great weather station for me: easy to set up, accurate reporting, and no interaction required.  One of the features it came with that I was most excited about was internet connetivity.  The station comes with a gateway that wirelessly (900MHz, not wifi) links up with the other components of the weather station, which also link wirelessly.  Good system in theory, but it's only set up to send data to La Crosse Alerts™, a website which I can best describe as functional.

[{% img https://farm8.staticflickr.com/7241/13623412293_bdc93cd82f_z.jpg [1097] [793] 'The main view of La Crosse Alerts™' %}](https://www.flickr.com/photos/dinomite/13623412293/)

Since the output of the gateway is simply data on the wire, I figured it'd be possible to capture the communication between the gateway and the La Crosse Alerts™ server.  The first step in such a journey is to look around and see what other folks have found, and what a productive step that was this time.

I stumbled across a [thread on WXForum](http://www.wxforum.net/index.php?topic=14299.0) of folks discussing the GW1000U, which is the gateway that is part of the C84612 weather station.  If you read through there, you'll see that [skydvrz](http://www.wxforum.net/index.php?action=profile;u=11566) has put in a ton of effort and reverse engineer the communication.  He has written a Windows program that takes the place of the La Crosse Alerts server, collecting data from the gateway and storing it in MySQL.  Create an account on the forum and ask skydvrz for the latest code.

The best part about this replacement server is that it sends dtaa to Weather Underground, which has a [much better interface for weather stations](http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KVAARLIN28), providing history & graphs that are far superior to La Crosse's site.
