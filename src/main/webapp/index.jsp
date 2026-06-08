<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuarioLogueado") != null) {
        response.sendRedirect("foro.jsp");
    } else {
        response.sendRedirect("login.jsp");
    }
%>