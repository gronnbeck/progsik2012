<%@include file="userHeader.jsp"%>
<%
boolean isAdmin = false;
try {
	isAdmin = (Boolean)session.getAttribute("is_admin");
} catch (Exception e) {
	
}
if(!isAdmin) {
	%>
	<meta http-equiv="refresh" content="0;url=../loginForm.jsp">
	<%
	return;
}
%>