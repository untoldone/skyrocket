require 'rspec'
require 'rack/builder'
require 'rack/test'

describe Skyrocket::AssetApplication do
  include Rack::Test::Methods

  class FakeManager
    def asset_by_path(asset)
      asset == '/blog/hello.txt' ? 'Hello World!' : nil
    end
  end

  before :all do
    @app = Skyrocket::AssetApplication.new(FakeManager.new)
  end

  def app
    @app
  end

  it 'should serve an existing file' do
    get '/blog/hello.txt'
    last_response.status.should == 200
    last_response.body.should == 'Hello World!'
  end

  it 'should 404 a non-existent file' do
    get '/blog/joe.txt'
    last_response.status.should == 404
  end
end