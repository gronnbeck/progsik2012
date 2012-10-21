<%@include file="adminHeader.jsp"%>
<html>

<body>
<form action="add_country.jsp" method="POST">
	Short name<br/>
	<input type="text" name="short_name"></input><br>
	Full name <br>
	<input type="text" name="full_name"></input><br>
	<input type="hidden" name="token" value="<%=session.getAttribute("token")%>"/><br>
	<input type="submit" value="submit">
</form>
<%@include file="adminFooter.jsp"%>
</body>
</html>