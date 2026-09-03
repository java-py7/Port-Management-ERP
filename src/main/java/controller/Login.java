package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import models.UserPojo;

@WebServlet("/login")
public class Login extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

	    HttpSession session = req.getSession(false);

	    if (session != null && session.getAttribute("roleId") != null) {
	        resp.sendRedirect("dashboard");
	    } else {
	        req.getRequestDispatcher("login.jsp").forward(req, resp);
	    }
	}
	
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        UserPojo input = new UserPojo();
        input.setEmail(email);
        input.setPassword(password);

        // ✔ returns full user object
        UserPojo user = input.loginUser(input);

        if (user != null) {

            HttpSession session = req.getSession();

            // ✔ store ALL session data
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("roleId", user.getRoleId());
            session.setAttribute("roleName", user.getRoleName());

            resp.sendRedirect("dashboard");

        } else {
            resp.sendRedirect("login?error=true");
        }
    }
}