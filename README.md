A tracing gem... for making it easy to trace execution and extract meaningful knowledge.

- it just needs to be useful, for me

- it should let someone who doesn't know about set_trace_func get something useful out of it
  - if people want to mega-customize it, they can just write their own trace_func

- doesn't have to be big, just has to be useful
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

- watchpoints?


- statsd output?
