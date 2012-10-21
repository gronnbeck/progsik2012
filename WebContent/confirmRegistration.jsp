<%@page import="java.util.regex.Pattern"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%
	String username = request.getParameter("username");
	String validateString = request.getParameter("validate");
	
	if(username == null || validateString == null) {
		%>
		<meta http-equiv="refresh" content="0;url=index.jsp">
		<%
		return;
	}
	
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource) envCtx.lookup("jdbc/lut2");
	
	Connection connection = dataSource.getConnection();
	PreparedStatement pstatement = null, statement = null;
	ResultSet rs = null;
	try {
		String queryString = "SELECT * FROM users WHERE username=? AND validatestring=?";
		pstatement = connection.prepareStatement(queryString);
		pstatement.setString(1, username);
		pstatement.setString(2, validateString);
		rs = pstatement.executeQuery();
		if(rs.next()) {
			String updateString = "UPDATE users SET validated=? WHERE username=?";
			statement = connection.prepareStatement(updateString);
			statement.setBoolean(1, true);
			statement.setString(2, username);
			statement.executeUpdate();
		} else {
			return;
		}
		
	} catch (Exception ex) {
		out.println("Unable to execute update to database: " + ex.getMessage());
		return;
	} finally {
		statement.close();
		pstatement.close();
		connection.close();
	}
	%>
<meta http-equiv="refresh" content="0;url=index.jsp">