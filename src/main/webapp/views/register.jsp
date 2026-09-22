<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CodeVault | Register</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
<style>
	body { background-color: #f8f9fa; }
</style>
</head>

<body class="d-flex flex-column min-vh-100">
	<jsp:include page="./header.jsp" />
	
	<main class="flex-grow-1 d-flex align-items-center py-4">
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-12 col-md-10 col-lg-7 col-xl-6">
					<div class="card shadow border-0 rounded-3">
						<div class="card-body p-4 p-md-5">
							<div class="text-center mb-4">
								<h3 class="fw-bold text-dark">Create an account</h3>
								<p class="text-muted">Join CodeVault to start saving and sharing code.</p>
							</div>

							<% if (request.getAttribute("error") != null) { %>
								<div class="alert alert-danger" role="alert">
									<%= request.getAttribute("error") %>
								</div>
							<% } %>

							<form action="register" method="POST" id="registerForm">
								<div class="row">
									<div class="col-12 col-md-6 mb-3">
										<label for="name" class="form-label fw-bold small text-secondary">Full Name</label>
										<input type="text" id="name" name="name" class="form-control form-control-lg bg-light" pattern="[A-Z a-z]+" title="Only alphabets" placeholder="e.g. John Doe" required autocomplete="name">
									</div>
									<div class="col-12 col-md-6 mb-3">
										<label for="username" class="form-label fw-bold small text-secondary">Username</label>
										<input type="text" id="username" name="username" class="form-control form-control-lg bg-light" pattern="[A-Za-z_0-9]+" title="Only alphanumeric and underscore are allowed" placeholder="e.g. johndoe" required autocomplete="username">
									</div>
								</div>
								
								<div class="mb-3">
									<label for="email" class="form-label fw-bold small text-secondary">Email Address</label>
									<input type="email" id="email" name="email" class="form-control form-control-lg bg-light" placeholder="e.g. user@example.com" required autocomplete="email">
								</div>
								
								<div class="row">
									<div class="col-12 col-md-6 mb-3">
										<label for="pwd1" class="form-label fw-bold small text-secondary">Password</label>
										<div class="input-group">
											<input type="password" id="pwd1" name="pwd1" class="form-control form-control-lg bg-light" required autocomplete="new-password">
											<button class="btn btn-light border toggle-password" data-target="#pwd1" type="button" aria-label="Toggle password visibility">
												<i class="fa-regular fa-eye text-muted"></i>
											</button>
										</div>
									</div>
									
									<div class="col-12 col-md-6 mb-4">
										<label for="pwd2" class="form-label fw-bold small text-secondary">Confirm Password</label>
										<div class="input-group">
											<input type="password" id="pwd2" name="pwd2" class="form-control form-control-lg bg-light" required autocomplete="new-password">
											<button class="btn btn-light border toggle-password" data-target="#pwd2" type="button" aria-label="Toggle password visibility">
												<i class="fa-regular fa-eye text-muted"></i>
											</button>
										</div>
										<div class="invalid-feedback fw-bold" id="pwdMatchError">Passwords do not match.</div>
									</div>
								</div>
								
								<div class="d-grid mb-4">
									<button type="submit" id="submitBtn" class="btn btn-primary btn-lg fw-bold">Create Account</button>
								</div>
								
								<div class="text-center">
									<span class="text-muted small">Already have an account?</span>
									<a href="./login" class="text-primary text-decoration-none fw-bold small ms-1">Sign in</a>
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
				var target = $($(this).data("target"));
				var icon = $(this).find("i");
				if (target.attr("type") === "password") {
					target.attr("type", "text");
					icon.removeClass("fa-eye").addClass("fa-eye-slash");
				} else {
					target.attr("type", "password");
					icon.removeClass("fa-eye-slash").addClass("fa-eye");
				}
			});

			// Basic client-side validation
			$("#registerForm").submit(function(e) {
				var p1 = $("#pwd1").val();
				var p2 = $("#pwd2").val();
				if (p1 !== p2) {
					e.preventDefault();
					$("#pwd2").addClass("is-invalid");
					$("#pwdMatchError").show();
				} else {
					$("#pwd2").removeClass("is-invalid");
					$("#pwdMatchError").hide();
					
					var btn = $("#submitBtn");
					btn.prop("disabled", true).html('<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Creating account...');
					
					// Ensure the "signup" parameter is submitted since the button is disabled
					$("<input>").attr({
						type: "hidden",
						name: "signup",
						value: "submit"
					}).appendTo("#registerForm");
				}
			});
			
			$("#pwd1, #pwd2").on('keyup', function() {
				$("#pwd2").removeClass("is-invalid");
				$("#pwdMatchError").hide();
			});
		});
	</script>
</body>
</html>
