# # # lab6_exceptions.cgi # # #
#!/usr/bin/env ruby

# Use Exceptions to handle errors in a script named lab6_exceptions.cgi
# Write a CGI script that creates and catches the following exceptions, printing the exceptions messages contained in the exception:
  # ArgumentError
  # IndexError
  # NameError
  # NoMethodError
  # ZeroDivisionError

puts "Content-type: text/html"
puts

@exceptions=[]

def attempt(&block)
  begin
    block.call
  rescue Exception => e
    @exceptions<<e
  end
end

begin # re-ordered to match that of output sample
  attempt {Foo}              # NameError
  attempt {[].shift 1, 2}    # ArgumentError
  attempt {"Foo".carina}     # NoMethodError
  attempt {[].fetch 42}      # IndexError
  attempt {4/0}              # ZeroDivisionError
rescue Exception => e
  puts "Unable to attempt all operations!"
  puts (e.class.to_s + ': ' + e.message)
  puts e.backtrace
  exit
end


begin
  require 'erb'
  html=%Q{
    <html>
    <!-- Example output: http://hills.ccsf.edu/~dputnam/lab6_exceptions.cgi-->
      <head>
        <title>Lab6 - Carina Zona</title>
        <style>
          /* adapted from sample */
        body
        {
          margin: 1em auto;
          padding: 2em;
          font-size: 1em;
        }

        .caught
        {
          background-color: #cef;
          padding: 1em;
          border:solid 1px #ddd;
          padding: 2em 1em 1em 1em;
          margin-top: 2em;
          border-top; gray;
        }

        .backtrace
        {
          background-color: khaki;
          padding: 2em;
          font-family:monospace;
        }
        </style>

      </head>

      <body>

        <h1>Lab6 - Exceptions - Carina Zona</h1>

        <% @exceptions.each do |e| %>

        <div class="caught">
          <h2><%= e.class%></h2>
          <p><%= e.message%></p>
          <div class="backtrace">
            <p>Stacktrace:</p>
            <% e.backtrace.each do |line| %>
            <p><%= line %></p>
            <% end %>
          </div>
        </div>

        <% end %>

      </body>
    </html>
  }

  puts ERB.new(html).result
rescue Exception => e
  p "Unable to produce output"
  p e.message
  p e.backtrace
end


# # # lab6_files.cgi # # #
#!/usr/bin/env ruby

puts "Content-type: text/html\n\n"

begin

  class Lab6Files

    def initialize
      @content=[]
      if Lab6Files.is_production? # FIX ME: unsandbox these!
        # @path=File.expand_path('/tmp/czona')
        @path= File.expand_path('/students/czona/public_html/cgi-bin/')
      else
        # @path=File.expand_path('/tmp/lab6')
        @path= File.expand_path(File.dirname(__FILE__))
      end
    end

    def self.is_production?
      #  another candidate: ENV['SERVER_SIGNATURE'].match(%r{hills.ccsf.cc.ca.us})
      ( ENV["HTTP_HOST"]=="hills.ccsf.edu" || ENV["SERVER_ADDR"]=='147.144.1.2' || ENV['USER'] == 'czona' )
    end

    def path
      @path
    end

    def content
      Dir.glob('./**/**')
    end

    def output
      markup = <<-OUT
        <html>
        <head>
        <link rel="stylesheet" type="text/css" href="/~dputnam/stylesheets/132a.css" />
        <link rel="stylesheet" type="text/css" href="http://douglasputnam.com/css/html5.css" />
        <style type="text/css">
        .content {
          width: 800px;
          margin: 0 auto;
          font-family:Arial,Helvetica,monospace;
        }
        hr { margin-top: 2em;border-top; gray;height: 1px;}
        .backtrace {
          background-color: khaki;
          padding: 2em;
          font-family:monospace;
        }
        body,p {
          font-family: Lucida Grande, Arial, Verdana, sans-serif;
        }
        </style>
        </head>
        <body>
        <div id="banner">
        Carina Zona -- CS 132A -- Lab 6</div>
        <div class="content">
        <h1><code>lab6_files.cgi</code> Example</h1>
        <pre>
        <h3>Contents of <code>#{File.basename(@path)}</code></h3>
        OUT

        content.each do |line|
          markup << ('        ')
          markup << line + "\n"
        end

        markup << <<-HTML
        </pre>
        </div>
      </body>
      </html>
    HTML
  end
end

  puts Lab6Files.new.output

rescue => e
  puts e.message
  puts e.backtrace
end


# # # generate.rb # # #
#!/usr/bin/env ruby

require 'fileutils'

if Module.const_defined?(:DATA) # external tests can't see this
  SOURCE=DATA
  POSITION=SOURCE.pos
else
  SOURCE=File.new(__FILE__)
  POSITION=File.read(SOURCE).match(/^__END__.*$/).offset(0)[1]+1
end

class Fixnum
  def mode_received
    self.mode.to_s.to_i(10).to_s(8).to_i.to_a[-4,-1].join
  end
end

