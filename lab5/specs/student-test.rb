require_relative './test-prelude'

describe Student do

  before do
    @this_course=Course.new()
    @this_student=@this_course.students.sample
  end

  it 'is a class' do
    Student.class.must_be_kind_of Class
  end

  it 'has an instance variable called fields which references constant FIELDS' do
    @this_student.instance_variables.must_include :@fields
    Module.constants.must_include :FIELDS

    @this_student.instance_variable_get(:@fields).must_equal FIELDS
    @this_student.instance_variable_get(:@fields).must_be_same_as FIELDS
  end

  it 'defined the fields variable in lab5.cgi' do
    skip
  end

  it 'fields is an array of the 10 specified symbols' do
    @this_student.fields.must_be_kind_of Array
    @this_student.fields.must_equal [:number, :user_name, :password, :uid, :gid, :gcos_field,:home_directory, :login_shell, :first_name,:last_name]
    @this_student.fields.each { |field| field.must_be_kind_of Symbol }
  end

  it 'has a getter instance method corresponding to each of the fields' do
    @this_student.fields.each { |field_name| @this_student.must_respond_to field_name }
  end

  #FIXME: should probably test for some minimal number of initialization arguments, such as an uid
  it 'should be able to instantiate Student based on a passwd line' do
    @this_student.must_be_kind_of Student
  end

  it 'should store parsed raw data about the student' do
    @this_student.raw_data.must_be_kind_of Array
    @this_student.raw_data.size.must_equal 8
  end

  it 'should have a ranking number for the student' do
    @this_student.must_respond_to :number
    @this_student.number.must_be_kind_of Fixnum
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

  it 'should format NAME FOR THE STUDENT AS SPECCED in Lab4' do
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

  it 'should have a gid for the student' do
    @this_student.must_respond_to :gid
    @this_student.gid.must_be_kind_of String
  end

  it 'should have a gcos_field for the student' do
    @this_student.must_respond_to :gcos_field
    @this_student.gcos_field.must_be_kind_of String
  end

  it 'should have a home directory for the student' do
    @this_student.must_respond_to :home_directory
    @this_student.home_directory.must_be_kind_of String
  end

  it 'should have a login shell for the student' do
    @this_student.must_respond_to :login_shell
    @this_student.login_shell.must_be_kind_of String
  end

  it 'should increment the class variable count for each instantiated student' do
    Student.students=0
    Student.students.must_equal 0
    this_many=0;
    this_many=rand(5) until this_many > 2
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
