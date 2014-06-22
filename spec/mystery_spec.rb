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

    context "selecting events to output" do
      let(:empty_binding) { EMPTY_BINDING }
      let(:c_call_event) {
        ['c-call', 'bar/baz/foo.rb', 30, :awesome, empty_binding, Object.new]
      }
      let(:return_event) {
        ['return', 'bar/baz/foo.rb', 30, :awesome, empty_binding, Object.new]
      }

      it "ands together the columns" do
        m = Mystery.new({ :path => "/foo", :events => ['c-call'], :output => output_loc})
        m.trace_func.call(*return_event)
        m.trace_func.call(*c_call_event)
        expect(output).to match /c-call/
        expect(output).not_to match /return/
      end

      it "ors together multiple arguments to a column" do
        m = Mystery.new({ :path => "/foo", :events => ['c-call', 'return'], :output => output_loc})
        m.trace_func.call(*return_event)
        m.trace_func.call(*c_call_event)
        expect(output).to match /c-call/
        expect(output).to match /return/
      end
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
        m = Mystery.new({ :path => "great.rb", :events => ['c-call'], :variables => [:foo, :bar], :output => output_loc})
        m.trace_func.call(*foo_bar_baz_event)
        expect(output).to     match /foo/
        expect(output).to     match /bar/
        expect(output).not_to match /baz/
      end
    end
  end
end
