#!/usr/bin/env ruby

# filename must be lab5.cgi

# "reuse the code you wrote for Lab 4"

# BEGIN TIMING SCRIPT
t = Time.now
start = t.to_f

# when doing requires, start by looking in lab5's directory
## FIXME: need to dynamically determine the base dir for lab5
## see obj.method(:name).source_location
## lab5_dir=File.dirname(:something_tbd)
## $:.unshift(lab5_dir)

FIELDS=[ :number, :user_name, :password, :uid, :gid, :gcos_field, :home_directory, :login_shell, :first_name, :last_name]

require 'CGI'


class Course

  def initialize( args={ :course_id => 'c73157', :cgi_obj => CGI.new } )
    @course_id=args[:course_id]
    @members=nil
    @passwd=nil
    @passwd_filtered=nil
    @students=[]
    @sort_by_this=nil
    @cgi_obj=args[:cgi_obj]
    @column_selection=nil

    passwd
    passwd_lines_of_members
  end

  def is_production?
    ENV['HOME']=='/students/czona' ? @production=true : @production=false
  end

  def group
    production_path='/etc/group'
    development_path='/Users/cczona/Homework/ruby/lab5/group-sample'

    if is_production?
      f=File.readlines(production_path)
    else
      f=File.readlines(development_path)
    end

    f.select {|line| line =~ /^#{@course_id}:/}.join.to_s.chomp
  end

  def passwd
    production_path='/etc/passwd'
    development_path='/Users/cczona/Homework/ruby/lab5/passwd-sample'

    if @passwd.nil?
      if is_production?
        @passwd=File.readlines(production_path)
      else
        @passwd=File.readlines(development_path)
      end
    end
    @passwd
  end

  def members
    list=group.split(':')[-1] # discard metadata
    @members=list.split(',')
  end

  def passwd_lines_of_members
    regex=members.join('|')
    @passwd_filtered=@passwd.select do |account|
      # if this matches a member, retain
      account =~ /^(#{regex}):/
    end
  end

  def students
    if @students.size == 0
      @passwd_filtered.each do |account|
        @students.push(Student.new(account))
      end
    end
    @students
  end

  # "know which column the user has selected"
  # "use the CGI class to extract the value"
  # "use the CGI class to parse the user choice from the query"
  # "CGI object will store the key value pairs in a Hash named 'params'"
  def column_selection(cgi)
    if cgi.class == CGI && cgi.respond_to?(:params) && cgi.params.respond_to?('sort_by_this')
      # @column_selection = :home_directory #temp
      @column_selection = CGI::unescape(cgi.params[:sort_by_this].last).to_sym # user's last selection is final
    else
      @column_selection = nil
    end
  end

  # "determine the column to sort by"
  def sort_by_this
    # return @sort_by_this unless @sort_by_this.nil? # use the stored value if possible

    if FIELDS.include? @column_selection
      @sort_by_this = @column_selection
    else
      @sort_by_this = FIELDS.first
    end
  end

  # make Course
  include Enumerable

  def each(&block)
    @students.each { |student| block.call(student) }
  end

end


class Student
  def initialize(passwd_line)
    @name_parts=nil
    @@count ||= 0
    @@count+=1
    @fields = FIELDS # fields is required to be an instance variable in lab5.cgi
    @raw_data=passwd_line.sub(/^(.+?)\n/, "\\1").split(':').unshift @@count # passwd's data, plus append ran
  end

  def fields
    @fields
  end

  def raw_data
    @raw_data
  end

  def number
    @raw_data[0]
  end

  def user_name
    @raw_data[1]
  end

  def parsed_name(string=gcos_field)
    # "last_name and first_name...will be derived from the user name in the GECOS field"

    #if name has already been parsed, used stored values
    if (@name_parts.nil? == false && @name_parts.class == Array && @name_parts.size == 2) then return @name_parts end

    # "Assume for this exercise that the GECOS field contains the students name in this format: first middle last."
    # implicit from output example: discard everything after 1st comma, if any
    # implicit from output example: discard everything after 3rd word
    parts=gcos_field.split(',')[0].split(' ')[0...3]

    case

    # "If the name is blank (there are a few), set the field's value to "" (the empty string)."
    when  parts.size == 0
      @name_parts=['','']

    # "Where there is only one name, use it for the last name, and set the first name to blank. "
    when  parts.size == 1
      @name_parts=['', parts.last]

    when  parts.size == 2
      @name_parts=[parts.first, parts.last]

    # "If the user has a middle name, include it in the first_name attribute."
    when  parts.size == 3
      @name_parts=[ [parts.first, parts[1]].join(' '), parts.last]
    end

    @name_parts
  end

  def first_name
    parsed_name[0]
  end

  def last_name
    parsed_name[1]
  end

  def password
    @raw_data[2]
  end

  def uid
    @raw_data[3]
  end

  def gid
    @raw_data[4]
  end

  def gcos_field
    @raw_data[5]
  end

  def home_directory
    @raw_data[6]
  end

  def login_shell
    @raw_data[7]
  end

  def self.students
    @@count
  end

  def self.students=(i=0)
    @@count=i
  end

  def to_s
    @raw_data
  end

end


class String

  def ucwords
    # courtesy <http://www.phptoruby.com/ucwords>
    self.split(' ').select {|w| w.capitalize! || w }.join(' ');
  end

  def altcase
     # alternate upper and lower case characters per instructor-provided code
     count = 0
     out = ''
     self.scan(/./m) do |b|
       if count == 0
         out << b.upcase && count = 1
       else
         out << b.downcase && count = 0
       end
     end
    out
  end

end


# Ready to generate output
begin
  require 'erb'
  require_relative './cgi_helper.rb'
  include CGI_Helper
  puts Class.http_header
  puts Class.doctype
  puts ERB.new(File.read('./lab5_template.html.erb')).result
rescue => e
  puts e.message
  puts e.backtrace
end


# FINISH TIMING SCRIPT
finish = Time.now
print 'Elapsed time: ' + (finish.to_f - start.to_f).to_s + ' seconds'
