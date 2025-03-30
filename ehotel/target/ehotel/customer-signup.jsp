<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Customer Registration</title>
    <script>
        function validateForm() {
            let email = document.getElementById("email").value;
            let phone = document.getElementById("phone").value;
            let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            let phonePattern = /^\d{10}$/;

            if (!emailPattern.test(email)) {
                alert("Please enter a valid email.");
                return false;
            }

            if (!phonePattern.test(phone)) {
                alert("Please enter a valid 10-digit phone number.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
    <h2>Customer Registration</h2>

    <% if ("true".equals(request.getParameter("error"))) { %>
        <p style="color: red;">Registration failed. Try again.</p>
    <% } %>

    <form action="CustomerSignupServlet" method="post" onsubmit="return validateForm()">
        SIN (9 digits): <input type="number" name="sin" required pattern="\d{9}" title="Enter a 9-digit SIN"><br>
        First Name: <input type="text" name="firstName" required><br>
        Last Name: <input type="text" name="lastName" required><br>
        Email: <input type="email" id="email" name="email" required><br>
        Phone (10 digits): <input type="text" id="phone" name="phone" required pattern="\d{10}" title="Enter a 10-digit phone number"><br>
        <input type="submit" value="Register">
    </form>
</body>
</html>