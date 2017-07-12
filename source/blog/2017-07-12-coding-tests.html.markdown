---
title: Coding Tests
date: 2017-07-12 12:17 UTC
tags: Programming, Hiring
#published: false
---
Hiring for developers is tricky business for many reasons, but one of the most contentious is assessing technical ability.  Anyone who has done hiring, in particular for junior developers, has come across [candidates that couldn't write the simplest of programs](https://blog.codinghorror.com/why-cant-programmers-program/).  Thus we find ourselves in a world where technical interviews often involve whiteboard coding or coding tests.

# Whiteboard Coding

The short summary: whiteboard coding is almost always a bad idea—it doesn't really assess what you're looking for.

Many interviewers, who either haven't ever experienced whiteboard coding or who themselves possess exceptional social fortitude, think that whiteboard coding is a great way to assess a candidate's programming ability and see how they think.  Unfortunately, the unnaturalness of writing code in a stressful situation, by hand, with an audience, without being able to test it leaves many developers in a flustered state unable to think.

A year after college I was working at a job I slid into by way of prior internships.  I hadn't ever actually interviewed for a technical job.  I wanted something more challenging and interesting than that position, so I applied to Google.  After phone screens they invited me on site.  The second interview was with a pair of programmers who wanted me to do something simple, akin to [FizzBuzz](http://wiki.c2.com/?FizzBuzzTest).

I was incredibly flustered—I knew modular division was what was required but that wasn't something I had done since CS1 (note: I have more fingers than times I've employed modular division now, in 10 years of professional software engineering).  Even though it's a trivial problem, even with very little experience, my initial surprise completely subverted my ability to even start thinking about the program critically.  I started just writing things on the board and eventually stumbled through the exercise but it was clear that was the last interview.

# Live Coding

"*Ah-ha!*", you think, "*I'll give them a great setup to eliminate the unnatural situation of coding by hand on a whiteboard!  We'll have an interviewee laptop that they can use with the best IDE!*".  That's a great step, but doesn't solve the biggest problem: the audience.  Programming is a largely solitary activity, especially for more junior engineers.  I definitely think that collaboration and things like pair programming are important, but to pretend that such a lopsided, I'm-evaluating-you-right-now arrangement is at all like pair programming is to [completely misunderstand what the paradigm is about](https://www.youtube.com/watch?v=dYBjVTMUQY0).

Beyond that, know that the technical environment you are providing is invariably unnatural as well.  Developers may only have experience on Windows and you provide them with a Mac.  They might work in an IDE like WebStorm or Eclipse and your setup is Sublime with a terminal.  Those problems are significant enough to leave even the best developer in a state of confusion, which begets sheer terror in the interview context, but we haven't even gotten to the biggest problem.

If you expect a developer to be able to write code in such a stressful situation the only way they will be successful and not look completely daft to even a casual observer is to allow them to write in a language that they currently use.  That doesn't mean anything from their resume, or what your company is hiring them to write, that means a language that they have actively used in the past week or two.  Working in multiple languages involves a switching period to bring the correct syntax to mind—that can be a few minutes if you've only been out of it for a week, but can easily be tens of minutes filled with repeated web searches for the most trivial language constructs (`else if` or `elsif`? how do I for-each?).  Realize that forcing a developer to ask such basic questions both poisons your opinion of them (shouldn't you at least know *that*?) and puts them in a dreadful state of mind (I couldn't even remember *that*!).

Finally, as we'll get to later, any sort of coding test requires significant up-front effort on the company's part.

# Take-home coding tests

A take-home coding test solves all of the aforementioned problems.  Candidates get to use an devlopment environment of their preference, aren't under live scrutiny, and get to work in the manner that is best for them.  For all of these reasons, I quite like take-home coding tests, but the rightly get a lot of hate from other developers for a few reasons.

## Time

