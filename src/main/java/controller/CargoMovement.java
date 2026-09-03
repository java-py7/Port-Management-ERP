package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import models.CargoMovementPojo;
import models.CargoPojo;

@WebServlet("/cargo-movement")
public class CargoMovement extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	        throws ServletException, IOException {

	    HttpSession session = req.getSession(false);

	    if(session == null || session.getAttribute("userId") == null){
	        resp.sendRedirect("login");
	        return;
	    }

	    String role = (String) session.getAttribute("roleName");
	    String search = req.getParameter("search");

	    List<CargoMovementPojo> list;

	    if(search != null && !search.trim().isEmpty()){
	        list = CargoMovementPojo.search(role, search);
	    } else {
	        list = CargoMovementPojo.getAll(role);
	    }

	    // ✅ FETCH CARGO LIST
	    List<CargoPojo> cargoList = new CargoPojo().getAllCargo();

	    // ✅ SET ATTRIBUTES
	    req.setAttribute("movementList", list);
	    req.setAttribute("cargoList", cargoList);

	    req.setAttribute("pageTitle", "Cargo Movement");
	    req.setAttribute("pageContent", "cargo-movement.jsp");

	    req.getRequestDispatcher("/base.jsp").forward(req, resp);
	}

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String role = (String) req.getSession().getAttribute("roleName");

        CargoMovementPojo m = new CargoMovementPojo();

        if("add".equals(action)){
            m.setCargoId(Integer.parseInt(req.getParameter("cargoId")));
            m.setMovementType(req.getParameter("movementType"));
            int userId = (Integer) req.getSession().getAttribute("userId");
            m.setHandledBy(String.valueOf(userId));

            m.addMovement(m, role);
        }

        else if("edit".equals(action)){
            m.setMovementId(Integer.parseInt(req.getParameter("movementId")));
            m.setCargoId(Integer.parseInt(req.getParameter("cargoId")));
            m.setMovementDate(req.getParameter("movementDate"));
            m.setHandledBy(req.getParameter("handledBy"));

            m.updateMovement(m, role);
        }

        resp.sendRedirect("cargo-movement");
    }
}