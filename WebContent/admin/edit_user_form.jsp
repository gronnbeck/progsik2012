// get parameters:
//	user
// SQL query (should be prepared)
// select * from users where username = user

<form action="edit_user.jsp?user=<%= user %>" method="post">

<h1><%= user %></h1>

<div>
<p>password</p><br>
<input type="text" name="password"> <br>
</div>

<div>
<p>is admin</p><br>
<select name="is_admin">
	<option value="yes">Yes</option>
	<option value0"no">No</option>
</select>
</div>


</form>

