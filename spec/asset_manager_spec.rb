require 'rspec'

describe Skyrocket::AssetManager do
  describe '#initialize' do
    it 'should initialize :asset_dirs, :lib_dirs, :output_dir, :base_url, :style' do
      am = Skyrocket::AssetManager.new(:asset_dirs => ['one', 'two'],
                                       :lib_dirs => ['three', 'four'],
                                       :output_dir => 'five',
                                       :base_url => '/blog',
                                       :style => :minified)
      am.asset_dirs[0].should match /\/one$/
      am.asset_dirs[1].should match /\/two$/
      am.lib_dirs[0].should match /\/three$/
      am.lib_dirs[1].should match /\/four$/
      am.output_dir.should match /\/five$/
      am.base_url.should == '/blog'
      am.style.should == :minified
    end
  end
end