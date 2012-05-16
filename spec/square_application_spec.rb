require 'rspec'
require 'rack/builder'
require 'rack/test'

describe Skyrocket::SquareApplication do
  include Rack::Test::Methods

  before :all do
    @app = Skyrocket::SquareApplication.new("/blog/hello.txt" => 'Hello World!')
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