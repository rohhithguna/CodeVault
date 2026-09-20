<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Register - Noobs Codeshare</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/css/bootstrap-multiselect.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
</head>

<body>
	<jsp:include page="./header.jsp" />
	<div class="reg_page mx-lg-5 mb-5">
		<h1 class="text-success text-center mt-5">
			<b>Get Registered</b>
		</h1>
		<h6 class="text-muted text-center mb-4">Sign up with your details</h6>
		<div class="mb-5 px-3 px-lg-5 py-5 mx-lg-5 shadow-lg bg-white rounded">
			<% if (request.getAttribute("error") != null) { %>
				<div class="alert alert-danger" role="alert">
					<%= request.getAttribute("error") %>
				</div>
			<% } %>
			<form class="px-lg-3" action="register" method="POST">
				<div class="form-group text-success h5">
					<label><b>Full Name</b></label> <input type="text" name="name"
						class="form-control form-control-sm" pattern="[A-Z a-z]+"
						title="Only alphabets" placeholder="Enter Your Full Name"
						required="">
				</div>
				<div class="form-group text-success h5">
					<label><b>Email Address</b></label> <input type="email"
						name="email" class="form-control form-control-sm"
						placeholder="Enter Your Email" required="">
				</div>
				<div class="form-group text-success h5">
					<label><b>Enter a Username</b></label> <input type="text"
						name="username" class="form-control form-control-sm"
						pattern="[A-Za-z_0-9]+"
						title="Only alphanumeric and underscore are allowed"
						placeholder="*Required when login" required="">
				</div>
				<div class="form-group text-success h5">
					<label><b>Enter a Password</b></label> <input type="password"
						name="pwd1" class="form-control form-control-sm"
						placeholder="*Required when login" required="">
				</div>
				<div class="form-group text-success h5">
					<label><b>Re enter the password</b></label> <input type="password"
						name="pwd2" class="form-control form-control-sm"
						placeholder="*Required when login" required="">
				</div>
				<div
					class="reg_btn mt-4 justify-content-center justify-content-lg-start">
					<button type="submit" name="signup" class="btn btn-success">
						<b>Sign Up</b>
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

</body>
</html>
