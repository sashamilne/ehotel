package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<String> hotels = new ArrayList<>();

        try {
            // Database connection via JNDI
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ehotelDB");
            Connection conn = ds.getConnection();
            ResultSet rs = ps.executeQuery();
            try {

                while (rs.next()) {
                    hotels.add(rs.getString("hotel_name"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Send the list of hotels to reservation.jsp
        request.setAttribute("hotels", hotels);
        request.getRequestDispatcher("reservation.jsp").forward(request, response);
    }
}