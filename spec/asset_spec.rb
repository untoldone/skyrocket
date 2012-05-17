require 'rspec'
require 'skyrocket/asset'

describe Skyrocket::Asset do
  before(:all) do 
    @a = fixture_asset_manager.asset('stylesheets/all')
  end

  describe '#path' do
    it 'should return the correct absolute path' do
      @a.path.should == '/blog/stylesheets/all.css'
    end
  end

  describe '#content' do
    it 'should contain the correct content' do
      @a.content.should == %Q(

.second {
  width: 45px;
}
      )
    end

    describe '#required_assets' do
      it 'should have the correct related assets' do
        @a.required_assets.should = ['stylesheets/other.css']
      end
    end

    describe '#required_paths' do
      it 'should have the correct related paths' do
        @a.required_paths.should = ['/blog/stylesheets/other.css']
      end
    end
  end
end