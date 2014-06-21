A tracing gem... for making it easy to trace execution and extract meaningful knowledge.

- it just needs to be useful, for me

- it should let someone who doesn't know about set_trace_func get something useful out of it
  - if people want to mega-customize it, they can just write their own trace_func

- doesn't have to be big, just has to be useful
  - have to be able to use it with Rails
  - right now it produces WAAAAAAAAAAAAAAAAY to much output
  - will need to not output all of the rack stuff
  - or you can have a .mystery_ignore file
  - or a :rails_mode => true
  - or we only print out changes after the first

- would be cool if you could use it in rails mode so that you change config between requests

- pass it a file handle or path, or let it write to a default location
- pass it a file handle for focusing on code from particular files

- custom code - block is passed in, evaluated at each step
  - augment it

- don't stomp on an already defined set_trace_func
  - maybe you can have more than one by default?
  - NOPE
  - but you can use set_trace_func itself to capture new trace funcs
  - nope, can't capture the procs which are passed to set trace func
  - (though of course, I could)
  - or you could block anyone else from using set trace_func
  - or just puts some output before letting it run
  - you could use raise to prevent code from running
    - but you can't have a globa rescue w/o a begin, it looks like

- list of variables to watch
- list of variables to exclude
- list of functions to watch


- watchpoints?

- wow, if you modify the inputs at a certain step
  - and check to see if the error occurs ....


- statsd output?

- random
  - works with JRuby
  - works with ruby 1.9
