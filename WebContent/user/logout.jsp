<%
	session.removeAttribute("username");
	session.removeAttribute("email");
	session.removeAttribute("is_admin");
	session.removeAttribute("token");
%>
<meta http-equiv="refresh" content="0;url=index.jsp">
