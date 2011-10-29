require_relative 'helper.rb'
# load, because 1.9.1's require/require_relative balk when there's a file extension they're not expecting
load(File.dirname(Dir.pwd) + '/lab6_files.cgi')

describe "Lab6_files" do

  it 'should test in dev environment' do
    Lab6Files.is_production?.must_equal false
  end

  it 'must be in lab6_files.cgi' do
    skip
    # look for the file in the list of libraries imported using Kernel#load ($:)  or Kernel#require ($")
    ($:|$").sort.each do |loaded|
      p loaded
      if loaded.match /\/lab6_files\.cgi/
        puts
        puts "****SUCCESS!****"
        puts
        return true
      end
    end
    # $:.must_include /lab6_files\.cgi$/
  end

  # Using the file module in the Ruby Standard Library
  it 'uses the File module of ruby standard library' do
    skip
    # FIX: brittle; File may have been included by something else, or the lab may have included it w/o using
    # Module.constants.must_include :File
    File.ancestors.must_include Lab6Files
  end

  it 'generates a web page' do
    skip
  end

  # displays the names of the directories and files inside of your cgi-bin directory
  it 'the web page displays the names of the directories and files inside your cgi-bin directory' do

  end

  it 'display directories and files under LAB6_EXAMPLE' do
    skip
  end

  it 'is consistent with the instructor Lab6_files sample' do
    skip
  end

end