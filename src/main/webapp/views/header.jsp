
<%
HttpSession cur_session = request.getSession();
%>
<nav
	class="navbar sticky-top navbar-expand-lg navbar-dark bg-dark px-3 mb-3">

	<a class="navbar-brand mr-auto font-weight-bold" href="./home">
		CodeVault
	</a> <a href="javascript:void(0)"
		class="navbar-brand mt-1 text-light text-lg d-block d-lg-none mr-1"
		data-bs-toggle="collapse" data-bs-target="#nbcollapse"> <span
		class="text-success h4 font-weight-bold"><i
			class="fa-solid fa-sliders"></i></span>
	</a>

	<div class="collapse navbar-collapse" id="nbcollapse">
		<ul class="navbar-nav mx-auto">
			<li class="nav-item ni px-2 px-lg-0 mx-lg-3"><a
				class="nav-link text-white" href="./home"><i
					class="fa-regular fa-paste"></i> New Paste</a></li>
			<%
			if (cur_session.getAttribute("username") != null) {
			%>
			<li class="nav-item ni px-2 px-lg-0 mx-lg-3"><a
				class="nav-link text-white" href="./library"><i
					class="fa-regular fa-bookmark"></i></i> My Code Library</a></li>
			<li class="nav-item ni px-2 px-lg-0 mx-lg-3"><a
				class="nav-link text-white" href="./shared"><i
					class="fa-solid fa-people-group"></i> Shared With Me</a></li>
			<%
			}
			%>
		</ul>
		<ul class="navbar-nav">
			<%
			if (cur_session.getAttribute("username") != null) {
			%>
			<li class="nav-item"><a class="nav-link text-white dropdown-toggle"
				href="#" id="navbarDropdownMenuLink" role="button"
				data-bs-toggle="dropdown" aria-expanded="false"><i
					class="fa-regular fa-user"></i> <%=cur_session.getAttribute("username")%>
			</a>
				<ul class="dropdown-menu dropdown-menu-end"
					aria-labelledby="navbarDropdownMenuLink">
					<li><a class="dropdown-item" href="./library"><i class="fa-regular fa-bookmark"></i> My Code Library</a></li>
					<li><a class="dropdown-item" href="./shared"><i class="fa-solid fa-people-group"></i> Shared With Me</a></li>
					<li><hr class="dropdown-divider"></li>
					<li><a class="dropdown-item" href="./logout"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a></li>
				</ul></li>
			<%
			} else {
			%>
			<li class="nav-item mx-lg-2"><a class="btn btn-outline-light btn-sm mt-1" href="./login">Login</a></li>
			<li class="nav-item"><a class="btn btn-primary btn-sm mt-1" href="./register">Register</a></li>
			<%
			}
			%>
		</ul>
	</div>
</nav>
