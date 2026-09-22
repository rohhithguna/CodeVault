<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.codeshare.model.Language"%>
<%@page import="com.codeshare.model.User"%>
<%@page import="com.codeshare.model.SourceCode"%>
<%
ArrayList<SourceCode> library = (ArrayList<SourceCode>) request.getAttribute("library");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CodeVault | My Library</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/css/bootstrap-multiselect.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
<style>
.paste-card { transition: transform 0.2s, box-shadow 0.2s; }
.paste-card:hover { transform: translateY(-2px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.15)!important; }
</style>
</head>
<body class="d-flex flex-column min-vh-100">
	<jsp:include page="./header.jsp" />
	<div class="container-fluid px-lg-5 py-4 flex-grow-1">
		<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4">
			<div class="mb-3 mb-md-0">
				<h3 class="mb-1 fw-bold">My Code Library</h3>
				<p class="text-muted mb-0 small">Your saved code snippets in one place.</p>
			</div>
			<% if (library != null && !library.isEmpty()) { %>
			<div class="w-100" style="max-width: 300px;">
				<div class="input-group input-group-sm">
					<span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
					<input type="text" id="searchInput" class="form-control" placeholder="Search your pastes...">
				</div>
			</div>
			<% } %>
		</div>

		<% if (library == null || library.isEmpty()) { %>
		<div class="text-center py-5 border rounded bg-light shadow-sm">
			<h4 class="text-muted mb-2">No pastes yet</h4>
			<p class="text-muted mb-4">Create your first code snippet and it will appear here.</p>
			<a href="./home" class="btn btn-primary px-4">Create Paste</a>
		</div>
		<% } else { %>
		<div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4" id="pasteGrid">
			<%
			for (int i = 0; i < library.size(); i++) {
				SourceCode paste = library.get(i);
				String safeTitle = paste.getTitle() != null && !paste.getTitle().trim().isEmpty() ? org.apache.commons.text.StringEscapeUtils.escapeHtml4(paste.getTitle()) : "Untitled Paste";
				String safeLang = org.apache.commons.text.StringEscapeUtils.escapeHtml4(paste.getLanguage());
				String visLabel = paste.getVisibility() == 1 ? "Public" : (paste.getVisibility() == 2 ? "Private" : "Protected");
				String visClass = paste.getVisibility() == 1 ? "bg-success" : (paste.getVisibility() == 2 ? "bg-danger" : "bg-warning text-dark");
			%>
			<div class="col paste-item" data-title="<%=safeTitle.toLowerCase()%>" data-lang="<%=safeLang.toLowerCase()%>">
				<div class="card h-100 shadow-sm border-0 paste-card">
					<div class="card-body d-flex flex-column">
						<div class="d-flex justify-content-between align-items-start mb-2">
							<h5 class="card-title fw-bold text-truncate mb-0 pe-2" title="<%=safeTitle%>"><%=safeTitle%></h5>
							<span class="badge bg-secondary"><%=safeLang%></span>
						</div>
						<p class="card-text text-muted small mb-4 flex-grow-1">
							<span class="badge <%=visClass%> me-1"><%=visLabel%></span>
							<% if(paste.getCreated_at() != null) { %>Created <%=paste.getCreated_at()%><% } %>
						</p>
						<div class="d-flex justify-content-between align-items-center mt-auto">
							<div class="form-check form-switch m-0" title="Toggle visibility status">
								<input class="form-check-input cursor-pointer" style="cursor: pointer;" type="checkbox" role="switch" id="customSwitches<%=paste.getId()%>" onClick="changeStatus(<%=paste.getId()%>)" <%=paste.getStatus() == 1 ? "checked" : ""%>>
								<label class="form-check-label small text-muted ms-1" style="cursor: pointer;" for="customSwitches<%=paste.getId()%>">Active</label>
							</div>
							<div class="d-flex gap-2">
								<button class="btn btn-sm btn-outline-secondary copy-link-btn" data-paste-id="<%=paste.getId()%>" title="Copy Link"><i class="fa-solid fa-link"></i></button>
								<a href="./paste?i=<%=paste.getId()%>" class="btn btn-sm btn-primary">View Paste</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<% } %>
		</div>
		<% } %>
	</div>
	<jsp:include page="./footer.jsp" />

	<script src="./assets/js/bootstrap.bundle.min.js"></script>
	<script src="./assets/js/jquery-3.6.0.min.js"></script>
	<script src="./assets/js/bootstrap-multiselect.min.js"></script>
	<script src="./assets/fontawsome/js/all.min.js"></script>

	<script>
	function changeStatus(x) {
		$.ajax({
			type : "post",
			url : "SourceCodeService",
			data : {
				"change_status": 1,
				"id": x
			},
			cache : false,
			timeout : 800000,
			success : function(data) {
				// Status changed successfully
			},
			error : function(e) {
				alert("Error updating status.");
			}
		});
	}

	$(document).ready(function() {
		// Client-side search filter
		$('#searchInput').on('keyup', function() {
			var value = $(this).val().toLowerCase();
			$('#pasteGrid .paste-item').filter(function() {
				var title = $(this).data('title');
				var lang = $(this).data('lang');
				$(this).toggle(title.indexOf(value) > -1 || lang.indexOf(value) > -1);
			});
		});

		// Copy link
		$('.copy-link-btn').click(function() {
			var pasteId = $(this).data('paste-id');
			var currentPath = window.location.pathname;
			var basePath = currentPath.substring(0, currentPath.lastIndexOf('/'));
			var url = window.location.origin + basePath + "/paste?i=" + pasteId;
			
			var btn = $(this);
			var originalHtml = btn.html();
			navigator.clipboard.writeText(url).then(function() {
				btn.html('<i class="fa-solid fa-check text-success"></i>');
				setTimeout(function() { btn.html(originalHtml); }, 2000);
			});
		});
	});
	</script>
</body>
</html>