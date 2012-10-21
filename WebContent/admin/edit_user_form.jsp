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
<%
String username = "", email = "";
boolean isThisGuyAdmin = false;
try {
	String queryString = "SELECT * FROM users where username = ?";
	pstatement = connection.prepareStatement(queryString);
	pstatement.setString(1, request.getParameter("user"));
	rs = pstatement.executeQuery();
	while(rs.next()) {
		out.println("<tr>");
		username = rs.getString(1);
		email = rs.getString(3);
		isThisGuyAdmin = rs.getBoolean(4);
	}
} catch (Exception ex) {
	out.println("Unable to execute query to database: " + ex.getMessage());
	return;
} finally {
	pstatement.close();
	connection.close();
}
%>

<form action="edit_user.jsp" method="post">
	<h1><%= username %></h1>
	<div>
	Email <input type="text" size="30" name="email" value="<%=email%>"><br>
	</div>
	<input type="hidden" value="<%=username%>" name="username">
	<div>
	Admin:
	<select name="is_admin">
		<option <%if(isThisGuyAdmin)out.print("SELECTED");%> value="yes">Yes</option>
		<option <%if(!isThisGuyAdmin)out.print("SELECTED");%> value="no">No</option>
	</select>
	</div>
	<input type="submit" value="Oppdater">
</form>

<hr>
<a href="adminIndex.jsp">Admin</a>
</html>

