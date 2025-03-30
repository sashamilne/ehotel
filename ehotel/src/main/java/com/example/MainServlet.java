package com.example;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dbtest")
public class MainServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        try {
            // Get database connection from JNDI
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ehotelDB");
            Connection conn = ds.getConnection();

            // Sample SQL query
            String sql = "SELECT NOW() AS current_time";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            // Print query result
            if (rs.next()) {
                response.getWriter().println("<h1>Database Connected!</h1>");
                response.getWriter().println("<p>Current Time: " + rs.getString("current_time") + "</p>");
            }

            // Close connections
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            response.getWriter().println("<h1>Database Connection Failed!</h1>");
            e.printStackTrace(response.getWriter());
        }
    }
}
