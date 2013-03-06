Testality is a local testing platform for web developers. Its goals are to manage
the other things in the process of test driven development and front-end testing
so that the developer is free to use their time and thought focused on the problem
at hand.

**This is a prototype of the final project**, it needs a lot more error handling
before this is a real life version. Feel free to help out. 

It is currently written in Ruby for ease of installation in a development 
environment due to the fact that many other front-end tools exist in Ruby. If you 
have better ideas or arguments for language selection let me know.

## Installing

To install, checkout the source and install the gem in the root directory...

    gem install testality

To start up Testality simply run...

    testality

It will serve all JavaScript files contained within the current directory.

## Configuration

You can specify the directories and files to serve...

    testality path/to/src,path/to/tests

You can also specify the port for running and monitoring the tests...

    testality -p 9191

And the port that the monitoring interface receives updates on...

    testality -m 9292

# Todo

- To add the gem to the repository when ready.
- Redesign hook in to allow ordering of the resources based upon dependency,
  ideally this responsibility could be externalized. Ideally also individual
  files should be included separately to assist the stack trace.

Explore integration with:

- QUnit
- JSUnit
- Sprockets
- RequireJS
- YUI

# Expansion

## Front-end design testing

Hash the current fileset, when the browser is refreshed it reports this hash
to the test platform. When a new hash is created all the browsers that have
been connected are reported as stale. When they are refreshed to test this
is then flagged green.

## Server-side cross-platform testing