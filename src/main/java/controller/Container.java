package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import models.CargoPojo;
import models.ContainerPojo;
import models.ShipPojo;

@WebServlet("/container")
public class Container extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	
        HttpSession session = req.getSession(false);

        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login");
            return;
        }
        
        String role = (String) session.getAttribute("roleName");

        String search = req.getParameter("search");

        
        List<ContainerPojo> list;

        if(search != null && !search.trim().isEmpty()){
            list = ContainerPojo.searchContainers(role, search);
        } else {
            list = ContainerPojo.showContainers(role);
        }
        
        String action = req.getParameter("action");

        if ("getCargo".equals(action)) {

            int containerId = Integer.parseInt(req.getParameter("containerId"));

            List<CargoPojo> cargoList = new CargoPojo().getCargoByContainer(containerId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            PrintWriter out = resp.getWriter();

            out.print("[");
            for (int i = 0; i < cargoList.size(); i++) {
                CargoPojo c = cargoList.get(i);

                out.print("{");
                out.print("\"description\":\"" + c.getDescription() + "\",");
                out.print("\"weight\":\"" + c.getWeight() + "\"");
                out.print("}");

                if (i < cargoList.size() - 1) {
                    out.print(",");
                }
            }
            out.print("]");

            return;
        }
        
        List<ShipPojo> shipList = new ShipPojo().getDockedShips();
        req.setAttribute("shipList", shipList);
        req.setAttribute("containerList", list);
        req.setAttribute("pageTitle", "Container");
        req.setAttribute("pageContent", "container.jsp");

        req.getRequestDispatcher("/base.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String role = (String) req.getSession().getAttribute("roleName");
        
        ContainerPojo c = new ContainerPojo();
        
        if("add".equals(action)){
            c.setContainerType(req.getParameter("containerType"));
            c.addContainer(c, role);
        }

        else if("assign".equals(action)){
            c.assignToShip(
                Integer.parseInt(req.getParameter("containerId")),
                Integer.parseInt(req.getParameter("shipId")),
                role
            );
        }

        else if("edit".equals(action)){
            c.setContainerId(Integer.parseInt(req.getParameter("containerId")));
            c.setContainerType(req.getParameter("containerType"));
            c.setShipId(Integer.parseInt(req.getParameter("shipId")));
            c.updateContainer(c, role);
        }

        else if("delete".equals(action)){
            c.deleteContainer(
                Integer.parseInt(req.getParameter("containerId")),
                role
            );
        }

        else if("status".equals(action)){
            c.setStatus(
                Integer.parseInt(req.getParameter("containerId")),
                req.getParameter("status"),
                role
            );
        }
        

        resp.sendRedirect("container");
    }
}