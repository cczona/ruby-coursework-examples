#!/usr/bin/env ruby

module CGI_Helper
  def humanize
    self.gsub(/_/, ' ')
  end
end

## instructor-provided example from ERB reading
# render_erb creates an ERB object using a string
# render_file_as_erb opens a file and render it as ERB, using render_erb

module CgiHelper

 def render_file_with_erb(file)
   rhtml = File.read file
     render_erb(rhtml)
  end

 def render_erb(rhtml)
   require 'erb'
   erb = ERB.new(rhtml)
   erb.result(binding)
 end

end

## Assuming we have a file named index.html, we can render it as HTML using ERB.
#
# <!-- index.html --> <%= @name %>
# We can use this module like this:
#
# #!/usr/local/bin/ruby
# require 'cgi_helper'
# include CgiHelper
# http_header
# @name = 'Yosemite Sam'
# puts render_file_with_erb('index.rhtml')
# And the output will be:
#
# <!-- index.html -->
# Yosemite Sam
##


class String
  include CGI_Helper
end