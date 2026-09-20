package com.codeshare.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.codeshare.dao.SourceCodeDAO;
import com.codeshare.model.SourceCode;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/library")
public class Library extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {


		HttpSession session = request.getSession();
		SourceCodeDAO source_code_dao = new SourceCodeDAO();

		int cur_user_id = (int) session.getAttribute("id");
		ArrayList<SourceCode> library = source_code_dao.getLibraryByUser(cur_user_id);


		request.setAttribute("library", library);

		RequestDispatcher rd = request.getRequestDispatcher("views/library.jsp");
		rd.forward(request, response);
	}

}
