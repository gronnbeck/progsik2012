<%@page import="java.sql.*"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="com.sun.org.apache.xml.internal.security.utils.Base64"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	if(request.getMethod() != "POST") {
		%>
		<meta http-equiv="refresh" content="0;url=index.jsp">
		<%
		return;
	}

	MessageDigest md = MessageDigest.getInstance("SHA-256");
	String password = request.getParameter("password");
	String username = request.getParameter("username");
	
	md.update(password.getBytes("UTF-8"));
	byte[] digest = md.digest();
	String digestString = Base64.encode(digest).toString();

	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");

	Connection connection = dataSource.getConnection();
	PreparedStatement pstatement = null;
	ResultSet rs = null;
	String uname="", pw="", validatestring ="", email="";
	try {
		String queryString = "SELECT * FROM users WHERE username = ? AND password = ?";
		pstatement = connection.prepareStatement(queryString);
		pstatement.setString(1, username);
		pstatement.setString(2, digestString);	
		rs = pstatement.executeQuery();
		if(rs.next()) {
			boolean validated = rs.getBoolean(5);
			if(!validated) {
				%>
				<meta http-equiv="refresh" content="0;url=loginForm.jsp">
				<%
				return;
			}
			session.setAttribute("username", rs.getString(1)); 
			session.setAttribute("email", rs.getString(3));
			session.setAttribute("is_admin", new Boolean(rs.getBoolean(4)));
			session.setAttribute("token", rs.getString(6));
		} else {
			 %>
			<meta http-equiv="refresh" content="0;url=loginForm.jsp">
			<%
			return;
		}
	} catch (Exception ex) {
		out.println("Unable to execute query to database: " + ex.getMessage());
		return;
	} finally {
		pstatement.close();
		connection.close();
	}
%>
	
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    	<%@include file="header.jsp"%>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUT 2.0</title>
    </head>
    <body>
		<h1>Login succeeded</h1> 
		Welcome <%=username%>.<br> 
		You will be redirected to your home page in 5 seconds.
		<meta http-equiv="refresh" content="5;url=index.jsp">
	</body>
</html>