
class Mystery

  def initialize(opts)
    @output = opts[:output] || STDOUT
    @path = Regexp.new opts[:path]
    @events = opts[:events]
    @variables = opts[:variables] || []
    @trace_func = lambda { |event, file, line, id, binding, classname|
      if file =~ @path && @events.any? { |x| x == event }
        @output.puts [event, file, line, id, binding_to_hash(binding).inspect, classname].inspect
      end
    }

    @empty_proc = lambda { |event, file, line, id, binding, classname| }
  end

  def start!
    Kernel.set_trace_func trace_func
    self
  end

  def stop!
    Kernel.set_trace_func blank_trace_func
    self
  end

  def trace_func
    @trace_func
  end

  def blank_trace_func

  end

  private

  def binding_to_hash(binding)
    vars = (binding.eval('local_variables') + [:self]).select { |var| @variables.include? var }
    hash = vars.inject({}) { |memo, var|
      val = binding.eval(var.to_s)
      if val == self
        memo
      else
        memo[var] = val
        memo
      end
    }
  end
end
