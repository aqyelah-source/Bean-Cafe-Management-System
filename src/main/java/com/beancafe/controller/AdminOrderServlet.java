package com.beancafe.controller;

import com.beancafe.dao.OrderDAO;
import com.beancafe.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-order")
public class AdminOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
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


        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }


        switch (action) {

            // ==================================
            // VIEW ORDER DETAILS
            // ==================================
            case "view":

                viewOrder(
                        request,
                        response
                );

                break;


            // ==================================
            // DISPLAY ALL ORDERS
            // ==================================
            case "list":

            default:

                listOrders(
                        request,
                        response
                );

                break;
        }
    }


    // ==========================================
    // LIST ALL ORDERS
    // ==========================================
        private void listOrders(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // PAGINATION
        // ==========================================
        int currentPage = 1;
        int recordsPerPage = 5;

        try {

            String pageParam =
                    request.getParameter("page");

            if (pageParam != null) {

                currentPage =
                        Integer.parseInt(pageParam);
            }

            if (currentPage < 1) {

                currentPage = 1;
            }

        } catch (NumberFormatException e) {

            currentPage = 1;
        }


        // ==========================================
        // COUNT TOTAL ORDERS
        // ==========================================
        int totalRecords =
                orderDAO.getOrderCount();

        int totalPages =
                (int) Math.ceil(
                        (double) totalRecords
                        / recordsPerPage
                );

        if (totalPages < 1) {

            totalPages = 1;
        }

        if (currentPage > totalPages) {

            currentPage = totalPages;
        }


        // ==========================================
        // GET ONLY 5 ORDERS FOR CURRENT PAGE
        // ==========================================
        List<Order> orderList =
                orderDAO.getOrdersByPage(
                        currentPage,
                        recordsPerPage
                );


        // ==========================================
        // SEND DATA TO JSP
        // ==========================================
        request.setAttribute(
                "orderList",
                orderList
        );

        request.setAttribute(
                "currentPage",
                currentPage
        );

        request.setAttribute(
                "totalPages",
                totalPages
        );

        request.setAttribute(
                "totalRecords",
                totalRecords
        );


        request.getRequestDispatcher(
                "/admin-order-list.jsp"
        ).forward(
                request,
                response
        );
    }


    // ==========================================
    // VIEW ORDER DETAILS
    // ==========================================
    private void viewOrder(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int orderId
                    = Integer.parseInt(
                            request.getParameter("id")
                    );

            Order order
                    = orderDAO.getOrderById(
                            orderId
                    );


            // Order not found
            if (order == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-order?error=notfound"
                );

                return;
            }


            request.setAttribute(
                    "order",
                    order
            );


            request.getRequestDispatcher(
                    "/admin-order-view.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-order"
            );
        }
    }
}