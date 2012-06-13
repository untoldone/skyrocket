require 'rspec'

describe Skyrocket::AssetFactory do
  let(:factory) { Skyrocket::AssetFactory.new(['/one'], ['/two'], '/three') }
  it 'should build assets with dir, name, and out_dir' do
    Skyrocket::Asset.stub(:new)
                      .with('/one', 'other.html', '/three', an_instance_of(Skyrocket::EmptyProcessor))
                      .and_return('You Got Me')
    asset = factory.build_asset('/one/other.html')
    asset.should == "You Got Me"
  end

  it 'should return an asset based off of the asset name' do
    Skyrocket::Asset.stub(:new)
                      .with('/one', 'joe/shmo.html.erb', '/three', an_instance_of(Skyrocket::ErbProcessor))
                      .and_return('You Got Me2')
    Dir.stub('[]').with('/one/joe/shmo.html.*').and_return(['/one/joe/shmo.html.erb'])
    Dir.stub('[]').with('/one/joe/shmo.html').and_return([])
    Dir.stub('[]').with('/two/joe/shmo.html.*').and_return([])
    Dir.stub('[]').with('/two/joe/shmo.html').and_return([])
    factory.from_name('joe/shmo.html').should == "You Got Me2"
  end

  it 'should return an asset based off the asset name if the name matches completely' do
    Skyrocket::Asset.stub(:new)
                      .with('/one', 'joe/shmo.html.erb', '/three', an_instance_of(Skyrocket::ErbProcessor))
                      .and_return('You Got Me2')
    Dir.stub('[]').with('/one/joe/shmo.html.erb.*').and_return([])
    Dir.stub('[]').with('/one/joe/shmo.html.erb').and_return(['/one/joe/shmo.html.erb'])
    Dir.stub('[]').with('/two/joe/shmo.html.erb.*').and_return([])
    Dir.stub('[]').with('/two/joe/shmo.html.erb').and_return([])
    factory.from_name('joe/shmo.html.erb').should == "You Got Me2"
  end

  it 'should fail if asset is not found based off of asset name' do
    Dir.stub('[]').with('/one/joe/shmo.html.*').and_return([])
    Dir.stub('[]').with('/one/joe/shmo.html').and_return([])
    Dir.stub('[]').with('/two/joe/shmo.html.*').and_return([])
    Dir.stub('[]').with('/two/joe/shmo.html').and_return([])
    lambda { factory.from_name('joe/shmo.html') }.should raise_error(Skyrocket::AssetNotFoundError) 
  end

  it 'should fail if filepath out of dirs' do
    lambda { factory.build_asset('unknown') }.should raise_error(Skyrocket::PathNotInAssetsError)
  end
end
