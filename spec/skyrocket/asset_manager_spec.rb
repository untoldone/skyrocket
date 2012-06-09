require 'rspec'

describe Skyrocket::AssetManager do
  it 'compiles all new files'
  it 'compiles all updated files'
  it 'deletes all deleted files'
  context '#watch' do
    it 'calls update on file update'
    it 'calls delete on file deleted'
    it 'calls add on file created'
  end
end
