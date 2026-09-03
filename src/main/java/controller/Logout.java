package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import models.UserPojo;

@WebServlet("/logout")
public class Logout extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session != null) {

            Integer userId = (Integer) session.getAttribute("userId");

            if (userId != null) {
                String msg = new UserPojo().logoutUser(userId);
                System.out.println(msg); // optional debug
            }

            session.invalidate();
        }

        resp.sendRedirect("login");
    }
}