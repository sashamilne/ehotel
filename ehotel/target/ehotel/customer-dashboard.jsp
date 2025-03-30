<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%

    String firstName = (session != null) ? (String) session.getAttribute("firstName") : null;

    if (firstName == null) {
        response.sendRedirect("login.jsp"); // Redirect if no session
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard</title>
</head>
<body>
    <h1>Welcome, <%= firstName %>!</h1>
    
    <p>Choose an option:</p>
    
    <form action="reservation.jsp">
        <button type="submit">Make a Reservation</button>
    </form>

    <form action="LogoutServlet" method="post">
        <button type="submit">Logout</button>
    </form>
</body>
</html>