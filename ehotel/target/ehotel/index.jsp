<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to E-Hotel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 50px;
        }
        h1 {
            color: #333;
        }
        .container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }
        .btn {
            padding: 15px 30px;
            font-size: 18px;
            text-decoration: none;
            color: white;
            border-radius: 5px;
            transition: 0.3s;
            border: none;
            cursor: pointer;
        }
        .btn-customer {
            background-color: #3498db;
        }
        .btn-employee {
            background-color: #e74c3c;
        }
        .btn:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>

    <h1>Welcome to E-Hotel</h1>
    <p>Please select your login type:</p>

    <div class="container">
        <a href="login.jsp" class="btn btn-customer">Login</a>
    </div>

</body>
</html>
