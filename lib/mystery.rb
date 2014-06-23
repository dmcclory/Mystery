
class Mystery

  def initialize(opts)
    @output = opts[:output] || STDOUT
    @path = opts[:path] ? Regexp.new(opts[:path]) : nil
    @events = opts[:events]
    @variables = opts[:variables] || []
    @contexts  = opts[:contexts] || []
    @trace_func = lambda { |event, file, line, id, binding, classname|
      if acceptable_file?(file) && @events.any? { |x| x == event } && acceptable_context?(binding.eval('self'))
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

  def acceptable_context? object
    return true if @contexts.empty?
    @contexts.any? { |c| c == object }
  end

  def acceptable_file? filename
    return true if @path.nil?
    @path =~ filename
  end

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
