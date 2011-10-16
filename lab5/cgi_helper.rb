module CGI_Helper

  def humanize
    self.gsub(/_/, ' ')
  end

end


class String

  include CGI_Helper

end

## Assuming we have a file named index.html, we can render it as HTML using ERB.
#
# <!-- index.html --> <%= @name %>
# We can use this module like this:
#
# #!/usr/local/bin/ruby
# require 'cgi_helper'
# include CgiHelper
# @name = 'Yosemite Sam'
# puts render_erb('index.rhtml')
# And the output will be:
#
# <!-- index.html -->
# Yosemite Sam
##
