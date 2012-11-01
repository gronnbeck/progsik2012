<%@page import="java.util.regex.Pattern"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.security.MessageDigest"%>
<%@include file="SendMail.jsp"%>
<%
	String username = request.getParameter("username");
	String email = request.getParameter("email");
	
	if(username == null || email == null) {
		%>
		<meta http-equiv="refresh" content="0;url=index.jsp">
		<%
		return;
	}
	
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");
	
	Connection connection = dataSource.getConnection();
	PreparedStatement pstatement = null, statement = null;
	ResultSet rs = null;
	String password = "";
	try {
		String queryString = "SELECT * FROM users WHERE username=? AND email=?";
		pstatement = connection.prepareStatement(queryString);
		pstatement.setString(1, username);
		pstatement.setString(2, email);
		rs = pstatement.executeQuery();
		if(rs.next()) {
			String updateString = "UPDATE users SET password=? WHERE username=?";
			statement = connection.prepareStatement(updateString);
			
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			password = rs.getString(6);
			
			md.update(password.getBytes("UTF-8"));
			byte[] digest = md.digest();
			StringBuffer sb = new StringBuffer();
			for (byte b : digest) {
				sb.append(Integer.toHexString((int) (b & 0xff)));
			}
			String newPassword = sb.toString();
			
			statement.setString(1, newPassword);
			statement.setString(2, username);
			statement.executeUpdate();
			
			String message = "Your new password is " + password + ". We recommend that you change it on first login!";
			
			SendMail sendmail = new SendMail();
			sendmail.send(email, "LUT2.0: Password reset", message);
		} else {
			return;
		}
		
	} catch (Exception ex) {
		out.println("Unable to execute update to database");
		return;
	} finally {
		statement.close();
		pstatement.close();
		connection.close();
	}
	%>
<meta http-equiv="refresh" content="0;url=user/index.jsp">