class Generate
  ALLOWED_CHARACTERS=('a'..'z').to_a + ('A'..'Z').to_a  + ('0'..'9').to_a  << '-' << '_'
  FILE_DATA_SEPARATOR="\n\n## FILE: "

  DIR_PERMS=0711
  SCRIPT_PERMS=0700
  PLAIN_FILE_PERMS=0644

  MESSAGE=msg='Generate#valid_input? says: '

  def initialize
    $:.unshift script_directory # add app base directory to load path
  end

  def data
    SOURCE.pos=POSITION
    SOURCE.read
  end

  def is_production?
    #  another candidate: ENV['SERVER_SIGNATURE'].match(%r{hills.ccsf.cc.ca.us})
    ( ENV["HTTP_HOST"]=="hills.ccsf.edu" || ENV["SERVER_ADDR"]=='147.144.1.2' || ENV['USER'] == 'czona' )
  end

  def group
    if is_production?
      584 # 'b20117'
    else
      20  #'staff'
    end
  end

  def script_directory
    if is_production? #FIXME: unsandbox these!
      # File.expand_path('/tmp/czona/')
      File.expand_path('~/public_html/cgi-bin/')
    else
      # File.expand_path('/tmp/lab6/')
      File.expand_path(File.dirname(__FILE__))
    end
  end

  def valid_input?
    unless ARGV.class == Array        ; raise Exception, MESSAGE + "That's weird.  ARGV isn't an array for some reason.";end
    if (ARGV.length < 1)              ; raise ArgumentError, MESSAGE + "Must provide one argument. #{ARGV} is too short";end
    if (ARGV.length > 1)              ; raise ArgumentError, MESSAGE + "Just one argument, please.  #{ARGV} is too long";end
    unless (ARGV[0].class == String)  ; raise ArgumentError, MESSAGE + "Sorry, the argument must be a string";end
    unless (sane?)                    ; raise ArgumentError, MESSAGE + "Sorry, the name '#{ARGV[0]}' is not allowed. Stick to strings consisting of ASCII letters, numbers, underscores, and hyphens.";end
    return true
  end

  def sane?
    letters=ARGV[0].split('').uniq # beware: uniq! returns nil when no changes are made
    return false if letters.size == 0
    passable=ALLOWED_CHARACTERS
    letters.each { |ltr| return false unless passable.include? ltr }
    return true
  end

  def app_name
    if valid_input?
      ARGV[0].to_s
    else
      raise RuntimeError "Invalid input somehow was introduced"
    end
  end

  def new_app_path
    File.expand_path('./' + app_name , script_directory)
  end

  def parse_manifest
    parsed=data.split(FILE_DATA_SEPARATOR)
    collection={}
    collection['dir_names']=parsed.shift.split("\n").sort.uniq
    collection['file_names']={}
    parsed.each do |f|
      f=f.split("\n", 2)
      collection['file_names'][f[0]]=f[1]
    end
    collection
  end

  def generate_from_data
    unless FileUtils.rm_rf(new_app_path) then raise RuntimeException, MESSAGE + "generate_from_data unable to remove #{new_app_path}" end
    create_directory new_app_path # basepath
    parse_manifest['dir_names'].each { |d| create_directory File.expand_path(d, new_app_path) }
    parse_manifest['file_names'].each  { |f, content| create_file(File.expand_path(f, new_app_path), content)}
    true
  end


  # # # PRIVATE # # #
  # private
  def create_directory(path)
    # FileUtils.rm_rf path
    Dir.mkdir(path, DIR_PERMS) #unless File.exist? path
    File.chown(nil, group, new_app_path)
    File.chmod(DIR_PERMS, new_app_path)
  end

  def create_file(path, content)
    File.new(path, 'w')<<content
    File.chown(nil, group, path)
    if %w{.rb .cgi}.include? File.extname(path)
      File.chmod(SCRIPT_PERMS, path)
    else
      File.chmod(PLAIN_FILE_PERMS, path)
    end
  end

end

# p Generate.new.script_directory
Generate.new.generate_from_data

__END__
app/
app/controllers/
app/models/
app/views/
app/views/layouts/
config/
db/
doc/
lib/
lib/tasks/
log/
public/
public/images/
public/javascripts/
public/stylesheets/
script/
script/performance/
script/process/
tmp/
tmp/sessions/


## FILE: doc/README
Welcome to your new application!  The key files have been auto-generated for you.  See the full documentation in ./doc for detailed instructions on getting it up and running


## FILE: lib/cgi_helper.rb
module CGI_Helper
  def http_header
    "Content-type: text/html\n\n"
  end

  def html_starter
    return <<-HTML
    <!DOCTYPE html>
    <html>
    <head>
      <meta http-equiv=Content-type content="text/html; charset=utf-8">
      <title>Success!</title>
    </head>
    <body>
    <p>Congratulations.  Your application has been generated successfully.</p>
    </body>
    </html>
    HTML
  end
end


## FILE: index.cgi
#!/usr/bin/env ruby
$:.unshift('.')
require_relative './lib/cgi_helper'
include CGI_Helper
puts http_header
#### BEGIN EDITING BELOW HERE ####
puts html_starter


## FILE: script/generate.rb
