package com.beancafe.controller;

import com.beancafe.dao.MenuDAO;
import com.beancafe.dao.MenuDAOInterface;
import com.beancafe.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private MenuDAOInterface menuDAO;

    @Override
    public void init() {
        menuDAO = new MenuDAO();
    }

    // Handle GET requests
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {

            case "add":
                showAddForm(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
                deleteMenu(request, response);
                break;

            case "list":
            default:
                listMenu(request, response);
                break;
        }
    }

    // Handle POST requests
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        switch (action) {

            case "insert":
                insertMenu(request, response);
                break;

            case "update":
                updateMenu(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/menu");
                break;
        }
    }

    // READ - Display all menu items
    private void listMenu(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        List<Menu> menuList = menuDAO.getAllMenu();

        request.setAttribute("menuList", menuList);

        request.getRequestDispatcher("/menu-list.jsp")
               .forward(request, response);
    }

    // Show Add Menu form
    private void showAddForm(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/menu-form.jsp")
               .forward(request, response);
    }

    // Show Edit Menu form
    private void showEditForm(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int menuId = Integer.parseInt(request.getParameter("id"));

            Menu selectedMenu = null;

            List<Menu> menuList = menuDAO.getAllMenu();

            for (Menu menu : menuList) {
                if (menu.getMenuId() == menuId) {
                    selectedMenu = menu;
                    break;
                }
            }

            if (selectedMenu == null) {
                response.sendRedirect(request.getContextPath() + "/menu");
                return;
            }

            request.setAttribute("menu", selectedMenu);

            request.getRequestDispatcher("/menu-form.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/menu");
        }
    }

    // CREATE - Insert new menu item
    private void insertMenu(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        try {
            int adminId = Integer.parseInt(
                    request.getParameter("adminId")
            );

            String menuName = request.getParameter("menuName");
            String category = request.getParameter("category");

            double price = Double.parseDouble(
                    request.getParameter("price")
            );

            String availability =
                    request.getParameter("availability");

            Menu menu = new Menu();

            menu.setAdminId(adminId);
            menu.setMenuName(menuName);
            menu.setCategory(category);
            menu.setPrice(price);
            menu.setAvailability(availability);

            menuDAO.addMenu(menu);

            response.sendRedirect(
                    request.getContextPath() + "/menu"
            );

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/menu?action=add"
            );
        }
    }

    // UPDATE - Update existing menu item
    private void updateMenu(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        try {
            int menuId = Integer.parseInt(
                    request.getParameter("menuId")
            );

            String menuName = request.getParameter("menuName");
            String category = request.getParameter("category");

            double price = Double.parseDouble(
                    request.getParameter("price")
            );

            String availability =
                    request.getParameter("availability");

            Menu menu = new Menu();

            menu.setMenuId(menuId);
            menu.setMenuName(menuName);
            menu.setCategory(category);
            menu.setPrice(price);
            menu.setAvailability(availability);

            menuDAO.updateMenu(menu);

            response.sendRedirect(
                    request.getContextPath() + "/menu"
            );

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/menu"
            );
        }
    }

    // DELETE - Delete menu item
    private void deleteMenu(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        try {
            int menuId = Integer.parseInt(
                    request.getParameter("id")
            );

            menuDAO.deleteMenu(menuId);

        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        response.sendRedirect(
                request.getContextPath() + "/menu"
        );
    }
}
