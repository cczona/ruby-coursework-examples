# # #
# Example output: http://hills.ccsf.edu/~dputnam/lab5.cgi
# # #

html=<<HTML
<html>
<head>
<title>Lab5 - Carina Zona</title>
</head>
<body>

  <table>

    <thead>
      <!-- LACKS TEST: allows the user to click the column name to sort the student records -->
      <--  LACKS TEST: have a way to send a signal to the script -->
      <!-- LACKS TEST: use @fields array in lab5.cgi to generate table header th tags inside lab5_template.html.erb file -->
      <!-- LACKS TEST: use HTML links to transmit the user's choice -->
      <!-- LACKS TEST: # use the QUERY_STRING information to send information from the browser to script -->
      <!-- LACKS TEST: use humanized field names as labels  -->
      <!-- LACKS TEST: use <pre></pre> tags to display the user information -->
      <!-- LACKS TEST: field label words to uppercase per implied spec of output sample  -->
      <tr>
        <% this_course=Course.new
        this_course.students.sample.fields.each do |field| %>
        <th>
          <pre><a href="?sort_by=<%= field %>"><%= field.to_s.humanize.ucwords %></a></pre>
        </th>
        <% end %>
      </tr>
      <!-- / -->
    </thead>

    <tbody>

    <% this_course.students.each do | s |

      if s.parsed_name[1][0].downcase < "l" then
        def s.last_name
          parsed_name[1].ucwords
        end
        def s.first_name
          parsed_name[0].ucwords
        end
      else
        def s.last_name
          parsed_name[1].altcase
        end
        def s.first_name
          parsed_name[0].altcase
        end
      end

    %>

      <tr>
        <td>
          <pre><%=s.number%></pre>
        </td>
        <td>
          <pre><%=s.user_name%></pre>
        </td>
        <td>
          <pre><%=s.password%></pre>
        </td>
        <td>
          <pre><%=s.uid%></pre>
        </td>
        <td>
          <pre><%=s.gid%></pre>
        </td>
        <td>
          <pre><%=s.gcos_field%></pre>
        </td>
        <td>
          <pre><%=s.home_directory%></pre>
        </td>
        <td>
          <pre><%=s.login_shell%></pre>
        </td>
        <td>
          <pre><%=s.first_name%></pre>
        </td>
        <td>
          <pre><%=s.last_name%></pre>
        </td>
      </tr>
    <% end %>
    </tbody>

  </table>

</body>
</html>
HTML

begin
  require 'erb'
  require_relative './cgi_helper.rb'
  erb=ERB.new(html)
  puts erb.result(binding)
rescue => e
  puts e.class
  puts e.message
  puts e.backtrace.inspect
end
