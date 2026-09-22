<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.codeshare.model.Language"%>
<%@page import="com.codeshare.model.SourceCode"%>

<%
SourceCode details = (SourceCode) request.getAttribute("details");
String poster = details.getCreated_by() == 0 ? details.getCreated_by_alt() : details.getCreated_by_name();
String visibilityLabel = "";
if (details.getVisibility() == 1) visibilityLabel = "Public";
else if (details.getVisibility() == 2) visibilityLabel = "Private";
else if (details.getVisibility() == 3) visibilityLabel = "Protected";

String safeTitle = details.getTitle() != null && !details.getTitle().trim().isEmpty() ? org.apache.commons.text.StringEscapeUtils.escapeHtml4(details.getTitle()) : "Untitled Paste";
String safePoster = poster != null && !poster.trim().isEmpty() ? org.apache.commons.text.StringEscapeUtils.escapeHtml4(poster) : "Guest";
%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>CodeVault | View Paste</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/css/bootstrap-multiselect.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
</head>

<body class="d-flex flex-column min-vh-100">
	<jsp:include page="./header.jsp" />
	<div class="container-fluid px-lg-5 py-4 flex-grow-1">
		<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4">
			<div class="mb-3 mb-md-0">
				<h3 class="mb-1 fw-bold"><%=safeTitle%></h3>
				<p class="text-muted mb-0 small">
					<strong><%=details.getLanguage()%></strong> &middot; 
					Created by <strong><%=safePoster%></strong> &middot; 
					<%=details.getCreated_at()%> &middot; 
					<span class="badge bg-secondary"><%=visibilityLabel%></span>
				</p>
			</div>
			<div>
				<a href="javascript:history.back()" class="btn btn-outline-secondary btn-sm px-3"><i class="fa-solid fa-arrow-left"></i> Back</a>
			</div>
		</div>

		<div class="card shadow-sm border-0 mb-4">
			<div class="card-header bg-light d-flex flex-column flex-sm-row justify-content-between align-items-sm-center py-3">
				<span class="text-muted fw-bold small mb-2 mb-sm-0">Source Code</span>
				<div class="d-flex gap-2">
					<button class="btn btn-sm btn-primary" onclick="copyCode()" id="copyCodeBtn"><i class="fa-regular fa-copy"></i> Copy Code</button>
					<button class="btn btn-sm btn-secondary" onclick="copyLink()" id="copyLinkBtn"><i class="fa-solid fa-link"></i> Copy Link</button>
				</div>
			</div>
			<div class="card-body p-0">
				<div id="code_data" class="d-none"><%=org.apache.commons.text.StringEscapeUtils.escapeHtml4(details.getSource_code())%></div>
				<div id="editor" style="height: 65vh; min-height: 400px; width: 100%; border-bottom-left-radius: 4px; border-bottom-right-radius: 4px;"></div>
			</div>
		</div>
	</div>
	<jsp:include page="./footer.jsp" />

	<script src="./assets/js/bootstrap.bundle.min.js"></script>
	<script src="./assets/js/jquery-3.6.0.min.js"></script>
	<script src="./assets/ace/ace.js"></script>
	<script src="./assets/fontawsome/js/all.min.js"></script>

	<script>
		var editor = ace.edit("editor");
		editor.setTheme("ace/theme/monokai");
		
		var lang = "<%=details.getLanguage().toLowerCase()%>".replace('\n','').replace('\t','');
		if (lang === 'c' || lang === 'c++') {
			editor.setOptions({ mode: 'ace/mode/c_cpp' });
		} else {
			editor.setOptions({ mode: 'ace/mode/' + lang });
		}
		
		editor.setOptions({
			readOnly: true,
			highlightActiveLine: false,
			highlightGutterLine: false,
			fontSize: 14,
			showPrintMargin: false
		});
		
		var codeContent = $("<textarea/>").html($("#code_data").html()).text();
		editor.setValue(codeContent, -1);
		
		function copyCode() {
			navigator.clipboard.writeText(codeContent).then(function() {
				var btn = document.getElementById("copyCodeBtn");
				var originalHTML = btn.innerHTML;
				btn.innerHTML = '<i class="fa-solid fa-check"></i> Copied!';
				btn.classList.add("btn-success");
				btn.classList.remove("btn-primary");
				setTimeout(function() {
					btn.innerHTML = originalHTML;
					btn.classList.remove("btn-success");
					btn.classList.add("btn-primary");
				}, 2000);
			});
		}
		
		function copyLink() {
			var url = window.location.href;
			navigator.clipboard.writeText(url).then(function() {
				var btn = document.getElementById("copyLinkBtn");
				var originalHTML = btn.innerHTML;
				btn.innerHTML = '<i class="fa-solid fa-check"></i> Link copied!';
				btn.classList.add("btn-success");
				btn.classList.remove("btn-secondary");
				setTimeout(function() {
					btn.innerHTML = originalHTML;
					btn.classList.remove("btn-success");
					btn.classList.add("btn-secondary");
				}, 2000);
			});
		}
	</script>

</body>
</html>
