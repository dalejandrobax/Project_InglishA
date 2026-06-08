<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>EnglishConnect - Registro</title>
        <link rel="stylesheet" href="css/estilos.css">
    </head>
    <body>
        <div class="login-container">
            <div class="logo-title">Crea tu Cuenta</div>

            <% if (request.getAttribute("msg") != null) {%>
            <div class="error-msg"><%= request.getAttribute("msg")%></div>
            <% }%>

            <form action="RegistroServlet" method="POST">
                <div class="form-group">
                    <label>Nombres</label>
                    <input type="text" name="txtNombres" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Apellidos</label>
                    <input type="text" name="txtApellidos" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Nombre de Usuario</label>
                    <input type="text" name="txtUser" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Contraseña</label>
                    <input type="password" name="txtPass" class="form-control" required>
                </div>

                <button type="submit" class="btn-primary">Registrarme</button>
            </form>

            <div class="link-registro">
                ¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a>
            </div>
        </div>
    </body>
</html>