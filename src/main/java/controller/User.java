package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import implementor.UserImplementor;
import models.UserPojo;

@WebServlet("/user")
public class User extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String action = request.getParameter("action");
	    String search = request.getParameter("search");

	    List<UserPojo> userList;

	    if (search != null && !search.trim().isEmpty()) {
	        userList = new UserImplementor().searchUser(search);
	    } else {
	        userList = UserPojo.showUser();
	    }

	    request.setAttribute("userList", userList);

	    request.setAttribute("pageTitle", "User");
	    request.setAttribute("pageContent", "user.jsp");

	    request.getRequestDispatcher("/base.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	        throws ServletException, IOException {
		System.out.println("ACTION: " + req.getParameter("action"));
		System.out.println("USER ID: " + req.getParameter("userId"));
		System.out.println("ROLE ID: " + req.getParameter("roleId"));
	    String action = req.getParameter("action");

	    UserPojo userPojo = new UserPojo();

	    if ("add".equals(action)) {
	        userPojo.setName(req.getParameter("name"));
	        userPojo.setEmail(req.getParameter("email"));
	        userPojo.setPassword(req.getParameter("password"));
	        userPojo.setRoleId(Integer.parseInt(req.getParameter("roleId")));

	        userPojo.addUser(userPojo);
	    }

	    else if ("edit".equals(action)) {
	        userPojo.setUserId(Integer.parseInt(req.getParameter("userId")));
	        userPojo.setName(req.getParameter("name"));
	        userPojo.setEmail(req.getParameter("email"));
	        userPojo.setPassword(req.getParameter("password"));
	        userPojo.setRoleId(Integer.parseInt(req.getParameter("roleId")));

	        userPojo.updateUser(userPojo);
	    }

	    else if ("activate".equals(action)) {
	        userPojo.setUserId(Integer.parseInt(req.getParameter("userId")));
	        userPojo.setStatus("Active");

	        userPojo.setUserStatus(userPojo);
	    }

	    else if ("deactivate".equals(action)) {
	        userPojo.setUserId(Integer.parseInt(req.getParameter("userId")));
	        userPojo.setStatus("Inactive");

	        userPojo.setUserStatus(userPojo);
	    }

	    resp.sendRedirect("user");
	}
}
