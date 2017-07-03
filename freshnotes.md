

# rubygems style:

x = Mystery.new( :output => STDOUT)

x.files /activesupport/

x.variables [:foo, :select]

x.methods [:inject, :select, :camel_case]

x.events ['call', 'c-call', 'c-return', 'line']

x.contexts [Rails.logger]

x.start!
x.stop!

# hash style:

x = Mystery.new(
  :output => STDOUT,
  :files => /activesupport/,
  :variables => [:foo, :select],
  :methods => [:inject, :select, :camel_case],
  :events => ['call', 'c-call', 'c-return', 'line']
  :contexts => [Rails.logger]
).start!

x.start!
x.stop!

- start! and stop! should return self, for chaining
- default should be include all, for something like events

- files/methods/contexts - selects trace lines which match
- variables - once those lines match, select only certain values to output

- or together the arguments for each of the fields, and together those disjunctions

- q's
  - started by default?
  - how to represent negation?
  -

-------------------------

Hello again, 3 years later!

So, the ideas are

- the trace function is fixed right now, but maybe any function should work
  - let them pass it in and make this a global, that it'll load if it's nil (for now)!

- a good way to match on values for variables
  - only do something when the second argument has this value

- all or none as the default (eg, if you make a new one of these,
- enabling or disabling callbacks all
- enabling or disabling callbacks by name

- maybe making this a singleton/class b/c set_trace_func is a global singleton

- actually trying it out in a real bug
  - would need to be able to load it as a gem
  - would need to be able to pass in a specific block something specific

Obvious long term things
  - hey, not just STDOUT, oh that's taken care of
  - docs?

- events as is does not work, when there's thousands of lines of code
  - it needs to be more selective, and probably only happen inside the if block

- match on a class/ancestor name
- show all arguments
