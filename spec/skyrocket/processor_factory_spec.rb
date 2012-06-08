require 'rspec'

describe Skyrocket::ProcessorFactory do
  let(:pf) { Skyrocket::ProcessorFactory.new }
  it 'should state a file with a processor extention is processed' do
    pf.process?('someone.html.erb').should be_true
  end

  it 'should not state a file without processor extension is proceed' do
    r = pf.process?('someone.html')
    r.should_not be_nil
    r.should be_false
  end

  it 'should return a valid processor' do
    pf.processor('someone.html.erb').should be_an_instance_of Skyrocket::ErbProcessor
  end

  it 'should raise when no processor is needed when accessing a processor' do
    lambda { pf.processor('someone.html') }.should raise_error(Skyrocket::NoValidProcessorError)
  end
end
