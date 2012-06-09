require 'rspec'

describe Skyrocket::AssetWriter do
  let(:asset) { Skyrocket::Asset.new('/one', 'three/test.html.erb', '/two', Skyrocket::ErbProcessor.new) }
  let(:aw) { Skyrocket::AssetWriter.new }
  before do
    asset.stub(:content).and_return('inner')
  end
  context 'file did not previously exist' do
    before { File.stub(:exist?).and_return(false) }
    it 'should create a file if it did not previously exist' do
      FileUtils.stub(:mkdir_p)
      File.should_receive(:write_file).with('/two/three/test.html', 'inner')
      aw.write(asset).should == :created
    end
    it 'should create a directory recusively if the dir does not exist' do
      FileUtils.should_receive(:mkdir_p).with('/two/three')
      File.should_receive(:write_file).with('/two/three/test.html', 'inner')
      aw.write(asset).should == :created
    end
  end
  context 'file previously existed' do
    before { File.stub(:exist?).and_return(true) }
    it 'should modify a file if it previously existed but has changed' do
      File.stub(:read).with('/two/three/test.html').and_return('inner2')
      File.should_receive(:write_file).with('/two/three/test.html', 'inner')
      aw.write(asset).should == :modified
    end
    it 'should leave a file unchanged if it is the same as an existing file' do
      File.stub(:read).with('/two/three/test.html').and_return('inner')
      File.should_not_receive(:write_file)
      aw.write(asset).should == :no_change
    end
  end

  context '#delete' do
    it 'should delete a file and no directories if unempty' do
      Dir.stub(:entries).with('/two/three').and_return(['hello'])
      File.should_receive(:delete).with('/two/three/test.html')
      Dir.should_not_receive(:rmdir)
      aw.delete(asset)
    end
    it 'should delete a file and any empty parent directories' do
      Dir.stub(:entries).with('/two/three').and_return([])
      Dir.stub(:entries).with('/two').and_return(['hello'])
      File.should_receive(:delete).with('/two/three/test.html')
      Dir.should_receive(:rmdir).with('/two/three')
      Dir.should_not_receive(:rmdir).with('/two')
      Dir.should_not_receive(:rmdir).with('/')
      aw.delete(asset)
    end
  end
end
