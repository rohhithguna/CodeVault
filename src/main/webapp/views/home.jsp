<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.codeshare.model.Language"%>
<%@page import="com.codeshare.model.User"%>

<%
ArrayList<Language> languages = (ArrayList<Language>) request.getAttribute("languages");
String poster_name = (String) request.getAttribute("poster");
int cur_user = (int) request.getAttribute("cur_user");
%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Home-Noobs Codeshare</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/css/bootstrap-multiselect.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
</head>

<body>
	<jsp:include page="./header.jsp" />
	<div class="main container-fluid">

		<form id="paste_form" action="SourceCodeService" method="post"
			class="row">
			<input type="hidden" name="add" value="1" />
			<div class="col-12 col-md-6 col-lg-3 mt-2 mt-sm-0">
				<label for="title" class="form-label text-success">Title</label> <input
					type="text" class="form-control form-control-sm" name="title"
					id="title" placeholder="Enter a title" />
			</div>
			<div
				class="col-12 col-md-6 <%=cur_user == 0 ? " col-lg-3" : "col-lg-2"%> mt-2 mt-sm-0">
				<label for="language" class="form-label text-success">Language</label>
				<select class="form-control form-control-sm" id="language"
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
			<input type="hidden" name="poster" id="poster" value="<%=cur_user%>" />
			<div
				class="col-12 col-md-6 <%=cur_user == 0 ? " col-lg-4" : "col-lg-3"%> mt-2 mt-sm-0">
				<label for="poster_name" class="form-label text-success">Poster</label>
				<input type="text" class="form-control form-control-sm"
					id="poster_name" name="poster_name"
					value="<%=cur_user == 0 ? "" : poster_name%>"
					<%=cur_user > 0 ? "readonly='readonly'" : "required"%>
					placeholder="Enter your name">
			</div>
			<div
				class="col-12 col-md-6 <%=cur_user == 0 ? " col-lg-2" : "col-lg-2"%> mt-2 mt-sm-0">
				<label for="language" class="form-label text-success">Expire</label>
				<select class="form-control form-control-sm" id="expire"
					name="expire" required>
					<option value="">Select Expire</option>
					<option value="1">1 Hour</option>
					<option value="2">1 Day</option>
					<option value="3">1 Week</option>
					<option value="4">1 Month</option>
					<option value="5">Unlimited</option>
				</select>
			</div>
			<%
			if (cur_user > 0) {
				ArrayList<User> users = (ArrayList<User>) request.getAttribute("share_users");
			%>
			<div class="col-12 col-md-6 col-lg-2 mt-2 mt-sm-0">
				<label for="visibility" class="form-label text-success">Visibility</label>
				<select class="form-control form-control-sm" id="visibility"
					name="visibility" required>
					<option value="">Select Visibility</option>
					<option value="1">Public</option>
					<option value="2">Private</option>
					<option value="3">Protected</option>
				</select>
			</div>
			<div id="share_with_div" class="col-12 d-none mt-2">
				<label for="share_with" class="form-label text-success">Share
					With</label> <select class="form-control form-control-sm selectpicker"
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
			<div class="mt-2">
				<label for="source" class="form-label text-success">Source
					Code</label>
				<div id="editor" style="height: 75vh; max-height: 100vh;"></div>
			</div>
			<div class="col-12 col-md-6 col-lg-3 mt-2">
				<input type="hidden" name="csrf_token" value="<%=session.getAttribute("csrf_token")%>" />
				<button type="submit" id="submit_btn" class="btn btn-primary">Paste</button>
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

		$("#paste_form").submit(function(e) {
			e.preventDefault();
			//$("#submit_btn").prop("disabled", true);

			if ($("#visibility").val() == 3 && $("#share_with").val() == "") {
				alert("Select at least one person!");
			} else if (editor.getSession().getValue().trim() == "") {
				alert("Source code can't be empty")
			} else {
				var form_data = $(this).serialize();
				form_data += "&source=" + editor.getSession().getValue();
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
							alert("Error creating paste");
						}
					},
					error : function(e) {
					}
				});
			}
		});

		$("#login_form").submit(function(e) {
			e.preventDefault();
			// $("#submit_btn").prop("disabled", true);
			$.ajax({
				type : $(this).attr('method'),
				url : $(this).attr('action'),
				data : $(this).serialize(),
				cache : false,
				timeout : 800000,
				success : function(data) {
					$("._modal-footer").removeClass("d-none");
					let res = JSON.parse(data);
					if (res.login) {
						$(".alert_msg").removeClass("alert-danger");
						$(".alert_msg").addClass("alert-success");
						$(".alert_msg").text("Login Successful");
						setTimeout(function() {
							window.location.reload();
						}, 1000);

					} else {
						$(".alert_msg").addClass("alert-danger");
						$(".alert_msg").text("Invalid Credintials");
					}
				},
				error : function(e) {
				}
			});
		});
	</script>

</body>
</html>