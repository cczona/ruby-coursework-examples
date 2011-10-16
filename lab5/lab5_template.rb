#!/usr/bin/env ruby

html=<<HTML
<html>
<head>
<title>Lab5 - Carina Zona</title>
</head>
<body>

  <table>

    <thead>
      <tr>
        <th>Rank</th>
        <th>username</th>
        <th>password</th>
        <th>uid</th>
        <th>guid</th>
        <th>GCOS field</th>
        <th>directory</th>
        <th>shell</th>
        <th>first name</th>
        <th>last name</th>
      </tr>
    </thead>

    <tbody>
    <% Course.new.students.each do | s |

      if s.parsed_name[1][0].downcase < "l"
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
        <td><%=s.number%></td>
        <td><%=s.user_name%></td>
        <td><%=s.password%></td>
        <td><%=s.uid%></td>
        <td><%=s.gid%></td>
        <td><%=s.gcos_field%></td>
        <td><%=s.home_directory%></td>
        <td><%=s.login_shell%></td>
        <td><%=s.first_name%></td>
        <td><%=s.last_name%></td>
      </tr>
    <% end %>
    </tbody>

  </table>

</body>
</html>
HTML