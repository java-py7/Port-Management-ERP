package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import models.SecurityLogPojo;

@WebServlet("/security-log")
public class SecurityLog extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        String roleName = (String) session.getAttribute("roleName");

        if (!(roleName.equalsIgnoreCase("Administrator") || roleName.equalsIgnoreCase("Port Manager"))) {

            req.setAttribute("errorMessage","Only Administrator and Port Manager can access Security Log.");
            return;
        }

        String action = req.getParameter("action");

        SecurityLogPojo model = new SecurityLogPojo(); // ✅ MODEL

        if (action == null || action.equals("show")) {

            req.setAttribute("securityLogList", model.getAllLogs());

            req.setAttribute("pageTitle", "Security Log");
            req.setAttribute("pageContent", "security-log.jsp");
            
            req.getRequestDispatcher("/base.jsp").forward(req, resp);
        }

        else if ("search".equals(action)) {

            req.setAttribute("securityLogList",
                model.searchLogs(
                    req.getParameter("username"),
                    req.getParameter("role"),
                    req.getParameter("fromDate"),
                    req.getParameter("toDate")
                ));

            req.setAttribute("username", req.getParameter("username"));
            req.setAttribute("role", req.getParameter("role"));
            req.setAttribute("fromDate", req.getParameter("fromDate"));
            req.setAttribute("toDate", req.getParameter("toDate"));

            req.setAttribute("pageTitle", "Security Log");
            req.setAttribute("pageContent", "security-log.jsp");

            req.getRequestDispatcher("/base.jsp").forward(req, resp);
        }

        else if ("export".equals(action)) {

        	String username = req.getParameter("username");
        	String role = req.getParameter("role");
        	String fromDate = req.getParameter("fromDate");
        	String toDate = req.getParameter("toDate");

        	List<SecurityLogPojo> list;

        	// If any filter is applied → use search
        	if ((username != null && !username.isEmpty()) ||
        	    (role != null && !role.equals("All Roles")) ||
        	    (fromDate != null && !fromDate.isEmpty()) ||
        	    (toDate != null && !toDate.isEmpty())) {

        	    list = model.searchLogs(username, role, fromDate, toDate);

        	} else {
        	    list = model.getAllLogs();
        	}

            resp.setContentType("text/csv");
            resp.setHeader("Content-Disposition", "attachment; filename=security-log.csv");

            PrintWriter out = resp.getWriter();

            out.println("Log ID,User ID,Username,Role,Entry Time,Exit Time,Duration");

            for (SecurityLogPojo s : list) {
                out.println(
                    s.getLogId() + "," +
                    s.getUserId() + "," +
                    s.getUsername() + "," +
                    s.getRoleName() + "," +
                    s.getEntryTime() + "," +
                    s.getExitTime() + "," +
                    s.getDuration()
                );
            }

            out.close();
        }
    }
}