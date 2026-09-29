package com.beancafe.controller;

import com.beancafe.dao.AdminDAO;
import com.beancafe.dao.ReportDAO;
import com.beancafe.model.Order;
import com.beancafe.model.Report;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet("/report")
public class ReportServlet extends HttpServlet {

    private ReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("role") == null
                || !"Admin".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp");

            return;
        }

        // Default filter
        int currentYear
                = LocalDate.now().getYear();

        Map<Integer, Double> salesByMonth
                = reportDAO.getMonthlySalesByYear(
                        currentYear);

        request.setAttribute(
                "selectedMonth",
                0);

        request.setAttribute(
                "selectedYear",
                currentYear);

        request.setAttribute(
                "salesByMonth",
                salesByMonth);

        request.getRequestDispatcher(
                "/report.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("role") == null
                || !"Admin".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp");

            return;
        }

        String action
                = request.getParameter("action");

        if ("generate".equals(action)) {

            generateReport(
                    request,
                    response);

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/report");
        }
    }

    // =========================
    // GENERATE REPORT
    // =========================
    private void generateReport(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int month
                    = Integer.parseInt(
                            request.getParameter(
                                    "month"));

            int year
                    = Integer.parseInt(
                            request.getParameter(
                                    "year"));

            HttpSession session
                    = request.getSession(false);

            int userId
                    = (Integer) session.getAttribute(
                            "userId");

            AdminDAO adminDAO
                    = new AdminDAO();

            int adminId
                    = adminDAO.getAdminIdByUserId(
                            userId);

            // Summary
            Report generatedReport
                    = reportDAO.generateMonthlyReport(
                            adminId,
                            month,
                            year);

            // Orders based on filter
            List<Order> orderList
                    = reportDAO.getOrdersForReport(
                            month,
                            year);

            // Graph for whole selected year
            Map<Integer, Double> salesByMonth
                    = reportDAO.getMonthlySalesByYear(
                            year);

            request.setAttribute(
                    "generatedReport",
                    generatedReport);

            request.setAttribute(
                    "orderList",
                    orderList);

            request.setAttribute(
                    "salesByMonth",
                    salesByMonth);

            request.setAttribute(
                    "selectedMonth",
                    month);

            request.setAttribute(
                    "selectedYear",
                    year);

            request.getRequestDispatcher(
                    "/report.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/report");
        }
    }
}
