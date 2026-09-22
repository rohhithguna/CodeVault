<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.codeshare.model.Language"%>
<%@page import="com.codeshare.model.User"%>

<%
ArrayList<Language> languages = (ArrayList<Language>) request.getAttribute("languages");
String poster_name = (String) request.getAttribute("poster");
int cur_user = (int) request.getAttribute("cur_user");

if (session.getAttribute("csrf_token") == null) {
	session.setAttribute("csrf_token", java.util.UUID.randomUUID().toString());
}
%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>CodeVault | Create Paste</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/css/bootstrap-multiselect.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
</head>

<body class="d-flex flex-column min-vh-100">
	<jsp:include page="./header.jsp" />
	<div class="main container-fluid px-lg-5 flex-grow-1 py-4">
		<div class="mb-4">
			<h2>Create a New Paste</h2>
			<p class="text-muted">Save and share your code with a unique link.</p>
		</div>

		<form id="paste_form" action="SourceCodeService" method="post"
			class="row g-3">
			<input type="hidden" name="add" value="1" />
			<input type="hidden" name="poster" id="poster" value="<%=cur_user%>" />

			<div class="col-12 col-md-6 col-lg-3">
				<label for="title" class="form-label fw-bold">Title</label>
				<input type="text" class="form-control" name="title"
					id="title" placeholder="e.g. Binary Search Implementation" required />
			</div>
			
			<div class="col-12 col-md-6 col-lg-3">
				<label for="language" class="form-label fw-bold">Programming Language</label>
				<select class="form-control" id="language"
					name="language" onchange="changeLanguage()" required>
					<option value="">Select Language</option>
					<%
					for (Language lang : languages) {
					%>
					<option value="<%=lang.getId()%>"
						<%=lang.getId() == 2 ? "selected" : ""%>>
						<%=lang.getName()%>
					</option>
					<%
					}
					%>
				</select>
			</div>

			<div class="col-12 col-md-6 col-lg-3">
				<label for="poster_name" class="form-label fw-bold">Owner</label>
				<input type="text" class="form-control"
					id="poster_name" name="poster_name"
					value="<%=cur_user == 0 ? "" : poster_name%>"
					<%=cur_user > 0 ? "readonly='readonly'" : "required"%>
					placeholder="Enter your name">
			</div>

			<div class="col-12 col-md-6 col-lg-3">
				<label for="expire" class="form-label fw-bold">Expiration</label>
				<select class="form-control" id="expire"
					name="expire" required>
					<option value="5">Never</option>
					<option value="1">1 Hour</option>
					<option value="2">1 Day</option>
					<option value="3">1 Week</option>
					<option value="4">1 Month</option>
				</select>
			</div>

			<%
			if (cur_user > 0) {
				ArrayList<User> users = (ArrayList<User>) request.getAttribute("share_users");
			%>
			<div class="col-12 col-md-6 col-lg-4">
				<label for="visibility" class="form-label fw-bold">Who can access this paste?</label>
				<select class="form-control" id="visibility"
					name="visibility" required>
					<option value="">Select Visibility</option>
					<option value="1">Public - Anyone with the link can view it.</option>
					<option value="2">Private - Only you can view it.</option>
					<option value="3">Protected - Only the users you allow can access it.</option>
				</select>
			</div>
			<div id="share_with_div" class="col-12 col-md-6 col-lg-4 d-none">
				<label for="share_with" class="form-label fw-bold">Share With</label>
				<select class="form-control selectpicker"
					id="share_with" name="share_with" multiple>
					<%
					for (User user : users) {
					%>
					<option value="<%=user.getId()%>">
						<%=user.getUsername()%>
					</option>
					<%
					}
					%>
				</select>
			</div>
			<%
			}
			%>

			<div class="col-12 mt-4">
				<h5 class="fw-bold mb-1">Your Code</h5>
				<p class="text-muted small mb-2">Paste or type your source code below.</p>
				<div id="editor" class="border rounded" style="height: 60vh; min-height: 400px;"></div>
			</div>
			
			<div class="col-12 mt-3">
				<div id="formAlert" class="alert alert-danger d-none" role="alert"></div>
				<input type="hidden" name="csrf_token" value="<%=session.getAttribute("csrf_token")%>" />
				<button type="submit" id="submit_btn" class="btn btn-primary btn-lg px-4">Create Paste</button>
			</div>
		</form>
	</div>
	<jsp:include page="./footer.jsp" />

	<script src="./assets/js/bootstrap.bundle.min.js"></script>
	<script src="./assets/js/jquery-3.6.0.min.js"></script>
	<script src="./assets/js/bootstrap-multiselect.min.js"></script>
	<script src="./assets/fontawsome/js/all.min.js"></script>
	<script src="./assets/ace/ace.js"></script>
	<script src="./assets/ace/ext-language_tools.js"></script>
	<script src="./assets/js/editor.js"></script>

	<script>
		$("#visibility").change(function() {
			if ($("#visibility").val() == 3) { // protected
				$("#share_with_div").removeClass("d-none");
			} else {
				$("#share_with_div").removeClass("d-block");
				$("#share_with_div").addClass("d-none");
			}
		});

		function showFormError(message) {
			$("#formAlert").text(message).removeClass("d-none");
			$("#submit_btn").prop("disabled", false).text("Create Paste");
		}

		$("#paste_form").submit(function(e) {
			e.preventDefault();
			$("#submit_btn").prop("disabled", true).text("Creating paste...");
			$("#formAlert").addClass("d-none");

			if ($("#title").val().trim() == "") {
				showFormError("Please enter a title.");
			} else if ($("#visibility").val() == 3 && $("#share_with").val() == "") {
				showFormError("Please select at least one person to share with.");
			} else if (editor.getSession().getValue().trim() == "") {
				showFormError("Please enter some code.");
			} else {
				var form_data = $(this).serialize();
				form_data += "&source=" + encodeURIComponent(editor.getSession().getValue());
				console.log(form_data);
				$.ajax({
					type : $(this).attr('method'),
					url : $(this).attr('action'),
					data : form_data,
					cache : false,
					timeout : 800000,
					success : function(data) {
						if (data.success && data.id !== -1) {
							window.location.href = "paste?i=" + data.id;
						} else {
							showFormError("Unable to create the paste. Please try again.");
						}
					},
					error : function(e) {
						showFormError("Unable to create the paste. Please try again.");
					}
				});
			}
		});

	</script>

</body>
</html>