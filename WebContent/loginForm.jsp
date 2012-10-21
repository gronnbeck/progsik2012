

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    	<%@include file="header.jsp"%>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUTAdmin</title>
    </head>
    <body>
        <h1>Welcome to the LUT2.0 login page!</h1>
        <table border="0">
            <thead>
                <tr>
                    <th>Login:</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><form method="post" action="login.jsp">
                            <p>
                                Username:</font><input type="text" name="username" size="20"></p>
                            <p>
                                Password:</font><input type="password" name="password" size="20"></p>
                            <p><input type="submit" value="submit" name="login"></p>
                        </form></td>
                </tr>
            </tbody>
        </table>
        <a href="registerForm.jsp">Register</a>
    </body>
</html>
