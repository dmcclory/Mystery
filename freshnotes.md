

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
