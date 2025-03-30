<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hotel Reservation</title>
</head>
    <body>

    <h2>Select a Hotel</h2>

        <form action="ProcessReservationServlet" method="POST">
            <label for="hotel">Choose a hotel:</label>
            <select name="hotel" id="hotel">
                <%
                    List<String> hotels = (List<String>) request.getAttribute("hotels");
                    if (hotels != null) {
                        for (String hotel : hotels) {
                %>
                    <option value="<%= hotel %>"><%= hotel %></option>
                <%
                        }
                    }
                %>
            </select>
            
            <br><br>
            <input type="submit" value="Check Availability">
        </form>

    </body>
</html>