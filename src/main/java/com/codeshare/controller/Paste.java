package com.codeshare.controller;

import java.io.IOException;

import com.codeshare.dao.SourceCodeDAO;
import com.codeshare.model.SourceCode;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/paste")
public class Paste extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		SourceCodeDAO source_code_dao = new SourceCodeDAO();
		try {
			if (request.getParameterMap().containsKey("i")) {
				int id = Integer.parseInt(request.getParameter("i"));
				SourceCode source_code_details = source_code_dao.getDetailsByID(id);

				if (source_code_details == null) {
					response.sendRedirect("home");
					return;
				}

				int visibility = source_code_details.getVisibility();
				boolean isAuthorized = false;

				if (visibility == 1) {
					isAuthorized = true; // Public
				} else {
					jakarta.servlet.http.HttpSession session = request.getSession();
					Integer currentUserId = (Integer) session.getAttribute("id");
					
					if (currentUserId != null) {
						// Allow access if the current user is the owner of the paste
						if (source_code_details.getCreated_by() == currentUserId) {
							isAuthorized = true; // Owner
						} else if (visibility == 3) {
							// Protected - check if the paste has been explicitly shared with the current user
							if (source_code_details.getShared_persons() != null) {
								for (int sharedUserId : source_code_details.getShared_persons()) {
									if (sharedUserId == currentUserId) {
										isAuthorized = true;
										break;
									}
								}
							}
						}
					}
				}

				// If the user does not meet any visibility criteria, deny access
				if (!isAuthorized) {
					response.sendRedirect("home");
					return;
				}

				request.setAttribute("details", source_code_details);
				RequestDispatcher rd = request.getRequestDispatcher("views/show_source.jsp");
				rd.forward(request, response);
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ServletException e) {
			e.printStackTrace();
		}
	}

}
