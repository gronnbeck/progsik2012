<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Register here</title>
</head>
<body>

<form name="registerForm" action="register.jsp" method="POST">
	<table>
	<tr><td>UserName</td><td><input type="text" name="username"></td></tr>
	<tr><td>Email</td><td><input type="text" name="email"></td></tr>
	<tr><td>Password</td><td><input type="password" name="password"></td></tr>
	<tr><td>Name</td><td><input type="text" name="name"></td></tr>
	<tr><td><input type="submit" value="Complete"></td></tr>
	</table>
</form>
</body>
</html>