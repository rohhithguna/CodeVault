<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Login - Noobs Codeshare</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/css/bootstrap-multiselect.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
</head>

<body>
	<jsp:include page="./header.jsp" />
	<div class="login_page mx-lg-5 mb-5">
		<h1 class="text-success text-center mt-5">
			<b>Login</b>
		</h1>
		<h6 class="text-muted text-center mb-4">Welcome back!</h6>
		<div class="mb-5 px-3 px-lg-5 py-5 mx-lg-5 shadow-lg bg-white rounded">
			<% if (request.getAttribute("error") != null) { %>
				<div class="alert alert-danger" role="alert">
					<%= request.getAttribute("error") %>
				</div>
			<% } %>
			<form class="px-lg-3" action="LoginService" method="POST">
				<div class="form-group text-success h5">
					<label><b>Username</b></label> <input type="text"
						name="username" class="form-control form-control-sm"
						required="">
				</div>
				<div class="form-group text-success h5">
					<label><b>Password</b></label> <input type="password"
						name="password" class="form-control form-control-sm"
						required="">
				</div>
				<div
					class="login_btn mt-4 justify-content-center justify-content-lg-start">
					<button type="submit" class="btn btn-success">
						<b>Login</b>
					</button>
				</div>
			</form>
		</div>
	</div>
	<jsp:include page="./footer.jsp" />

	<script src="./assets/js/bootstrap.bundle.min.js"></script>
	<script src="./assets/js/jquery-3.6.0.min.js"></script>
	<script src="./assets/js/bootstrap-multiselect.min.js"></script>
	<script src="./assets/fontawsome/js/all.min.js"></script>
	<script>
		$("form").submit(function(e) {
			e.preventDefault();
			$.ajax({
				type : $(this).attr('method'),
				url : $(this).attr('action'),
				data : $(this).serialize(),
				cache : false,
				success : function(data) {
					let res = JSON.parse(data);
					if (res.login) {
						window.location.href = "home";
					} else {
						alert("Invalid Credentials");
					}
				},
				error : function(e) {
				}
			});
		});
	</script>
</body>
</html>
