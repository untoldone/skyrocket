require 'rspec'

describe Skyrocket::AssetWriter do
  let(:asset) { Skyrocket::Asset.new('/one', 'test.html.erb', '/two', nil) }
  let(:aw) { Skyrocket::AssetWriter.new }
  before do
    asset.stub(:output_path).and_return('/one/test.html')
    asset.stub(:content).and_return('inner')
  end
  context 'file did not previously exist' do
    before { File.stub(:exist?).and_return(false) }
    it 'should create a file if it did not previously exist' do
      FileUtils.stub(:mkdir_p)
      File.should_receive(:write_file).with('/one/test.html', 'inner')
      aw.write(asset).should == :created
    end
    it 'should create a directory recusively if the dir does not exist' do
      FileUtils.should_receive(:mkdir_p).with('/one')
      File.should_receive(:write_file).with('/one/test.html', 'inner')
      aw.write(asset).should == :created
    end
  end
  context 'file previously existed' do
    before { File.stub(:exist?).and_return(true) }
    it 'should modify a file if it previously existed but has changed' do
      File.stub(:read).with('/one/test.html').and_return('inner2')
      File.should_receive(:write_file).with('/one/test.html', 'inner')
      aw.write(asset).should == :modified
    end
    it 'should leave a file unchanged if it is the same as an existing file' do
      File.stub(:read).with('/one/test.html').and_return('inner')
      File.should_not_receive(:write_file)
      aw.write(asset).should == :no_change
    end
  end
end
