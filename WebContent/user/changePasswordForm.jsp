<%@include file="userHeader.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../lutstyle.css">
<title>LUT 2.0 - Reset Password</title>
</head>
<body>
	<form action="changePassword.jsp">
		New password: <input type="text" name="password"><br>
		<input type="hidden" name="token" value="<%=session.getAttribute("token")%>"/><br>
		<input type="submit" value="Change password">
	</form>
	<a href="logout.jsp">Logout</a>
</body>
</html>
