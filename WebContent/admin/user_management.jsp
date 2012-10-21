

// SQL Query
// select * from users;

<table>
<tr>
	<th>Username</th>
	<th>Admin</th>
	<th>Actions</th>
</tr>
<% for ()  { %>
<tr>
	<td><%= user.username %></td>
	<td><% if (user.is_admin) { %> YES <% } else { %> NO <%} %> </td>
	<td><a href="edit_user_form.jsp?user=<%= user.username %>">Edit</a> 
		| <a href="delete_user.jsp?=<%= user.username %>">Delete</a></td>
</tr>
<% } %>
 
</table>
