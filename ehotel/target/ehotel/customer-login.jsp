<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Login</title>
</head>
<body>
    <h2>Customer Login</h2>
    <form action="CustomerLoginServlet" method="post">
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Login">
    </form>

    <%-- Display error message if login fails --%>
    <% 
        String error = request.getParameter("error");
        if ("true".equals(error)) {
    %>
        <p style="color: red;">Invalid username or password.</p>
    <% } %>
</body>
</html>