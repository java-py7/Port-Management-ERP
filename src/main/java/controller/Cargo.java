package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import models.CargoPojo;
import models.ContainerPojo;

@WebServlet("/cargo")
public class Cargo extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("roleName");

        String search = req.getParameter("search");

        List<CargoPojo> list;

        if(search != null && !search.trim().isEmpty()){
            list = CargoPojo.searchCargo(role, search);
        } else {
            list = CargoPojo.showCargo(role);
        }
        List<ContainerPojo> containers = ContainerPojo.showContainers(role);
        req.setAttribute("containerList", containers);
        req.setAttribute("cargoList", list);
        req.setAttribute("pageTitle", "Cargo");
        req.setAttribute("pageContent", "cargo.jsp");

        req.getRequestDispatcher("/base.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String role = (String) req.getSession().getAttribute("roleName");

        HttpSession session = req.getSession(false);
        int userId = (int) session.getAttribute("userId");

        CargoPojo c = new CargoPojo();

        if("add".equals(action)){
            c.setContainerId(Integer.parseInt(req.getParameter("containerId")));
            c.setDescription(req.getParameter("description"));
            c.setWeight(Double.parseDouble(req.getParameter("weight")));
            c.addCargo(c, role);
        }

        else if("edit".equals(action)){
            c.setCargoId(Integer.parseInt(req.getParameter("cargoId")));
            c.setContainerId(Integer.parseInt(req.getParameter("containerId")));
            c.setWeight(Double.parseDouble(req.getParameter("weight")));
            c.setDescription(req.getParameter("description"));
            c.updateCargo(c, role);
        }

        else if("delete".equals(action)){
            c.deleteCargo(Integer.parseInt(req.getParameter("cargoId")), role);
        }

        else if("status".equals(action)){
            c.setStatus(
                Integer.parseInt(req.getParameter("cargoId")),
                req.getParameter("status"),
                role,
                userId
            );
        }

        resp.sendRedirect("cargo");
    }
}