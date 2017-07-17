
class Mystery
  class EventWrapper
    attr_reader :event_name
    attr_reader :file_name
    attr_reader :line
    attr_reader :method
    attr_reader :class_name

    def initialize(event_name, file_name, line, method, binding, class_name)
      @event_name = event_name
      @file_name = file_name
      @line = line
      @method = method
      @binding = binding
      @binding_hash = binding_to_hash(binding)
      @class_name = class_name
    end

    def binding
      @binding_hash
    end

    private
    def binding_to_hash(binding)
      vars = binding.local_variables + [:self]
      vars.inject({}) { |memo, var|
        memo[var] = binding.eval var.to_s
        memo
      }
    end
  end

  attr_reader :events

  def initialize(opts)
    @output = opts[:output] || STDOUT
    @path = opts[:path] ? Regexp.new(opts[:path]) : nil
    @event_names = opts[:event_names] || []
    @variables = opts[:variables] || []
    @contexts  = opts[:contexts] || []
    @methods   = opts[:methods]  || []
    @events    = []
    @trace_func = lambda { |event, file, line, id, binding, classname|
      if acceptable_file?(file) && acceptable_method?(id) && @event_names.any? { |x| x == event } && acceptable_context?(binding.eval('self'))
        @output.puts [event, file, line, id, binding_to_hash(binding).inspect, classname].inspect
      end
    }
    @tp_func = TracePoint.new(:call, :return, :line) do |tp|
      if acceptable_file?(tp.path) && acceptable_method?(tp.method_id) && @event_names.any? { |x| x == tp.event.to_s } && acceptable_context?(tp.self)
        @output.puts [tp.event, tp.path, tp.lineno, tp.method_id, binding_to_hash(tp.binding).inspect, tp.self.class].inspect
      end
    end

    @empty_proc = lambda { |event, file, line, id, binding, classname| }
  end

  def start!
    @tp_func.enable
    self
  end

  def stop!
    @tp_func.disable
    self
  end

  def trace_func
    @trace_func
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

  def acceptable_method? method
    return true if @methods.empty?
    @methods.any? { |m| m == method }
  end

  def binding_to_hash(binding)
    vars = if @variables.empty?
             binding.eval('local_variables') + [:self]
           else 
             (binding.eval('local_variables') + [:self]).select { |var| @variables.include? var }
           end
    vars.inject({}) { |memo, var|
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
