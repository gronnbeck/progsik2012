<%@include file="adminHeader.jsp"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%
String token = request.getParameter("token");
String sessionToken = session.getAttribute("token").toString();
if(token == null || !token.equals(sessionToken)) {
	out.println("CSRF does not work here...");
	return;
}

String username = request.getParameter("user");

Context initCtx = new InitialContext();
Context envCtx = (Context) initCtx.lookup("java:comp/env");
DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");

Connection connection = dataSource.getConnection();
PreparedStatement pstatement = null;
try {
	String queryString = "DELETE FROM users where username=?";
	pstatement = connection.prepareStatement(queryString);
	pstatement.setString(1, username);
	pstatement.executeUpdate();
} catch (Exception ex) {
	out.println("Unable to execute update to database");
	return;
} finally {
	pstatement.close();
	connection.close();
}
%>
<meta http-equiv="refresh" content="0;url=user_management.jsp">