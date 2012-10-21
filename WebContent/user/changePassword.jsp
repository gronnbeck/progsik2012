<%@page import="java.util.regex.Pattern"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="com.sun.org.apache.xml.internal.security.utils.Base64"%>
<%@include file="userHeader.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="refresh" content="5;url=index.jsp">
	<link rel="stylesheet" type="text/css" href="../lutstyle.css">
	<title>Password reset!</title>
</head>

<%
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");
	
	String token = request.getParameter("token");
	String sessionToken = session.getAttribute("token").toString();
	if(token == null || !token.equals(sessionToken)) {
		out.println("CSRF does not work here...");
		return;
	}
	
	String password = request.getParameter("password");
	if(password == null) {
		return;
	}
	
	MessageDigest md = MessageDigest.getInstance("SHA-256");
	md.update(password.getBytes("UTF-8"));
	byte[] digest = md.digest();
	String hashedPassword = Base64.encode(digest).toString();

	Connection connection = dataSource.getConnection();
	PreparedStatement pstatement = null;
	try {
		String queryString = "UPDATE users SET password=? WHERE username=?";
		pstatement = connection.prepareStatement(queryString);
		pstatement.setString(1, hashedPassword);
		pstatement.setString(2, session.getAttribute("username").toString());
		pstatement.executeUpdate();
	} catch (Exception ex) {
		out.println("Unable to execute update to database." + ex.getMessage());
	} finally {
		pstatement.close();
		connection.close();
	}
%>
<meta http-equiv="refresh" content="0;url=index.jsp">
</html>
