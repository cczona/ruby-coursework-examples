#!/usr/bin/env ruby

# BEGIN TIMING SCRIPT
t = Time.now
start = t.to_f

puts "Content-Type: text-html"
print "\r\n\r\n"

require_relative 'cgi_helper'

require "erb" # after CGI headers

class Course

  def initialize(course_id='c73157')
    @course_id=course_id
    @members=nil
    @passwd=nil
    @passwd_filtered=nil
    @students=[]

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

end

class Student
  def initialize(passwd_line)
    @name_parts=nil
    @@count ||= 0
    @@count+=1
    @raw_data=passwd_line.sub(/^(.+?)\n/, "\\1").split(':').unshift @@count # passwd's data, plus append ran
  end

  def raw_data
    @raw_data
  end

  def rank
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

  def guid
    @raw_data[4]
  end

  def gcos_field
    @raw_data[5]
  end

  def directory
    @raw_data[6]
  end

  def shell
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


## TODO: output lab5_template.html.erb
#require_relative '../lab5_template'
#puts ERB.new(html).result


# FINISH TIMING SCRIPT
finish = Time.now 
print 'Elapsed time: ' + (finish.to_f - start.to_f).to_s + ' seconds'
