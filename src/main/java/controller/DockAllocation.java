package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import models.DockAllocationPojo;
import models.DockPojo;
import models.ShipPojo;

@WebServlet("/dock-allocation")
public class DockAllocation extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("roleName");

        DockAllocationPojo model = new DockAllocationPojo();

        String search = req.getParameter("search");

        List<DockAllocationPojo> activeList;
        List<DockAllocationPojo> releasedList;

        if (search != null && !search.trim().isEmpty()) {

            activeList = model.searchActiveAllocations(role, search);
            releasedList = model.searchReleasedAllocations(role, search);

        } else {

            activeList = model.getActiveAllocations(role);
            releasedList = model.getReleasedAllocations(role);
        }

        req.setAttribute("allocationList", activeList);
        req.setAttribute("releasedList", releasedList);
        
     // get ships with status Anchored / Arrived
        List<ShipPojo> shipList = new ShipPojo().getShipsForAllocation(); // or ShipPojo

        req.setAttribute("shipList", shipList);
        
        List<DockPojo> dockList = new DockPojo().getAvailableDocks(role);

        req.setAttribute("dockList", dockList);

        req.setAttribute("pageTitle", "Dock Allocation");
        req.setAttribute("pageContent", "dock-allocation.jsp");

        req.getRequestDispatcher("/base.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String role = (String) req.getSession().getAttribute("roleName");

        DockAllocationPojo a = new DockAllocationPojo();

        if ("add".equals(action)) {

            a.setShipId(Integer.parseInt(req.getParameter("shipId")));
            a.setDockId(Integer.parseInt(req.getParameter("dockId")));

            a.addAllocation(a, role);
        }

        else if ("release".equals(action)) {

            int allocationId = Integer.parseInt(req.getParameter("allocationId"));
            int dockId = Integer.parseInt(req.getParameter("dockId"));
            int shipId = Integer.parseInt(req.getParameter("shipId"));

            a.releaseAllocation(allocationId, dockId, shipId, role);
        }

        else if ("edit".equals(action)) {

            a.setAllocationId(Integer.parseInt(req.getParameter("allocationId")));
            a.setShipId(Integer.parseInt(req.getParameter("shipId")));
            a.setDockId(Integer.parseInt(req.getParameter("dockId")));
            a.setAllocationTime(req.getParameter("allocationTime"));

            a.updateAllocation(a, role);
        }

        else if ("delete".equals(action)) {

            int allocationId = Integer.parseInt(req.getParameter("allocationId"));
            a.deleteAllocation(allocationId, role);
        }
        
        else if ("editRelease".equals(action)) {

            int allocationId = Integer.parseInt(req.getParameter("allocationId"));
            String releaseTime = req.getParameter("releaseTime");

            a.updateReleaseTime(allocationId, releaseTime, role);
        }
        resp.sendRedirect("dock-allocation");
    }
}