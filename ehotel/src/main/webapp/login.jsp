<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        form { display: inline-block; text-align: left; }
        input { margin-bottom: 10px; padding: 5px; width: 200px; }
        button { padding: 8px 15px; }
    </style>
</head>
<body>

    <h2>Login</h2>
    
    <form action="LoginServlet" method="post">
        <label for="firstName">First Name:</label><br>
        <input type="text" id="firstName" name="firstName" required><br>

        <label for="lastName">Last Name:</label><br>
        <input type="text" id="lastName" name="lastName" required><br>

        <label for="sin">SIN:</label><br>
        <input type="text" id="sin" name="sin" required pattern="[0-9]+" title="SIN must be numeric"><br>

        <button type="submit">Login</button>
    </form>

    <br><br>
    <a href="customer-signup.jsp">New user? Sign up here</a>

</body>
</html>