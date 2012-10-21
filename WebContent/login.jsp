<%@page import="java.security.MessageDigest"%>
<%@page import="com.sun.org.apache.xml.internal.security.utils.Base64"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	if(request.getMethod() != "POST") {
	%>
		<meta http-equiv="refresh" content="0;url=index.jsp">
	<%
		return;
	}

	MessageDigest md = MessageDigest.getInstance("SHA-256");
	String password = request.getParameter("password");
	String username = request.getParameter("username");
	
	md.update(password.getBytes("UTF-8"));
	byte[] digest = md.digest();
	String digestString = Base64.encode(digest).toString();
%>

<sql:query var="users" dataSource="jdbc/lut2">
    SELECT * FROM users
    WHERE  username = ? <sql:param value="<%=username%>" /> 
    AND password = ? <sql:param value="<%=digestString%>"/>
</sql:query>
    
<c:set var="userDetails" value="${users.rows[0]}"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    	<%@include file="header.jsp"%>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUT Admin pages</title>
    </head>
    <body>
        <c:choose>
            <c:when test="${ empty userDetails }">
                Login failed
            </c:when>
            <c:otherwise>
                <h1>Login succeeded</h1> 
                Welcome ${userDetails.uname}.<br> 
                Unfortunately, there is no admin functionality here. <br>
                You need to figure out how to tamper with the application some other way.
            </c:otherwise>
        </c:choose>
        </body>
    </html>
