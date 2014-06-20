
class Mystery

  def initialize(opts)
    @path = Regexp.new opts[:path]
    @proc = lambda { |event, file, line, id, binding, classname|
      if file =~ @path
        puts [event, file, line, id, binding_to_hash(binding).inspect, classname].inspect
      end
    }

    @empty_proc = lambda { |event, file, line, id, binding, classname| }
  end

  def start!
    set_trace_func @proc
  end

  def stop!
    set_trace_func @empty_proc
  end

  private

  def binding_to_hash(binding)
    vars = binding.eval('local_variables') + [:self]
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
