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
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;




@WebServlet("/CustomerSignupServlet")
public class CustomerSignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sin = request.getParameter("sin");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // get date
        LocalDate today = LocalDate.now(); // Get today's date
        Date sqlDate = Date.valueOf(today);

        // Ensure SIN is unique
        String checkQuery = "SELECT * FROM ehotelschema.client WHERE sin = ?";
        String insertQuery = "INSERT INTO ehotelschema.client (sin, first_name, last_name, email, phone_number, registration_date) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ehotelDB");
            Connection conn = ds.getConnection();
            // Check if SIN already exists
            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setInt(1, Integer.parseInt(sin));
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    response.sendRedirect("customer-signup.jsp?error=sin_already_exists"); // SIN already exists
                    return;
                }
            }

            // Insert into database
            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                insertStmt.setInt(1, Integer.parseInt(sin));
                insertStmt.setString(2, firstName);
                insertStmt.setString(3, lastName);
                insertStmt.setString(4, email);
                insertStmt.setString(5, phone);
                insertStmt.setDate(6, sqlDate);
                insertStmt.executeUpdate();
                // Redirect to login page after successful signup
                response.sendRedirect("login.jsp");
            }
            catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("customer-signup.jsp?error=failed_to_update"); // Registration failed 
            } 
        }
        catch (Exception e) {
            response.getWriter().println("<h1>Database Connection Failed!</h1>");
            e.printStackTrace(response.getWriter());
        }
    }
}