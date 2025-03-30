<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
</head>
<body>
    <h2>Create an Account</h2>
    <form action="SignupServlet" method="post">
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        Role:
        <select name="role">
            <option value="customer">Customer</option>
            <option value="employee">Employee</option>
        </select>
        <br>
        <input type="submit" value="Sign Up">
    </form>

    <%-- Display error message if sign-up fails --%>
    <% String error = request.getParameter("error");
       if ("true".equals(error)) { %>
        <p style="color: red;">Username already exists. Please choose another.</p>
    <% } %>
</body>
</html>