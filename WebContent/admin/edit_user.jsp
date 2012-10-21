<%@include file="../adminHeader.jsp"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
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
	String username = request.getParameter("username");
	String email = request.getParameter("email");
	String is_admin = request.getParameter("is_admin");
	boolean isThisGuySupposedToBeAdmin = false;
	if(is_admin.equals("yes")) {
		isThisGuySupposedToBeAdmin = true;
	}
	
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");
	
	Connection connection = dataSource.getConnection();
	PreparedStatement pstatement = null;
	try {
		String queryString =
				"UPDATE users set email=?, is_admin=? WHERE username=?";
		pstatement = connection.prepareStatement(queryString);
		pstatement.setString(1, email);
		pstatement.setBoolean(2, isThisGuySupposedToBeAdmin);
		pstatement.setString(3, username);		
		pstatement.executeUpdate();
	} catch (Exception ex) {
		out.println("Unable to execute update to database: " + ex.getMessage());
		return;
	} finally {
		pstatement.close();
		connection.close();
	}
	%>
	<meta http-equiv="refresh" content="0;url=user_management.jsp">