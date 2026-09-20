<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.codeshare.model.Language"%>
<%@page import="com.codeshare.model.User"%>
<%@page import="com.codeshare.model.SourceCode"%>

<%
ArrayList<SourceCode> source_list = (ArrayList<SourceCode>) request.getAttribute("source_list");
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
		<h3 class="text-center text-success mt-2">Shared With Me</h3>
		<hr>
		<table class="table table-striped table-hover">
			<thead>
				<tr>
					<th scope="col">#</th>
					<th scope="col">Title</th>
					<th scope="col">Language</th>
					<th scope="col">Link</th>
					<th scope="col">Owner</th>
				</tr>
			</thead>
			<tbody>
				<%
				for (int i = 0; i < source_list.size(); i++) {
				%>
				<tr>
					<th scope="row"><%=i + 1%></th>
					<td><%=org.apache.commons.text.StringEscapeUtils.escapeHtml4(source_list.get(i).getTitle())%></td>
					<td><%=org.apache.commons.text.StringEscapeUtils.escapeHtml4(source_list.get(i).getLanguage())%></td>
					<td><a href="./paste?i=<%=source_list.get(i).getId()%>">Link</a></td>
					<td><%=org.apache.commons.text.StringEscapeUtils.escapeHtml4(source_list.get(i).getCreated_by_name())%></td>
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
			} else {
				console.log($(this).serialize());
				$.ajax({
					type : $(this).attr('method'),
					url : $(this).attr('action'),
					data : $(this).serialize(),
					cache : false,
					timeout : 800000,
					success : function(data) {

					},
					error : function(e) {
					}
				});
			}
		});
	</script>

</body>
</html>