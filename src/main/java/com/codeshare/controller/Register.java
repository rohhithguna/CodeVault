package com.codeshare.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher("views/register.jsp");
		rd.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String username = request.getParameter("username");
		String pwd1 = request.getParameter("pwd1");
		String pwd2 = request.getParameter("pwd2");

		if (name == null || email == null || username == null || pwd1 == null || pwd2 == null || name.trim().isEmpty() || email.trim().isEmpty() || username.trim().isEmpty() || pwd1.trim().isEmpty() || pwd2.trim().isEmpty()) {
			request.setAttribute("error", "All fields are required.");
			RequestDispatcher rd = request.getRequestDispatcher("views/register.jsp");
			rd.forward(request, response);
			return;
		}
		
		if (username.length() < 3 || username.length() > 50) {
			request.setAttribute("error", "Username must be between 3 and 50 characters.");
			RequestDispatcher rd = request.getRequestDispatcher("views/register.jsp");
			rd.forward(request, response);
			return;
		}

		if (pwd1.length() < 6) {
			request.setAttribute("error", "Password must be at least 6 characters.");
			RequestDispatcher rd = request.getRequestDispatcher("views/register.jsp");
			rd.forward(request, response);
			return;
		}

		if (!pwd1.equals(pwd2)) {
			request.setAttribute("error", "Passwords do not match.");
			RequestDispatcher rd = request.getRequestDispatcher("views/register.jsp");
			rd.forward(request, response);
			return;
		}

		try {
			com.codeshare.dao.UserDAO user_dao = new com.codeshare.dao.UserDAO();
			if (user_dao.checkUserExists(username, email)) {
				request.setAttribute("error", "Username or Email already exists.");
				RequestDispatcher rd = request.getRequestDispatcher("views/register.jsp");
				rd.forward(request, response);
				return;
			}

			String createdAt = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
			boolean inserted = user_dao.insertUser(name, username, email, pwd1, createdAt);

			if (inserted) {
				response.sendRedirect("login");
			} else {
				request.setAttribute("error", "Registration failed. Please try again.");
				RequestDispatcher rd = request.getRequestDispatcher("views/register.jsp");
				rd.forward(request, response);
			}
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Internal server error.");
			RequestDispatcher rd = request.getRequestDispatcher("views/register.jsp");
			rd.forward(request, response);
		}
	}
}
