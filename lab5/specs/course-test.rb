require_relative './test-prelude'

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
