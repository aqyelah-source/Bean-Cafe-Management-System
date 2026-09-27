<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Bean Cafe Management System</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f0eb; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: #fff; padding: 32px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 320px; }
        h2 { text-align: center; color: #4b2e1e; margin-bottom: 20px; }
        label { display: block; margin-bottom: 6px; color: #333; font-size: 14px; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; margin-bottom: 16px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #6f4e37; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 15px; }
        button:hover { background: #593e2c; }
        .error { color: #c0392b; text-align: center; margin-bottom: 12px; font-size: 14px; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Bean Cafe Login</h2>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="error"><%= request.getAttribute("errorMessage") %></p>
        <% } %>

        <form action="LoginServlet" method="post">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required autofocus />

            <label for="password">Password</label>
            <input type="password" id="password" name="password" required />

            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
