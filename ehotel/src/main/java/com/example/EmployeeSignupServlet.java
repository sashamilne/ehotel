import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.example.utils.PasswordUtil;

@WebServlet("/EmployeeSignupServlet")
public class EmployeeSignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = "employee"; // Fixed role for employees

        // Hash password before storing
        String hashedPassword = PasswordUtil.hashPassword(password);

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);
            stmt.setString(3, role);

            stmt.executeUpdate();
            response.sendRedirect("employee-login.jsp"); // Redirect to employee login page
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("employee-signup.jsp?error=true"); // Redirect with error
        }
    }
}