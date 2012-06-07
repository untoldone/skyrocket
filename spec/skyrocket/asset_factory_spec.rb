require 'rspec'

describe Skyrocket::AssetFactory do
  let(:factory) { Skyrocket::AssetFactory.new(['/one'], ['/two'], '/three') }
  it 'should build assets with dir, name, and out_dir' do
    Skyrocket::Asset.stub(:new)
                      .with('/one', 'other.html', '/three')
                      .and_return('You Got Me')
    asset = factory.build_asset('/one/other.html')
    asset.should == "You Got Me"
  end

  it 'should fail if filepath out of dirs' do
    lambda { factory.build_asset('unknown') }.should raise_error(Skyrocket::PathNotInAssetsError)
  end
end
