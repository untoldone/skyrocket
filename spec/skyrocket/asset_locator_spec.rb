require 'rspec'

describe Skyrocket::AssetLocator do
  let(:af) { Skyrocket::AssetFactory.new(['/one'], ['/two'], '/three') }
  let(:al) { Skyrocket::AssetLocator.new(af) }
  before do
    Dir.stub('glob_files').with('/one/**/*').and_return(['/one/hello.html','/one/other/joe.css'])
    Dir.stub('glob_files').with('/two/**/*').and_return(['/two/another.html'])
  end
    
  it 'should find all assets in a directory' do
    a = al.all_assets
    a.length.should == 2
    a[0].output_path.should == '/three/hello.html'
    a[1].output_path.should == '/three/other/joe.css'
  end

  it 'should find all missing assets' do
    Dir.stub('glob_files').with('/three/**/*').and_return(['/three/hello.html','/three/other/joe.css','/three/junk.html'])
    m = al.missing_asset_paths
    m.length.should == 1
    m[0].should == '/three/junk.html'
  end
end
