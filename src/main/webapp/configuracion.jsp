<%@page import="com.foro.bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    boolean datosOk = "ok".equals(request.getParameter("datos"));
    boolean datosError = "error".equals(request.getParameter("datos"));
    boolean passwordOk = "ok".equals(request.getParameter("password"));
    boolean passwordError = "error".equals(request.getParameter("password"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Configuraci&oacute;n</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css?v=9">
    </head>
    <body class="settings-page">
        <main class="settings-shell">
            <header class="settings-topbar">
                <a href="foro.jsp" class="settings-back">&larr; Volver al foro</a>
                <span>English community</span>
            </header>

            <section class="settings-hero">
                <p class="settings-kicker">Cuenta</p>
                <h1>Configuraci&oacute;n</h1>
                <p>Actualiza tus datos b&aacute;sicos y cambia tu contrase&ntilde;a cuando lo necesites.</p>
            </section>

            <% if (datosOk) { %>
            <div class="settings-alert success">Tus datos fueron actualizados.</div>
            <% } else if (datosError) { %>
            <div class="settings-alert error">No se pudieron actualizar tus datos.</div>
            <% } %>

            <% if (passwordOk) { %>
            <div class="settings-alert success">Tu contrase&ntilde;a fue actualizada.</div>
            <% } else if (passwordError) { %>
            <div class="settings-alert error">No se pudo cambiar la contrase&ntilde;a. Revisa la contrase&ntilde;a actual y la confirmaci&oacute;n.</div>
            <% } %>

            <section class="settings-grid">
                <form action="ConfiguracionServlet" method="POST" class="settings-card">
                    <input type="hidden" name="accion" value="datos">
                    <h2>Datos personales</h2>
                    <label>
                        Usuario
                        <input type="text" name="username" value="<%= u.getUsername()%>" required>
                    </label>
                    <label>
                        Nombres
                        <input type="text" name="nombres" value="<%= u.getNombres()%>" required>
                    </label>
                    <label>
                        Apellidos
                        <input type="text" name="apellidos" value="<%= u.getApellidos() != null ? u.getApellidos() : ""%>">
                    </label>
                    <button type="submit">Guardar cambios</button>
                </form>

                <form action="ConfiguracionServlet" method="POST" class="settings-card">
                    <input type="hidden" name="accion" value="password">
                    <h2>Contrase&ntilde;a</h2>
                    <label>
                        Contrase&ntilde;a actual
                        <input type="password" name="passwordActual" required>
                    </label>
                    <label>
                        Nueva contrase&ntilde;a
                        <input type="password" name="passwordNueva" required>
                    </label>
                    <label>
                        Confirmar nueva contrase&ntilde;a
                        <input type="password" name="passwordConfirmar" required>
                    </label>
                    <button type="submit">Cambiar contrase&ntilde;a</button>
                </form>
            </section>
        </main>
    </body>
</html>
