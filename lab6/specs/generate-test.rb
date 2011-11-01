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
    File.basename(@tested.new_app_path).must_equal @tested.app_name
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
    @tested.data.size.must_be :>, 1
    @tested.data.split("\n").size.must_be :>, 27
  end

  it 'parses the data object into a manifest of files and directories to be generated' do
    collection=@tested.parse_manifest

    collection['dir_names'].must_be_kind_of Array
    collection['dir_names'].size.must_be :==, 20

    collection['file_names'].must_be_kind_of Hash
    collection['file_names'].size.must_be :==, 4
  end

  it 'sets correct paths and permissions for new directories' do
    ARGV.unshift 'foo'
    @tested.generate_from_data
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


describe 'the generated application' do

  # require 'fileutils'

  before do
    ARGV.clear
    ARGV.unshift 'bar'
    @tested=Generate.new
    # FileUtils.rm_rf(@tested.new_app_path)
    @tested.generate_from_data
  end

  it 'has several sub-directories, some of which have files' do
    ls_before=Dir.entries(@tested.new_app_path)
    ls_after=ls_before.reject {|e| e=='..' || e=='.'}
    ls_after.size.must_equal ls_before.size - 2
    ls_after.size.must_be :>, 1

    # ls_after.each do |basename|
    #   f=File.expand_path(basename, @tested.new_app_path)
    #   begin; p perms=File.stat(basename).mode; rescue Exception => e; p basename; p f; p e.message; p e. backtrace; end
    #   if File.directory?(f)
    #     perms.must_match Generate::DIR_PERMS
    #   elsif (File.executable?(f) || File.file?(f)) && (File.extname(basename) == '.rb' || File.extname(basename) == '.cgi')
    #     perms.must_match Generate::SCRIPT_PERMS
    #   else
    #     begin
    #       perms.must_equal Generate::PLAIN_FILE_PERMS
    #     rescue Exception => e
    #       p e.message
    #       p "PERMS are for #{basename}"
    #     end
    #   end #if
    # end # each
  end # it

  it 'contains a working index.cgi ' do
    path=File.expand_path('index.cgi', @tested.new_app_path)
    File.exists?(path)
    p f=File.new(path)
    # p f.pos=0
    # # f.stat.mode_received.must_equal SCRIPT_PERMS
    # p f.gets#.must_equal "#!/usr/bin/env ruby\n" # "with a valid shebang line"
    # p f.gets#.must_equal "Content-type: text/html\n" # "valid Content-type"
    # p f.gets#.must_equal "\n"
    # p f.gets#.must_equal "require 'cgi_helper'" # "requires cgi_helper.rb"
    # puts `ruby f`
  end

  it 'has content in the README file' do
    skip
  end

end


describe 'the generated index.cgi' do

  it 'modifies the include path so application subdirectories can be required without pathname' do
    skip
  end

  it 'uses CGI_Helper methods in index.cgi' do
    skip
  end

end
