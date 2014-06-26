require_relative './spec_helper'

EMPTY_BINDING = binding

describe Mystery do

  describe "initialize" do
    it "creates a trace_func based on a hash of arguments"
  end

  describe "#start!" do
    before do
      allow(Kernel).to receive(:set_trace_func)
    end
    it "sets the process's trace_func to our custom trace func" do
      expect(Kernel).to receive(:set_trace_func)
      k = Mystery.new({:path => "/foo"})
      expect(k).to receive(:trace_func)
      k.start!
    end
    it "returns itself" do
      m = Mystery.new({:path => "/foo"})
      result = m.start!
      expect(result).to equal m
    end
  end

  describe "#stop!" do
    before do
      allow(Kernel).to receive(:set_trace_func)
    end
    it "sets the process's trace_func to an empty func" do
      expect(Kernel).to receive(:set_trace_func)
      m = Mystery.new({:path => "/foo"})
      expect(m).to receive(:blank_trace_func)
      m.stop!
    end
    it "returns itself" do
      m = Mystery.new({:path => "/foo"})
      result = m.stop!
      expect(result).to equal m
    end
  end

  describe "build_trace_func" do
    it "converts file names to regexes"
    it "converts event types to strings"
    it "converts method names to symbols"
  end

  describe "trace_func" do
    let(:output_loc) { StringIO.new }
    let(:output) { output_loc.rewind; output_loc.read }
    let(:empty_binding) { EMPTY_BINDING }

    context "for analyzing the events later on" do
      let(:c_call_event) {
        ['c-call', 'bar/baz/foo.rb', 30, :awesome, empty_binding, Object.new]
      }
      it "stores the events in an array" do
        m = Mystery.new({ :path => "/foo", :event_names => ['c-call'], :output => output_loc})
        m.trace_func.call(*c_call_event)
        m.trace_func.call(*c_call_event)
        expect(m.events.count).to equal 2
        expect(m.events[0].class).to eq Mystery::EventWrapper
      end
    end

    context "selecting events to output" do
      let(:c_call_event) {
        ['c-call', 'bar/baz/foo.rb', 30, :awesome, empty_binding, Object.new]
      }
      let(:return_event) {
        ['return', 'bar/baz/foo.rb', 30, :awesome, empty_binding, Object.new]
      }

      it "ands together the columns" do
        m = Mystery.new({ :path => "/foo", :event_names => ['c-call'], :output => output_loc})
        m.trace_func.call(*return_event)
        m.trace_func.call(*c_call_event)
        expect(output).to match /c-call/
        expect(output).not_to match /return/
      end

      it "ors together multiple arguments to a column" do
        m = Mystery.new({ :path => "/foo", :event_names => ['c-call', 'return'], :output => output_loc})
        m.trace_func.call(*return_event)
        m.trace_func.call(*c_call_event)
        expect(output).to match /c-call/
        expect(output).to match /return/
      end
    end

    context "selecting methods" do
      let(:cool_event) {
        ['c-call', 'foo.rb', 30, :cool, empty_binding, Class.new]
      }
      let(:awesome_event) {
        ['c-call', 'foo.rb', 30, :awesome, empty_binding, Class.new]
      }
      context "initialized with a list of method names" do
        it "matches any method name" do
          m = Mystery.new({ :methods => [:awesome], :event_names => ['c-call'], :output => output_loc})
          m.trace_func.call(*awesome_event)
          m.trace_func.call(*cool_event)
          expect(output).to match /awesome/
          expect(output).not_to match /cool/
        end
      end
      context "initialized without a list of methods" do
        it "matches any method name" do
          m = Mystery.new({ :event_names => ['c-call'], :output => output_loc})
          m.trace_func.call(*awesome_event)
          m.trace_func.call(*cool_event)
          expect(output).to match /awesome/
          expect(output).to match /cool/
        end
      end

    end

    context "selecting line numbers" do
      it "can take a Range of line numbers"
      it "can take a list of line numbers"
    end

    context "selecting based on file name" do
      let(:foo_event) {
        ['c-call', 'foo.rb', 30, :awesome, empty_binding, Class.new ]
      }
      let(:bar_event) {
        ['c-call', 'bar.rb', 30, :awesome, empty_binding, Class.new ]
      }
      it "matches anything if the string is empty or nil" do
        m = Mystery.new({ :event_names => ['c-call'], :output => output_loc})
        m.trace_func.call(*foo_event)
        m.trace_func.call(*bar_event)
        expect(output).to match /foo/
        expect(output).to match /bar/
      end
    end

    context "selecting context objects" do
      # this is a special case of variable selection
      # need to use eval('self') but want to make that easier for people
      let(:awesome) { Object.new }
      let(:awesome_binding) {
        awesome.instance_eval { k = 40000; binding }
      }
      let(:awesome_event) {
        ['c-call', 'great.rb', 30, :so_cool, awesome_binding, Class.new]
      }
      let(:lame_event) {
        ['c-call', 'great.rb', 30, :method_missing, lame_binding, Class.new]
      }
      let(:lame_binding) { Object.new.instance_eval { k = 3000; binding } }
      it "takes a list of objects as the context" do
        m = Mystery.new({ :path => "great.rb", :event_names => ['c-call'], :contexts => [awesome], :output => output_loc})
        m.trace_func.call(*awesome_event)
        m.trace_func.call(*lame_event)
        expect(output).to match /so_cool/
        expect(output).not_to match /method_missing/
      end
    end

    context "selecting based on class name" do

    end

    context "selecting varibles to output" do

      let(:foo_bar_baz_binding) {
        foo = Object.new
        bar = Object.new
        baz = Object.new
        binding
      }

      let(:foo_bar_baz_event) {
        ['c-call', 'great.rb', 30, :awesome, foo_bar_baz_binding, Object.new]
      }

      it "only displays variables specified by the user" do
        m = Mystery.new({ :path => "great.rb", :event_names => ['c-call'], :variables => [:foo, :bar], :output => output_loc})
        m.trace_func.call(*foo_bar_baz_event)
        expect(output).to     match /foo/
        expect(output).to     match /bar/
        expect(output).not_to match /baz/
      end
    end
  end
end
