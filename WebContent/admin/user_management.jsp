<%@page import="java.sql.*"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@include file="../adminHeader.jsp"%>
<%
Context initCtx = new InitialContext();
Context envCtx = (Context) initCtx.lookup("java:comp/env");
DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");

Connection connection = dataSource.getConnection();
PreparedStatement pstatement = null;
ResultSet rs = null;
%>
<html>
<table>
<tr>
	<th>Username</th>
	<th>Email</th>
	<th>Admin</th>
	<th>Validated</th>
	<th>Actions</th>
</tr>
<%
try {
	String queryString = "SELECT * FROM users";
	pstatement = connection.prepareStatement(queryString);
	rs = pstatement.executeQuery();
	while(rs.next()) {
		out.println("<tr>");
		out.println("<td>" + rs.getString(1) + "</td>");
		out.println("<td>" + rs.getString(3) + "</td>");
		out.println("<td>" + rs.getBoolean(4) + "</td>");
		out.println("<td>" + rs.getBoolean(5) + "</td>");
		%>
		<td><a href="edit_user_form.jsp?user=<%= rs.getString(1) %>">Edit</a> 
		| <a href="delete_user.jsp?user=<%= rs.getString(1) %>">Delete</a></td>
		<%
		out.println("</tr>");
	}
} catch (Exception ex) {
	out.println("Unable to execute query to database: " + ex.getMessage());
	return;
} finally {
	pstatement.close();
	connection.close();
}
%>
<table>
<hr>
<a href="adminIndex.jsp">Admin</a>
</html>