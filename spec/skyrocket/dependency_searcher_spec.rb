require 'rspec'

class TestNode
  attr_reader :name, :children
  def initialize(name, children = Array.new)
    @name = name
    @children = children
  end
end

describe Skyrocket::DependencySearcher do
  it 'should return an ordered list of dependencies' do
    node = TestNode.new("three", [TestNode.new("two", [TestNode.new("one")])])
    results = Skyrocket::DependencySearcher.deps(node)
    results.should have(3).items
    results[0].name.should == "one"
    results[1].name.should == "two"
    results[2].name.should == "three"
  end
    
  it 'should exclude duplicate dependencies' do
    node = TestNode.new("three", [TestNode.new("two", [TestNode.new("one")]), TestNode.new("one")])
    results = Skyrocket::DependencySearcher.deps(node)
    results.should have(3).items
    results[0].name.should == "one"
    results[1].name.should == "two"
    results[2].name.should == "three"
  end

  it 'should raise on circular reference' do
    node = TestNode.new("one", [TestNode.new("two", [TestNode.new("one")])])
    lambda { Skyrocket::DependencySearcher.deps(node) }.should raise_error(Skyrocket::CircularReferenceError)
  end
end
