package com.codeshare.service;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import org.json.simple.JSONObject;
import com.codeshare.model.User;

import com.codeshare.dao.UserDAO;

@WebServlet("/LoginService")
public class LoginService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		UserDAO user_dao = new UserDAO();
		JSONObject jo = new JSONObject();

		String username = request.getParameter("username");
		String password = request.getParameter("password");

		User loggedInUser = user_dao.checkLogin(username, password);

		if (loggedInUser == null) {
			jo.put("login", false);
		} else {
			// Establish an authenticated session for the user upon successful login
			session.setAttribute("id", loggedInUser.getId());
			session.setAttribute("name", loggedInUser.getName());
			session.setAttribute("username", loggedInUser.getUsername());
			session.setAttribute("email", loggedInUser.getEmail());
			jo.put("login", true);
		}
		out.print(jo);
	}
}
