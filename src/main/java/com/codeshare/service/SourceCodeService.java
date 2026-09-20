package com.codeshare.service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import com.codeshare.DateProcessing;
import com.codeshare.dao.SourceCodeDAO;

@WebServlet("/SourceCodeService")
public class SourceCodeService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		SourceCodeDAO source_code_dao = new SourceCodeDAO();
		if (request.getParameterMap().containsKey("add")) {
			String sessionToken = (String) session.getAttribute("csrf_token");
			String requestToken = request.getParameter("csrf_token");
			if (sessionToken == null || !sessionToken.equals(requestToken)) {
				// CSRF Token invalid
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF Token");
				return;
			}
			

			String title = request.getParameter("title");
			int language = Integer.parseInt(request.getParameter("language"));
			
			int poster = 0;
			String poster_name = "";
			if (session.getAttribute("id") != null) {
				poster = (Integer) session.getAttribute("id");
				poster_name = (String) session.getAttribute("name");
			}
			String source = request.getParameter("source");

			int expire = Integer.parseInt(request.getParameter("expire"));
			DateProcessing dp = new DateProcessing();
			java.sql.Timestamp curTimestamp = dp.getCurTimestamp();
			String expTimestamp = null;
			int visibility = 1;
			String[] share_with = null;

			if (expire == 1) {
				expTimestamp = dp.getExpTimestamp(1).toString();
			} else if (expire == 2) {
				expTimestamp = dp.getExpTimestamp(24).toString();
			} else if (expire == 3) {
				expTimestamp = dp.getExpTimestamp(7 * 24).toString();
			} else if (expire == 4) {
				expTimestamp = dp.getExpTimestamp(30 * 24).toString();
			}

			if (session.getAttribute("id") != null) {
				share_with = request.getParameterValues("share_with");
				visibility = Integer.parseInt(request.getParameter("visibility"));
			}
			int id = source_code_dao.addSourceCode(title, language, visibility, source, poster, poster_name,
					curTimestamp.toString(), expTimestamp, 1, share_with);
			
			response.setContentType("application/json");
			java.io.PrintWriter out = response.getWriter();
			out.print("{\"success\": " + (id != -1) + ", \"id\": " + id + "}");
		}

		if (request.getParameterMap().containsKey("change_status")) {

			int id = Integer.parseInt(request.getParameter("id"));
			source_code_dao.changeStatus(id);
		}
	}
}