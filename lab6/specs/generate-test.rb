require_relative './helper.rb'
require_relative '../generate.rb'
# load, because 1.9.1's require/require_relative balk when there's a file extension they're not expecting
load(File.dirname(Dir.pwd) + '/lab6_files.cgi')

describe "Generate" do
  before do
    @tested=Generate.new
  end

  it 'is tested in the development environment' do
    @tested.is_production?.must_equal false
  end

  it 'is configured to work under the system tmp heirarchy' do
    @tested.path.must_match /^\/tmp\//
  end
  
  it 'has a path config that matches lab6_files path config' do
    @tested.path.must_equal Lab6Files.new.path
  end
end
