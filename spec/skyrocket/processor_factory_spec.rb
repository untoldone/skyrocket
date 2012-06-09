require 'rspec'

describe Skyrocket::ProcessorFactory do
  let(:pf) { Skyrocket::ProcessorFactory.new }
  it 'should state a file with a processor extention is processed' do
    pf.process?('someone.html.erb').should be_true
  end

  context '#post_process_name' do
    it 'should return an processor name if a processor exists' do
      pf.post_process_name('someone.html.erb').should == 'someone.html'
    end
    
    it 'should return a empty-processor name if a processor does not exist' do
      pf.post_process_name('someone.html').should == 'someone.html'
    end
  end

  it 'should return a valid processor' do
    pf.processor('someone.html.erb').should be_an_instance_of Skyrocket::ErbProcessor
  end
end
