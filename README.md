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

- query-ability is striking me as *very* important
  - the first thing you'd do when you got the output is to try to parse it
  - why not skip the 2 steps and give them something they can use?

- when you have hundreds of rows of well structured, 6-tuples ... you basically have a database table
  - and many Ruby programmers like the style of
  - thinking of emulating the active record interface
  - or using axiom (and whatever other useful pieces of the ROM ecosystem)

- just shovel every place into a growing list for now
  - provide a wrapper method for accessing variables from the binding
  - make sure to stop! before you start poking around with the results

- would be cool if you could use it in rails mode so that you change config between requests

- pass it a file handle or path, or let it write to a default location
- pass it a file handle for focusing on code from particular files

- custom code - block is passed in, evaluated at each step
  - augment it

- custom formatter
  - either an 'sprintf' style string
  - or a printer object, with 1 method
    - that's like a fancy name for yielding the block though.
    - people could just use set_trace_func at that point


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
