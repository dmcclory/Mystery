A tracing gem... for making it easy to trace execution and extract meaningful knowledge.

- it just needs to be useful, for me

- list of variables to watch
- list of variables to exclude
- list of functions to watch

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


- watchpoints?

- wow, if you modify the inputs at a certain step
  - and check to see if the error occurs ....

- don't stomp on an already defined set_trace_func
  - can't have more than one by default?
  - but you can use set_trace_func itself to capture new trace funcs
  - you could *maybe* grab the proc being passed in to another set_trace_fun
    - nope, can't capture the procs which are passed to set trace func

- statsd output?

- random Qs
  - other rubies?
    - works with JRuby
    - works with ruby 1.9

  - does it trace methods you invoke in your own trace func?
    - NOPE! "Tracing is disabled within the context of proc." - from ri docs
