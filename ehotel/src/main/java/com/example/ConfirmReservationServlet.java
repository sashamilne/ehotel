package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

@WebServlet("/ConfirmReservationServlet")
public class ConfirmReservationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int hotelId = Integer.parseInt(request.getParameter("hotelId"));
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        LocalDate reservationDate = LocalDate.now();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO reservations (hotel_id, room_id, reservation_date) VALUES (?, ?, ?)")) {
            
            

            stmt.setInt(1, hotelId);
            stmt.setInt(2, roomId);
            stmt.setDate(3, Date.valueOf(reservationDate));
            stmt.executeUpdate();

            response.sendRedirect("reservation-success.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("reservation-failed.jsp");
        }
    }
}