The exercise needs to be time limited and of a reasonable scope, **3-5 hours at most**.  That doesn't mean saying "don't spend more than 3-5 hours on this" in your description.  I've seen many coding tests that stipulate a time limit, but also mention that applicants will be graded on tests, error handling, dealing with unexpected input, and documentation.  Even when applied to a very small project, those tasks alone can comprise 3-5 hours of work.  It is not reasonable to ask a developer applying to your company to spend more than 2-3 hours, with a very maximum cap of five, working on your test.  If nothing else, you're going to lose nearly all of them to companies without such onerous requirements.

## Expectations

Having realistic and flexible expectations is paramount.  No matter the developer's level of experience, how you're querying them, or how thorough your explanation, without the ability to ask questions in real-time **your test will be misunderstood**.

"*But we're a consulting shop! Our developers have to build precisely what the customer needs from a spec all the time!*" you protest.  Doesn't matter—the candidate isn't part of your work environment, hasn't met the customer, and is working on a contrived project of highly limited scope.  A coding test isn't a good way to thoroughly test developer's abilities to understand and implement specs.

Some will implement a totally working solution that misses the point.  Others will have a great implementation but only a single simple test.  For an otherwise good candidate, neither of these should be deal breakers and you absolutely shouldn't decline them without talking to them.  **Schedule a call and talk to them about how they approached the problem**, their interpretation of it, and what steps they took in building their solution.

# Doing it right

## Take-home coding tests

For junior developers, your coding test should be at the very least a full project setup: in Java land that means a `pom.xml` or `build.gradle` already stubbed out and a main method ready to receive the candidate's code.  In Ruby you might stub out the main script with calls to a class that the candidate is to write, along with a `Gemfile` if they're expected to use any Gems.  There are many great junior developers who haven't ever started a new project.

Better than that, though, is to write out the entirety of the app, save for a couple of unimplemented methods or a stubbed class which the candidate is to complete.  You might provide a suite of failing test cases in the framework but if not you should go ahead and create the files & classes required.  See [this example](https://github.com/adhocteam/homework/tree/master/fetch) from [Ad Hoc](https://adhocteam.us).

For more senior developers, it is ok to leave things much more open ended—it shouldn't be beyond a senior developer's skill to choose & create the layout of their project.  Because it is more open ended, however, there is a much more significant burden on the company to ensure that the description of the test is comprehensive and clear.  You need to provide the candidate with test input & output (more than just one parcel) that they can understand what you're looking for.  Being senior doesn't mean they can read your mind.

How do you know if you've met the above?  **Have one of your engineers who wasn't involved at all in the creation take the test** and see how they do, both on time and how their peers evaluate the result.  Needless to say, this should be on the clock—this person is your employee, not a candidate.

## Live coding

For live coding, regardless of level, the arrangement should be the most fleshed-out description for junior developers above: **a fully written app with a few unimplemented methods or classes that the candidate is to fill in**.  If they're going to need helper methods (to parse input or some such) provide them.  Again, for junior developers provide at least some tests; ask them what others they would add.

Here's where the real burden comes in: you need this framework for a language that the candidate is accustomed to, even if it's not the language you're hiring for.  Most companies hire developers even if they don't regularly program in the language used at the company and a developer can only be exptected to work effectively in a language that they use regularly.  You should have frameworks prepared for common languages—Java, Ruby, Python, and JavaScript is a good start for a webdev shop.  If you're more backend focused, C & Go probably replace JS.  More frontend, add in Swift or Objective-C.

Know that this is still a risky proposition and you need to be understanding enough not fail a candidate just because they seem to have trouble, especially right when you start.  Even with a fleshed out framework in their language of choice, remember that they're not using a computer they're used to and that they're massively on display in what is normally an endeavor done alone or with someone you already know well.

## Whiteboard coding

Whiteboard coding isn't a good idea, especially for junior developers.  A whiteboard coding session is more likely to select for confidence in demanding social situations than those with programming aptitude.

For senior developers, however, whiteboarding at a higher level (architecture) is a great interview tool.  Describe to the candidate some real problem that your team had and ask them how they would solve it.  Be prepared to give copious hints and don't mark down candidates who need that help—it is very easy for a stressed-out candidate to misinterpret your quetion, even just the complexity level you're going for, and be completely caught off guard.
