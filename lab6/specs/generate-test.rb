require_relative './helper.rb'
require_relative '../generate.rb'
# load, because 1.9.1's require/require_relative balk when there's a file extension they're not expecting
load(File.dirname(Dir.pwd) + '/lab6_files.cgi')


describe "Generate" do

  before do
    ARGV.clear
    @tested=Generate.new
  end

  it 'is named generate.rb' do
    $".include? File.expand_path("../generate.rb")
  end

  it 'is tested in the development environment' do
    @tested.is_production?.must_equal false
  end

  it 'is temporarily configured to work under the system tmp heirarchy' do
    @tested.script_directory.must_match /^\/tmp\//
  end

  it 'does its work in the same directory that lab6_files reads from' do
    ARGV<< 'foo'
    @tested.script_directory.must_equal Lab6Files.new.path
  end

  it 'sets the load path to include the app base directory' do
    $:.must_include @tested.script_directory
  end

  it 'this argument will be used to name a directory' do
    ARGV.unshift "foo"
    @tested.app_name.must_equal 'foo'
    @tested.app_name.must_equal ARGV[0]
    File.basename(@tested.new_app_directory).must_equal @tested.app_name
  end

  # it 'creates a directory structure populated with directories and files' do
  #   string=''
  #   chars=@tested.ALLOWED_CHARACTERS
  #   8.times { string += chars.sample }
  #   ARGV.unshift(string)
  #   @tested.create
  #   Dir.entries.must_include @tested.app_name
  # end

  it 'can sanitize a string by removing characters that are not acceptable' do
    # fail
    ARGV.clear.unshift'FOOOOOOOOOOOO!'
    @tested.sane?.must_equal false
    ARGV.clear.unshift '1234#'
    @tested.sane?.must_equal false
    ARGV.clear.unshift '/@'
    @tested.sane?.must_equal false
    ARGV.clear.unshift ''
    @tested.sane?.must_equal false

    #pass
    ARGV.clear.unshift '1'
    @tested.sane?.must_equal true
    ARGV.clear.unshift '_'
    @tested.sane?.must_equal true
  end

  it 'stores the new app structure in the DATA object' do
    # FIXME: does not really test for the app structure
    @tested.data.must_be_instance_of String
  end

end


# "The user will provide one argument to the script, which will be available in $ARGV"
#  "accepts commandline arguments via ARGV"
describe "Generate accepts one valid argument via ARGV" do

  before do
    ARGV.clear
  end

  it 'throws error when ARGV has too FEW arguments' do
    ARGV.length.must_equal 0
    proc {Generate.new.valid_input?}.must_raise ArgumentError
  end

  it 'throws error when ARGV has too MANY arguments' do
    ARGV << :a
    ARGV << :b
    ARGV.length.must_equal 2
    proc {Generate.new.valid_input?}.must_raise ArgumentError
  end

  # workaround since MiniTest does not permit negative test for exception
  it 'passes validation when ARGV has a single string value' do
    ARGV << 'a'
    Generate.new.valid_input?.must_equal true
  end

end
