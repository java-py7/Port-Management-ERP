package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import models.DashboardPojo;

@WebServlet("/dashboard")
public class Dashboard extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    HttpSession session = request.getSession(false);

	    if(session == null || session.getAttribute("userId") == null){
	        response.sendRedirect("login");
	        return;
	    }

	    DashboardPojo model = new DashboardPojo();
	    DashboardPojo data = model.getDashboardData();

	    request.setAttribute("dashboard", data);
	    request.setAttribute("pageTitle", "Dashboard");
	    request.setAttribute("pageContent", "dashboard.jsp");

	    request.getRequestDispatcher("/base.jsp").forward(request, response);
	}
}