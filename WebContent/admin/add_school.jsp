<%@include file="adminHeader.jsp"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%!boolean isLegal(String string) {
		return string.matches("^[\\w\\s!:/,.[0-9]]+$");
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

	String fullname = request.getParameter("fullname");
	String shortname = request.getParameter("shortname");
	String place = request.getParameter("place");
	String zip = request.getParameter("zip");
	String country = request.getParameter("country");
	
	if(fullname == null || shortname == null || place == null || zip == null || country == null ||
			!isLegal(fullname) || !isLegal(shortname) || !isLegal(place) || !isLegal(country) || !isLegal(zip)) {
		%>
		<meta http-equiv="refresh" content="0;url=add_school_form.jsp">
		<%
		return;
	}
	
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");
	
	Connection connection = dataSource.getConnection();
	PreparedStatement pstatement = null;
	try {
		String queryString = "INSERT INTO school(full_name, short_name, place, zip, country) VALUES(?, ?, ?, ?, ?)";
		pstatement = connection.prepareStatement(queryString);
		pstatement.setString(1, fullname);
		pstatement.setString(2, shortname);
		pstatement.setString(3, place);
		pstatement.setString(4, zip);
		pstatement.setString(5, country);
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