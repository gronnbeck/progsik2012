<%@page import="java.util.regex.Pattern"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@include file="userHeader.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="refresh" content="5;url=index.jsp">
	<link rel="stylesheet" type="text/css" href="../lutstyle.css">
	<title>Review added!</title>
</head>

<%
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!boolean isLegal(String string) {
		return string.matches("^[\\w\\s!:/,.]+$");
	}%>
<%
	String token = request.getParameter("token");
	String sessionToken = session.getAttribute("token").toString();
	if(token == null || !token.equals(sessionToken)) {
		out.println("CSRF does not work here...");
		return;
	}
	String schooldId = request.getParameter("school_id");
	String name = request.getParameter("name");
	String review = request.getParameter("review");

	if (!isLegal(review) || !isLegal(schooldId) || !isLegal(review)) {
	%>
	<body>
		<h1>Thanks dick!</h1>
		Unfortunately, you tried to screw us, and we can't accept that!.
		<br> You will be redirected to the LUT2.0 main page in a few seconds.
	</body>
	<%
		return;
	} else {

		Connection connection = dataSource.getConnection();
		PreparedStatement pstatement = null;
		try {
			String queryString = "INSERT INTO user_reviews(school_id,user_id,review) VALUES (?, ?, ?)";
			pstatement = connection.prepareStatement(queryString);
			pstatement.setInt(1, Integer.parseInt(schooldId));
			pstatement.setString(2, name);
			pstatement.setString(3, review);
			pstatement.executeUpdate();
		} catch (Exception ex) {
			out.println("Unable to execute update to database");
		} finally {
			pstatement.close();
			connection.close();
		}
	%>
	<body>
		<h1>Thanks <%=name%>!</h1>
		Your contribution is appreciated.
		<br> You will be redirected to the LUT2.0 main page in a few seconds.
		</tr>
	</body>
	<%
	}
%>


</html>
