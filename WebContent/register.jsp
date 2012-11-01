<%@page import="java.util.Random"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.security.MessageDigest"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="SendMail.jsp"%>
<%!boolean isLegal(String string) {
		return string.matches("^[\\w\\s!:/,.]+$");
	}%>

<%
	if(request.getMethod() != "POST") {
	%>
		<meta http-equiv="refresh" content="0;url=registerForm.jsp">
	<%
		return;
	}

	MessageDigest md = MessageDigest.getInstance("SHA-256");
	String password = request.getParameter("password");
	String username = request.getParameter("username");
	String email = request.getParameter("email");
	if(password == null) {
		out.println("You dick! Write a password...");
		%>
		<meta http-equiv="refresh" content="0;url=registerForm.jsp">
		<%
		return;
	} else {
	md.update(password.getBytes("UTF-8"));
	byte[] digest = md.digest();
	StringBuffer sb = new StringBuffer();
	for (byte b : digest) {
		sb.append(Integer.toHexString((int) (b & 0xff)));
	}
	String digestString = sb.toString();
	
	// Generate random validatestring
	Random random = new Random(System.nanoTime());
	String validateString = "" + random.nextInt();
	
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");
	
	if (!isLegal(password) || !isLegal(username)) {
		out.println("You dick! Write a correct password...");
		%>
		<meta http-equiv="refresh" content="5;url=registerForm.jsp">
		<%
		return;
	} else {

		Connection connection = dataSource.getConnection();
		PreparedStatement pstatement = null;
		try {
			String queryString =
					"INSERT INTO users(username,password,email,is_admin,validated,validatestring) VALUES (?, ?, ?, ?, ?, ?)";
			pstatement = connection.prepareStatement(queryString);
			pstatement.setString(1, username);
			pstatement.setString(2, digestString);
			pstatement.setString(3, email);
			pstatement.setBoolean(4, false);
			pstatement.setBoolean(5, false);
			pstatement.setString(6, validateString);		
			pstatement.executeUpdate();
		} catch (Exception ex) {
			out.println("Unable to execute update to database");
			return;
		} finally {
			pstatement.close();
			connection.close();
		}
	}
	
	String message = "Congratulations on registering... Please confirm your account by clicking the following link: https://paris.idi.ntnu.no:5081/lut_2.0/confirmRegistration.jsp?username=" + username + "&validate=" + validateString;
	
	SendMail sendmail = new SendMail();
	sendmail.send(email, "Confirm registration on LUT2.0", message);
	}
	%>
    
<c:set var="userDetails" value="${users.rows[0]}"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    	<%@include file="header.jsp"%>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>Register complete!</title>
    </head>
    <body>
        A confirmation email has been sent to YOU!<br>
        When you have confirmed your email, you may login <a href="loginForm.jsp">here</a>.
    </body>
</html>
