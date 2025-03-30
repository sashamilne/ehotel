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

import jakarta.servlet.http.HttpSession;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        int sin = Integer.parseInt(request.getParameter("sin"));  // Parse SIN as an integer

        // SQL queries to check users and employees tables
        String userQuery = "SELECT * FROM ehotelschema.client WHERE first_name = ? AND last_name = ? AND sin = ?";
        String employeeQuery = "SELECT * FROM ehotelschema.employee WHERE first_name = ? AND last_name = ? AND sin = ?";

        try  {
            // Get database connection from JNDI
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ehotelDB");
            Connection conn = ds.getConnection();
            // Check if user exists in users table
            try (PreparedStatement userStmt = conn.prepareStatement(userQuery)) {
                userStmt.setString(1, firstName);
                userStmt.setString(2, lastName);
                userStmt.setInt(3, sin);
                ResultSet userRs = userStmt.executeQuery();

                if (userRs.next()) {
                    // Create session for customer
                    HttpSession session = request.getSession();
                    session.setAttribute("userType", "customer");
                    session.setAttribute("firstName", firstName);
                    session.setAttribute("lastName", lastName);

                    // Redirect to customer dashboard
                    response.sendRedirect("customer-dashboard.jsp");
                    return; // Stop further execution
                }
            }
             catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("login.jsp?error=sqlexception");  // Redirect back with error

            }

        

        // Check if user exists in employees table
        try (PreparedStatement employeeStmt = conn.prepareStatement(employeeQuery)) {
            employeeStmt.setString(1, firstName);
            employeeStmt.setString(2, lastName);
            employeeStmt.setInt(3, sin);
            ResultSet employeeRs = employeeStmt.executeQuery();

            if (employeeRs.next()) {
                // Create session for employee
                HttpSession session = request.getSession();
                session.setAttribute("userType", "employee");
                session.setAttribute("firstName", firstName);
                session.setAttribute("lastName", lastName);

                // Redirect to employee dashboard
                response.sendRedirect("employee-dashboard.jsp");
                return;
                }
                // If no match found, redirect back to login page with an error
                response.sendRedirect("login.jsp?error=nomatch");
            }
        
        catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=sqlexception");  // Redirect back with error
            }
    }
    catch (Exception e) {
            response.getWriter().println("<h1>Database Connection Failed!</h1>");
            e.printStackTrace(response.getWriter());
        }
    }
}
