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
  # Dir lib is fine per http://insight.ccsf.edu/mod/forum/discuss.php?d=239627
  it 'uses the File or Dir module of ruby standard library' do
    skip
    # FIX: brittle; File may have been included by something else, or the lab may have included it w/o using
    Module.constants.must_include(:File) || Module.constants.must_include(:Dir)
    # File.ancestors.must_include Lab6Files || Dir.ancestors.must_include Lab6Files # no good: File & Dir are core, not requires
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
    path=File.expand_path('../../examples/lab6_files.html',__FILE__)
    example=File.readlines(path)
    proc {puts Lab6Files.new.output}.must_output example
  end

end