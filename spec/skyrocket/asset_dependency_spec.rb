require 'rspec'

describe Skyrocket::AssetDependency do
  let(:af) do
    o = Object.new
    o.stub(:from_name).with("zero").and_return("zero")
    o.stub(:from_name).with("one").and_return("one")
    o.stub(:from_name).with("two").and_return("two")
    o
  end

  let(:ad) do
    Skyrocket::AssetDependency.new("zero", af)
  end

  before do
    tr = ["one", "two"]
    Skyrocket::DirectiveReader.stub(:read_required).and_return(tr, [], [])
  end

  it 'should return the assets name' do
    ad.name.should == "zero"
  end
    
  it 'should return all child assets' do
    c = ad.children.map{|c|c.asset}.should == ["one", "two"]
  end
end
