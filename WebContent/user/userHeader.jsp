<%@include file="../header.jsp"%>
<%
if(session.getAttribute("username") == null) {
	%>
	<meta http-equiv="refresh" content="0;url=/LUT_2.0/loginForm.jsp">
	<%
	return;
}
%>