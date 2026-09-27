package com.beancafe.controller;

import com.beancafe.dao.UserDAO;
import com.beancafe.model.User;
import com.beancafe.util.PasswordUtil;

import java.io.IOException;

// NOTE: If your server is an older GlassFish/Tomcat (Servlet 4 or earlier),
// change these imports to the javax.servlet.* equivalents instead.
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles the login form submission from login.jsp.
 * Uses your groupmate's existing UserDAO.getUserByUsername() method.
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByUsername(username);

        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
            // valid credentials -> create session
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("name", user.getName());
            session.setAttribute("role", user.getRole());

            if ("Admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.sendRedirect("staff-dashboard.jsp");
            }
        } else {
            // invalid credentials -> show error back on login.jsp
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
