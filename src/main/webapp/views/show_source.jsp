<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.codeshare.model.Language"%>
<%@page import="com.codeshare.model.SourceCode"%>

<%
SourceCode details = (SourceCode) request.getAttribute("details");
%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Source - Noobs Codeshare</title>
<link href="./assets/css/bootstrap.min.css" rel="stylesheet">
<link href="./assets/css/bootstrap-multiselect.min.css" rel="stylesheet">
<link href="./assets/fontawsome/css/all.min.css" rel="stylesheet">
</head>

<body>
	<jsp:include page="./header.jsp" />
	<div class="container-fluid px-lg-5 py-2">
		<textarea class="form-control form-control-sm" rows="30" cols=""
			readonly="readonly"><%=org.apache.commons.text.StringEscapeUtils.escapeHtml4(details.getSource_code())%></textarea>
	</div>
	<jsp:include page="./footer.jsp" />

	<script src="./assets/js/bootstrap.bundle.min.js"></script>
	<script src="./assets/js/jquery-3.6.0.min.js"></script>
	<script src="./assets/js/bootstrap-multiselect.min.js"></script>
	<script src="./assets/fontawsome/js/all.min.js"></script>

</body>
</html>
