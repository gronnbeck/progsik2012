<%@include file="../user/userHeader.jsp"%>
<%
boolean isAdmin = false;
try {
	isAdmin = (Boolean)session.getAttribute("is_admin");
} catch (Exception e) {
	
}
if(!isAdmin) {
	%>
	<meta http-equiv="refresh" content="0;url=../user/index.jsp">
	<%
	return;
}
%>