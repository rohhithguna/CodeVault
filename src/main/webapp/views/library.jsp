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
<title>Library - Noobs Codeshare</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/css/bootstrap-multiselect.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
</head>

<body>
	<jsp:include page="./header.jsp" />
	<div class="main container-fluid">
		<h3 class="text-center text-success mt-2">Code Library</h3>
		<hr>
		<table class="table table-striped table-hover">
			<thead>
				<tr>
					<th scope="col">#</th>
					<th scope="col">Title</th>
					<th scope="col">Language</th>
					<th scope="col">Link</th>
					<th scope="col">Action</th>
				</tr>
			</thead>
			<tbody>
				<%
				for (int i = 0; i < library.size(); i++) {
				%>
				<tr>
					<th scope="row"><%=i + 1%></th>
					<td><%=org.apache.commons.text.StringEscapeUtils.escapeHtml4(library.get(i).getTitle())%></td>
					<td><%=org.apache.commons.text.StringEscapeUtils.escapeHtml4(library.get(i).getLanguage())%></td>
					<td><a href="./paste?i=<%=library.get(i).getId()%>">Link</a></td>
					<td><input type="checkbox" class="custom-control-input"
						id="customSwitches<%=library.get(i).getId()%>"
						onClick="changeStatus(<%=library.get(i).getId()%>)"
						<%=library.get(i).getStatus() == 1 ? "checked" : ""%>> <label
						class="custom-control-label"
						for="customSwitches<%=library.get(i).getId()%>">Show</label></td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>

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
				//let res = JSON.parse(data);
				//console.log(res)
			},
			error : function(e) {
			}
		});
	}
</script>

</body>
</html>