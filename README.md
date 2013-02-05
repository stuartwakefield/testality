**This is a prototype of the final project**, it needs a lot more error handling
before this is a real life version...

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

## Todo

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