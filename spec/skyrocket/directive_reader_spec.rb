require 'rspec'

describe Skyrocket::DirectiveReader do
  let(:a) do
    o = Object.new
    o.stub(:raw).and_return(<<-eos
    # some comment 
    #= require 'hello'
    #= require 'world'
    the other thing
    #sdfsdf
    something in the body
    eos
    )
    o
  end

  it 'should read all required directives' do
    rr = Skyrocket::DirectiveReader.read_required(a)
    rr.should == ["hello", "world"]
  end

  it 'should read the body' do
    body = Skyrocket::DirectiveReader.read_body(a)
    r = <<-eos
    the other thing
    #sdfsdf
    something in the body
    eos
    body.should == r
  end
end
