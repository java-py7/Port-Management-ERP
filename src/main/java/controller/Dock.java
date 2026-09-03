package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import models.DockPojo;

@WebServlet("/dock")
public class Dock extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("roleName");

        DockPojo model = new DockPojo();

        String search = req.getParameter("search");

        List<DockPojo> list;

        if (search != null && !search.trim().isEmpty()) {
            list = model.searchDocks(role, search);
        } else {
            list = model.getAllDocks(role);
        }

        req.setAttribute("dockList", list);

        req.setAttribute("pageTitle", "Dock Management");
        req.setAttribute("pageContent", "dock.jsp");

        req.getRequestDispatcher("/base.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String role = (String) req.getSession().getAttribute("roleName");

        DockPojo d = new DockPojo();

        if ("add".equals(action)) {

            d.setDockName(req.getParameter("dockName"));
            d.addDock(d, role);
        }

        else if ("edit".equals(action)) {

            d.setDockId(Integer.parseInt(req.getParameter("dockId")));
            d.setDockName(req.getParameter("dockName"));

            d.updateDock(d, role);
        }

        else if ("delete".equals(action)) {
            d.deleteDock(Integer.parseInt(req.getParameter("dockId")), role);
        }

        else if ("status".equals(action)) {
            d.setDockStatus(
                Integer.parseInt(req.getParameter("dockId")),
                req.getParameter("status"),
                role
            );
        }

        resp.sendRedirect("dock");
    }
}