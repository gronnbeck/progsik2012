<%@include file="adminHeader.jsp"%>
<html>
<body>
<form action="add_school.jsp" method="POST">
	fullname <br> <input type="text" name="fullname"></input><br>
	shortname <br> <input type="text" name="shortname"></input><br>
	place <br> <input type="text" name="place"></input><br>
	zip	<br> <input type="text" name="zip"></input><br>
	country <br><input type="text" name="country"></input><br>
	<input type="hidden" name="token" value="<%=session.getAttribute("token")%>"/><br>
	<input type="submit" value="submit">
</form>
<%@include file="adminFooter.jsp"%>
</body>
</html>