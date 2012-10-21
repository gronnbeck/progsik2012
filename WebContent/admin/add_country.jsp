<%@include file="adminHeader.jsp"%>
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
		<meta http-equiv="refresh" content="0;url=add_country_form.jsp">
	<%
		return;
	}
	
	String token = request.getParameter("token");
	String sessionToken = session.getAttribute("token").toString();
	if(token == null || !token.equals(sessionToken)) {
		out.println("CSRF does not work here...");
		return;
	}

	String short_name = request.getParameter("short_name");
	String full_name = request.getParameter("full_name");
	
	if(short_name == null || full_name == null || !isLegal(short_name) || !isLegal(full_name)) {
		%>
		<meta http-equiv="refresh" content="5;url=add_country_form.jsp">
		<%
		return;
	}
	
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");
	
	Connection connection = dataSource.getConnection();
	PreparedStatement pstatement = null;
	try {
		String queryString = "INSERT INTO country(short_name, full_name) VALUES(?, ?)";
		pstatement = connection.prepareStatement(queryString);
		pstatement.setString(1, short_name);
		pstatement.setString(2, full_name);
		pstatement.executeUpdate();
	} catch (Exception ex) {
		out.println("Unable to execute update to database");
		return;
	} finally {
		pstatement.close();
		connection.close();
	}
	%>
<meta http-equiv="refresh" content="0;url=adminIndex.jsp">