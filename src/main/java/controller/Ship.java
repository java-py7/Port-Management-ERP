package controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import models.ShipPojo;
import models.UserPojo;

@WebServlet("/ship")
public class Ship extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("roleName");

        ShipPojo model = new ShipPojo();

        String search = req.getParameter("search");

        List<ShipPojo> list;

        if (search != null && !search.trim().isEmpty()) {
            list = model.searchShips(role, search);
        } else {
            list = model.getAllShips(role);
        }
        
        List<UserPojo> operators = new UserPojo().getOperators();
        req.setAttribute("operators", operators);
        
        req.setAttribute("shipList", list);

        req.setAttribute("pageTitle", "Ship");
        req.setAttribute("pageContent", "ship.jsp");

        req.getRequestDispatcher("/base.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String role = (String) req.getSession().getAttribute("roleName");
 
        String arrivalStr = req.getParameter("arrivalDate");
        String departureStr = req.getParameter("departureDate");

        // Only validate if both exist
        if (arrivalStr != null && departureStr != null &&
            !arrivalStr.isEmpty() && !departureStr.isEmpty()) {

        	LocalDateTime  arrival = LocalDateTime .parse(arrivalStr);
        	LocalDateTime  departure = LocalDateTime .parse(departureStr);

            if (!arrival.isBefore(departure)) {
                resp.sendRedirect("ship?error=invalidDate");
                return;
            }
        }
        
        ShipPojo s = new ShipPojo();

        if ("add".equals(action)) {

            s.setShipName(req.getParameter("shipName"));
            s.setArrivalDate(req.getParameter("arrivalDate"));
            s.setDepartureDate(req.getParameter("departureDate"));
            s.setOperatorId(Integer.parseInt(req.getParameter("operatorId")));

            s.addShip(s, role);
        }

        else if ("edit".equals(action)) {

            s.setShipId(Integer.parseInt(req.getParameter("shipId")));
            s.setShipName(req.getParameter("shipName"));
            s.setArrivalDate(req.getParameter("arrivalDate"));
            s.setDepartureDate(req.getParameter("departureDate"));
            s.setOperatorId(Integer.parseInt(req.getParameter("operatorId")));

            s.updateShip(s, role);
        }

        else if ("delete".equals(action)) {
            s.deleteShip(Integer.parseInt(req.getParameter("shipId")), role);
        }

        else if ("status".equals(action)) {
            s.setShipStatus(
                Integer.parseInt(req.getParameter("shipId")),
                req.getParameter("status"),
                role
            );
        }

        resp.sendRedirect("ship");
    }
}