<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CodeVault | Login</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
<style>
	body { background-color: #f8f9fa; }
</style>
</head>

<body class="d-flex flex-column min-vh-100">
	<jsp:include page="./header.jsp" />
	
	<main class="flex-grow-1 d-flex align-items-center">
		<div class="container py-5">
			<div class="row justify-content-center">
				<div class="col-12 col-md-8 col-lg-5 col-xl-4">
					<div class="card shadow border-0 rounded-3">
						<div class="card-body p-4 p-md-5">
							<div class="text-center mb-4">
								<h3 class="fw-bold text-dark">Welcome back</h3>
								<p class="text-muted">Sign in to continue to your account.</p>
							</div>

							<% if (request.getAttribute("error") != null) { %>
								<div class="alert alert-danger" role="alert">
									<%= request.getAttribute("error") %>
								</div>
							<% } %>
							<div id="ajaxError" class="alert alert-danger d-none" role="alert"></div>

							<form action="LoginService" method="POST" id="loginForm">
								<div class="mb-3">
									<label for="username" class="form-label fw-bold small text-secondary">Username</label>
									<input type="text" id="username" name="username" class="form-control form-control-lg bg-light" required autocomplete="username">
								</div>
								
								<div class="mb-4">
									<label for="password" class="form-label fw-bold small text-secondary">Password</label>
									<div class="input-group">
										<input type="password" id="password" name="password" class="form-control form-control-lg bg-light" required autocomplete="current-password">
										<button class="btn btn-light border toggle-password" type="button" aria-label="Toggle password visibility">
											<i class="fa-regular fa-eye text-muted"></i>
										</button>
									</div>
								</div>
								
								<div class="d-grid mb-4">
									<button type="submit" id="submitBtn" class="btn btn-primary btn-lg fw-bold">Sign In</button>
								</div>
								
								<div class="text-center">
									<span class="text-muted small">Don't have an account?</span>
									<a href="./register" class="text-primary text-decoration-none fw-bold small ms-1">Create an account</a>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	
	<jsp:include page="./footer.jsp" />

	<script src="./assets/js/bootstrap.bundle.min.js"></script>
	<script src="./assets/js/jquery-3.6.0.min.js"></script>
	<script src="./assets/fontawsome/js/all.min.js"></script>
	
	<script>
		$(document).ready(function() {
			// Password visibility toggle
			$(".toggle-password").click(function() {
				var input = $("#password");
				var icon = $(this).find("i");
				if (input.attr("type") === "password") {
					input.attr("type", "text");
					icon.removeClass("fa-eye").addClass("fa-eye-slash");
				} else {
					input.attr("type", "password");
					icon.removeClass("fa-eye-slash").addClass("fa-eye");
				}
			});

			$("#loginForm").submit(function(e) {
				e.preventDefault();
				var btn = $("#submitBtn");
				var originalText = btn.html();
				btn.prop("disabled", true).html('<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Signing in...');
				$("#ajaxError").addClass("d-none");

				$.ajax({
					type : $(this).attr('method'),
					url : $(this).attr('action'),
					data : $(this).serialize(),
					cache : false,
					success : function(data) {
						try {
							let res = JSON.parse(data);
							if (res.login) {
								window.location.href = "home";
							} else {
								$("#ajaxError").text("Invalid username or password.").removeClass("d-none");
								btn.prop("disabled", false).html(originalText);
							}
						} catch (error) {
							$("#ajaxError").text("An error occurred. Please try again.").removeClass("d-none");
							btn.prop("disabled", false).html(originalText);
						}
					},
					error : function(e) {
						$("#ajaxError").text("Unable to sign in. Please try again.").removeClass("d-none");
						btn.prop("disabled", false).html(originalText);
					}
				});
			});
		});
	</script>
</body>
</html>
