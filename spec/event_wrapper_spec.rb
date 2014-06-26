require_relative 'spec_helper'

describe Mystery::EventWrapper do
  let(:object) { Object.new }
  let(:binding) {
    object.instance_eval { x = 500; binding }
  }
  let(:event_name) { "c-call" }
  let(:file_name)  { "awesome.rb" }
  let(:line)       { 42 }
  let(:method)     { :awesome }
  let(:class_name) { Class.new }

  let(:event) { [event_name, file_name, line, method, binding, class_name] }
  let(:event_wrapper) { described_class.new(*event) }


  describe "#event_name" do
    it "returns the event name" do
      expect(event_wrapper.event_name).to eq event_name
    end
  end

  describe "#file" do
    it "returns the filename" do
      expect(event_wrapper.file_name).to eq file_name
    end
  end

  describe "#line" do
    it "returns the line number from" do
      expect(event_wrapper.line).to eq line
    end
  end

  describe "#binding" do
    it "returns a hash-like mapping local variables to values" do
      expect(event_wrapper.binding[:x]).to eq 500
    end
    it "makes the callee available as :self" do
      expect(event_wrapper.binding[:self]).to eq object
    end
  end

  describe "#class" do
    it "returns the class of the callee object" do
      expect(event_wrapper.class_name).to eq class_name
    end
  end
end
