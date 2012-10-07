<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String schoolId = request.getParameter("school_id");
	String school_fullname = null;
	String school_shortname = null;

	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");

	Connection connection = dataSource.getConnection();
	PreparedStatement pstatement = null;
	ResultSet reviews = null;
	try {
		String queryString = "SELECT * FROM user_reviews, school WHERE user_reviews.school_id = school.school_id AND school.school_id = ?";
		pstatement = connection.prepareStatement(queryString);
		pstatement.setInt(1, Integer.parseInt(schoolId));
		reviews = pstatement.executeQuery();
	
		if (reviews.next()) {
			school_fullname = reviews.getString(2);
			school_shortname = reviews.getString(3);
		}
	} catch (Exception ex) {
		out.println("Unable to execute query to database."
				+ ex.getMessage());
	} finally {
		pstatement.close();
		connection.close();
	}
%>

<sql:query var="reviews" dataSource="jdbc/lut2">
    SELECT * FROM user_reviews, school
    WHERE user_reviews.school_id = school.school_id
    AND school.school_id = ? <sql:param value="<%=Integer.parseInt(schoolId)%>" />
</sql:query>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="lutstyle.css">
<title>Reviews for <%=school_fullname%></title>
</head>
<body>
	<h1> Reviews for <%=school_shortname%></h1>

	<!-- looping through all available reviews - if there are any -->
	<c:set var="review" value="${reviews.rows[0]}" />
	<c:choose>
		<c:when test="${ empty review }">
                No reviews for <%=school_fullname%> yet. Help us out by adding one! 
                <br>
			<br>
		</c:when>
		<c:otherwise>
			<c:forEach var="review" items="${reviews.rowsByIndex}">
				<c:out value="${review[2]}" />
				<br>
				<i>${review[1]}</i>
				<br>
				<br>
			</c:forEach>
		</c:otherwise>
	</c:choose>

	<table border="0">
		<thead>
			<tr>
				<th colspan="2">Help improving LUT2.0 by adding a review of <%=school_shortname%></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>
					<form action="add_review.jsp" method="post">
						<input type="hidden" name="school_id" value="${param.school_id}" />
						<textarea name="review" rows=10 cols=60 wrap="physical" autofocus="on"></textarea>
						<br> <br> Your name: <input type="text" name="name" />
						<br> <br> <input type="submit" value="Add review" />
				</td>
			</tr>
		</tbody>
	</table>

</body>
</html>
