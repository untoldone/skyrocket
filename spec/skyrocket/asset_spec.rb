require 'rspec'
require 'skyrocket'

describe Skyrocket::Asset do
  let(:dir) { File.expand_path('../../fixture', __FILE__) }
  let(:am) do 
    Skyrocket::AssetManager.new(
      :asset_dirs => [dir + '/assets/public'],
      :lib_dirs => [],
      :output_dir => dir + '/public',
      :base_url => '/',
      :style => 'minify')
  end
  before(:all) { Skyrocket::Asset.cache_all(am) }
  describe '#initialize' do
    let(:asset) { Skyrocket::Asset.new(dir + '/assets/public/test.html.erb') }
    it 'should set the filepath' do
      asset.name.should == 'test.html'
    end

    context 'filepath starts with an asset_dir' do
      it 'should set the dir' do
        asset.dir.should == "#{dir}/assets/public"
      end
      context 'processor should process a filepath' do
        it 'should set the processor class' do
          asset.processor.class.should == Skyrocket::ErbProcessor
        end
      end
    end
  end
end
