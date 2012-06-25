require 'rspec'
require 'skyrocket'

describe Skyrocket::Asset do
  class TestProcessor
    include Skyrocket::Processor
    def post_process_name(h); "blah.html"; end
    def process_contents(c, n); "processed!"; end
  end

  let(:processor) { TestProcessor.new }
  let(:asset) { Skyrocket::Asset.new('/one', 'two.html.erb', '/two', processor) }
 
  it 'should return an output_path adjusted for processor extension and with output_dir' do
    asset.output_path.should == '/two/blah.html'
  end

  it 'should return raw content of asset' do
    File.stub(:read).with('/one/two.html.erb').and_return('hello')
    asset.raw.should == 'hello'
  end

  it 'should return processed content of asset' do
    File.stub(:read).with('/one/two.html.erb').and_return('hello')
    asset.content.should == 'processed!'
  end
end
