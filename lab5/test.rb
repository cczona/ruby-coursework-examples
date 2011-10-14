### USAGE: $ ruby thisfile
### Optional: MiniTest options can be passed in as arguments to filename, e.g. $ ruby thisfile -- -v
### To see all MiniTest options, use $ ruby -r minitest/autorun -e '' -- --help


# make require_relative work the same in ruby 1.8, 1.9.1, 1.9.2
# (courtesy <http://stackoverflow.com/questions/4333286/ruby-require-vs-require-relative-best-practice-to-workaround-running-in-both-r>)
# unless Kernel.respond_to?(:require_relative)
#   module Kernel
#     def require_relative(path)
#       require File.join(File.dirname(caller[0]), path.to_str)
#     end
#   end
# end

require_relative "lab4"

begin; require 'minitest/spec'; rescue LoadError => e ;puts e; end
begin; require 'minitest/autorun'; rescue LoadError => e ;puts e; end
begin; require 'redgreen'; rescue LoadError => e ;puts e; end # must require redgreen AFTER purdytest

# # # # Isolating gems that have a 'gem minitest' dependency because of a bug:
# # test for must_include fail under Ruby 1.9.1 when gem minitest is not present (i.e. CCSF Hills),
# # but the same tests pass when gem minitest > 1.4.2 is present.
# # Instead use 'obj.include?(something).must_equal true', which is passes under both conditions
# begin; require 'purdytest'; rescue LoadError => e ;puts e; end
# begin: require 'colorific'; rescue LoadError => e; puts e;  end
# begin
#   require 'minitest/reporters'
#     MiniTest::Unit.runner = MiniTest::SuiteRunner.new
#   if ENV['TM_PID']
#     MiniTest::Unit.runner.reporters << MiniTest::Reporters::RubyMateReporter.new # sans ANSI color codes
#   else
#     MiniTest::Unit.runner.reporters << MiniTest::Reporters::ProgressReporter.new
#     # MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new # => Turn-like
#   end
# rescue LoadError => e
#   puts e
# end
# # # # Isolating turn for gem minitest issue and also because of second issue:
# # see <https://github.com/TwP/turn/issues/58>
# begin
#   gem 'minitest'
#   require 'turn'
# rescue LoadError => e
#   puts e
# end # OPTIONAL: if "gem ansi" is available, will also colorize
# # # #


describe Object do

  it "should execute tests using ruby 1.9.1" do
    RUBY_VERSION.must_equal '1.9.1'
  end

  it 'should execute tests using Bundler environment and gems' do
    # i.e. executed as $ bundle exec ruby test.rb --verbose
    Module.constants.include?(:Bundler).must_equal true
    ENV.keys.include?('BUNDLE_BIN_PATH').must_equal true
    ENV.keys.include?('BUNDLE_GEMFILE').must_equal true
    ENV.keys.include?('RUBYOPT').must_equal true
    ENV[:RUBYOPT].must_match(/bundler/)
  end

end

describe Course do
  
  before do
    @this_course=Course.new
  end

  it 'should register that this is not running in the production environment' do
    @this_course.is_production?.must_equal false
  end
  
  
  ############ /etc/group stuff ############
  it 'should have a getter for group' do
    @this_course.must_respond_to :group
  end
  
  it 'should pull data from /etc/group' do
    @this_course.group.must_be_kind_of String
  end

  it 'should have a members method which returns an array' do
    @this_course.must_respond_to :members
    @this_course.members.must_be_kind_of Array
  end

  it 'should identify 32 members belonging to group c73157' do
    @this_course.members.size.must_equal 32
  end
  
  it 'should find that one of the group members is czona' do
    @this_course.members.wont_be_empty
    @this_course.members.include?('czona').must_equal true
  end
  
  
  ############ /etc/passwd stuff ############
  it 'should have a getter for passwd' do
    @this_course.must_respond_to :passwd
  end

  it 'should pull data from /etc/passwd' do
    @this_course.passwd.must_be_kind_of Array
    @this_course.passwd.size.wont_equal 0
    # FIXME: would be good to add sanity check to confirm the data looks like it came from the right place
    # FIXME: this is a brittle test; coupling to an implementation (Array) instead of a value
  end

  it 'should always be using CCSF passwd data regardless of where tested' do
    @this_course.passwd.join.match(/^dputnam:/).must_be_kind_of MatchData
  end

  it 'should find approximately 9710 total passwd accounts' do
    @this_course.passwd.size.must_be_close_to 9710, 500
  end

  it 'should locate (user) accounts corresponding to the 32 members of course (group) c73157' do
    # FIXME: I feel like this either needs to: be 2 separate tests, or testing here that the found sets also join the way the desc claims they do
    @this_course.members.size.must_equal 32
    @this_course.passwd_lines_of_members.size.must_equal 32
  end
    
  it 'should instantiate 32 Student objects' do
    @this_course.students.size.must_equal 32
  end
    
end



describe Student do

  before do
    @this_course=Course.new()
    @this_student=@this_course.students.sample
  end

  it "should be a class" do
    Student.class.must_be_kind_of Class
  end

  #FIXME: should probably test for some minimal number of initialization arguments, such as an uid
  it 'should be able to instantiate Student based on a passwd line' do
    @this_student.must_be_kind_of Student
    @this_student.raw_data.must_be_kind_of Array
    @this_student.raw_data.size.must_equal 8
  end

  ## FIXME: CCSF size == 4
  it 'should store parsed raw data about the student' do
    @this_student.raw_data.must_be_kind_of Array
    @this_student.raw_data.size.must_equal 8
  end

  it 'should have a rank for the student' do
    @this_student.must_respond_to :rank
    @this_student.rank.must_be_kind_of Fixnum
  end

  it 'should have a user_name for the student' do
    @this_student.must_respond_to :user_name
    @this_student.user_name.must_be_kind_of String
  end

  it 'should have a first_name for the student' do
    @this_student.must_respond_to :first_name
    @this_student.first_name.must_be_kind_of String
  end

  it 'should have a last_name for the student' do
    @this_student.must_respond_to :last_name
    @this_student.last_name.must_be_kind_of String
  end

  it 'should format NAME FOR THE STUDENT AS SPECCED' do
    skip
  end

  it 'should have a password for the student' do
    @this_student.must_respond_to :password
    @this_student.password.must_be_kind_of String
  end

  it 'should have a uid for the student' do
    @this_student.must_respond_to :uid
    @this_student.uid.must_be_kind_of String
  end

  it 'should have a guid for the student' do
    @this_student.must_respond_to :guid
    @this_student.guid.must_be_kind_of String
  end

  it 'should have a gcos_field for the student' do
    @this_student.must_respond_to :gcos_field
    @this_student.gcos_field.must_be_kind_of String
  end

  it 'should have a directory for the student' do
    @this_student.must_respond_to :directory
    @this_student.directory.must_be_kind_of String
  end

  it 'should have a shell for the student' do
    @this_student.must_respond_to :shell
    @this_student.shell.must_be_kind_of String
  end

  it 'should increment the class variable count for each instantiated student' do
    Student.students=0
    Student.students.must_equal 0
    this_many=0;
    this_many=rand(10) until this_many > 2
    (1..this_many).each do | i |
      Student.new(@this_course.passwd_lines_of_members.sample)
      Student.students.must_equal i
    end
    Student.students.must_equal this_many # total accumulation
  end

  it 'should be able to format as: capitalize first and last name using String#ucwords' do
    @this_student.first_name.must_respond_to :ucwords
    @this_student.last_name.must_respond_to :ucwords
  end

  it 'should actually format name with String#ucwords' do
    skip
  end

end
