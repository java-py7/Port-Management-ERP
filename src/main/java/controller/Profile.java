package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import models.UserPojo;

@WebServlet("/profile")
public class Profile extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        UserPojo model = new UserPojo();

        UserPojo user = model.getUserById(userId);

        req.setAttribute("profileUser", user);

        req.setAttribute("pageTitle", "Profile");
        req.setAttribute("pageContent", "profile.jsp");

        req.getRequestDispatcher("/base.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int roleId = (Integer) session.getAttribute("roleId");

        String action = req.getParameter("action");

        UserPojo model = new UserPojo();
        
        try {
        	
        	if ("updateProfile".equals(action)) {

        	    UserPojo user = new UserPojo();

        	    user.setUserId(userId);
        	    user.setName(req.getParameter("name"));
        	    user.setEmail(req.getParameter("email"));

        	    // 🔥 ADD THIS LINE
        	    String roleName = (String) session.getAttribute("roleName");

        	    // 🔥 UPDATED METHOD CALL
        	    boolean updated = model.updateProfile(user, roleId, roleName);

        	    if (updated) {
        	        session.setAttribute("userName", user.getName());
        	        session.setAttribute("userEmail", user.getEmail());

        	        resp.sendRedirect("profile?success=Profile updated successfully");
        	        return;
        	    } else {
        	        resp.sendRedirect("profile?error=Update failed");
        	        return;
        	    }
        	}
        	else if ("changePassword".equals(action)) {

        	    String pass = req.getParameter("newPassword");
        	    String confirm = req.getParameter("confirmPassword");

        	    if (pass == null || !pass.equals(confirm)) {
        	        resp.sendRedirect("profile?error=Passwords do not match");
        	        return;
        	    }

        	    UserPojo user = new UserPojo();

        	    user.setUserId(userId);
        	    user.setPassword(pass);

        	    // 🔥 IMPORTANT → keep others NULL
        	    user.setName(null);
        	    user.setEmail(null);

        	    String roleName = (String) session.getAttribute("roleName");

        	    boolean changed = model.updateProfile(user, roleId, roleName);

        	    if (changed) {
        	        resp.sendRedirect("profile?success=Password updated");
        	    } else {
        	        resp.sendRedirect("profile?error=Password update failed");
        	    }
        	    return;
        	}
        	System.out.println("UPDATE PROFILE HIT");
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("profile");
    }
}