package com.beancafe.dao;

import com.beancafe.model.Report;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    // Generate monthly report from completed orders
    public Report generateMonthlyReport(
            int adminId, int month, int year) {

        String sql = "SELECT COUNT(*) AS total_orders, "
                   + "COALESCE(SUM(total_price), 0) AS total_sales "
                   + "FROM orders "
                   + "WHERE MONTH(order_date) = ? "
                   + "AND YEAR(order_date) = ? "
                   + "AND status = 'Completed'";

        Report report = new Report();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, month);
            stmt.setInt(2, year);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    report.setAdminId(adminId);
                    report.setReportMonth(month);
                    report.setReportYear(year);
                    report.setTotalOrders(
                            rs.getInt("total_orders"));
                    report.setTotalSales(
                            rs.getDouble("total_sales"));
                    report.setGeneratedAt(LocalDateTime.now());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return report;
    }


    // Save generated report into REPORT table
    public boolean saveReport(Report report) {

        String sql = "INSERT INTO report "
                   + "(admin_id, report_month, report_year, "
                   + "total_orders, total_sales, generated_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, report.getAdminId());
            stmt.setInt(2, report.getReportMonth());
            stmt.setInt(3, report.getReportYear());
            stmt.setInt(4, report.getTotalOrders());
            stmt.setDouble(5, report.getTotalSales());
            stmt.setTimestamp(
                    6,
                    Timestamp.valueOf(report.getGeneratedAt()));

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // READ - View saved reports
    public List<Report> getAllReports() {

        List<Report> reportList = new ArrayList<>();

        String sql = "SELECT * FROM report ORDER BY generated_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                Report report = new Report();

                report.setReportId(rs.getInt("report_id"));
                report.setAdminId(rs.getInt("admin_id"));
                report.setReportMonth(rs.getInt("report_month"));
                report.setReportYear(rs.getInt("report_year"));
                report.setTotalOrders(rs.getInt("total_orders"));
                report.setTotalSales(rs.getDouble("total_sales"));

                Timestamp timestamp =
                        rs.getTimestamp("generated_at");

                if (timestamp != null) {
                    report.setGeneratedAt(
                            timestamp.toLocalDateTime());
                }

                reportList.add(report);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reportList;
    }
}