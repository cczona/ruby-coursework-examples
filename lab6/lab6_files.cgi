#!/usr/bin/env ruby

puts "Content-type: text/html\n\n"

begin

  class Lab6Files
    
    def initialize
      @content=[]
      if Lab6Files.is_production? # FIX ME: unsandbox these!
        @path=File.expand_path('/tmp/czona')
      else
        @path=File.expand_path('/tmp/lab6')
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
