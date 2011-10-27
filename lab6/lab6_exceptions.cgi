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


