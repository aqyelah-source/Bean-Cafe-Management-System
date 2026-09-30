package com.beancafe.controller;

import com.beancafe.dao.OrderHistoryDAO;
import com.beancafe.model.OrderHistory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {

    private OrderHistoryDAO orderHistoryDAO;

    @Override
    public void init() {
        orderHistoryDAO = new OrderHistoryDAO();
    }


    // ==========================================
    // HANDLE GET REQUEST
    // ==========================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ==========================================
        // ADMIN ONLY
        // ==========================================
        if (session == null
                || session.getAttribute("role") == null
                || !"Admin".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        // ==========================================
        // GET ALL ORDER HISTORY
        // ==========================================
        List<OrderHistory> historyList
                = orderHistoryDAO.getAllHistory();


        // ==========================================
        // SEND DATA TO JSP
        // ==========================================
        request.setAttribute(
                "historyList",
                historyList
        );


        // ==========================================
        // DISPLAY ORDER HISTORY PAGE
        // ==========================================
        request.getRequestDispatcher(
                "/order-history.jsp"
        ).forward(
                request,
                response
        );
    }
}