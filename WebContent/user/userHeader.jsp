<%@include file="../header.jsp"%>
<%
if(session.getAttribute("username") == null) {
	%>
	<meta http-equiv="refresh" content="0;url=../loginForm.jsp">
	<%
	return;
}
%>