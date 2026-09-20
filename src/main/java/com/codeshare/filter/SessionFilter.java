package com.codeshare.filter;

import java.io.IOException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter({ "/library", "/shared" })
public class SessionFilter extends HttpFilter {

	private static final long serialVersionUID = 1L;

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest _request = (HttpServletRequest) request;
		HttpServletResponse _response = (HttpServletResponse) response;
		HttpSession session = _request.getSession();

		if (session.getAttribute("id") != null) { // user logged in, access
			if (session.getAttribute("csrf_token") == null) {
				session.setAttribute("csrf_token", java.util.UUID.randomUUID().toString());
			}
			chain.doFilter(_request, _response);
		} else {
			_response.sendRedirect("login");
		}
	}
}
