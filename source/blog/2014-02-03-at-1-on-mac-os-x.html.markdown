---
title: "at(1) on Mac OS X"
date: 2014-02-03
comments: true
tags: 
---
at(1) is a standard command in [every](http://www.freebsd.org/cgi/man.cgi?query=at&sektion=1) [Unix-like](http://unixhelp.ed.ac.uk/CGI/man-cgi?at) [operating](http://www.openbsd.org/cgi-bin/man.cgi?query=at&apropos=0&sektion=0&manpath=OpenBSD+Current&arch=i386&format=html) [system](http://www.shrubbery.net/solaris9ab/SUNWaman/hman1/at.1.html) [that](http://illumos.org/man/1/at) [I](http://www.unix.com/man-page/opensolaris/1/at/) [know](http://plan9.bell-labs.com/magic/man2html?man=at&sect=1) [of](http://netbsd.gw.com/cgi-bin/man-cgi?at++NetBSD-current), including [Mac OS](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/at.1.html), for scheduling tasks to be run at a later time.  Unfortunately, OS X doesn't run (or even seem to have) atd(8), the daemon responsible for running at(1)-scheduled tasks.  Complicating matters is the fact that at(1) is a very difficult to search for, because search engines strip such common words, so figuring out such issues can't really be done with even the best searching.  So here I'll list other things that one might search for: atq, atrm, and batch, which are all part of the at(1) suite of tools.

My (likely vain) hope is that this post will spread a bit of knowledge and maybe catch searches, if someone's searches match my description.
