<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>EnglishConnect - Login</title>
        <link rel="stylesheet" href="css/estilos.css">
    </head>
    <body>
        <div class="login-container">
            <div class="logo-title">EnglishConnect</div>

            <% if (request.getAttribute("msg") != null) {%>
            <div class="error-msg"><%= request.getAttribute("msg")%></div>
            <% }%>

            <form action="LoginServlet" method="POST">
                <input type="hidden" name="accion" value="login">

                <div class="form-group">
                    <label>Usuario</label>
                    <input type="text" name="txtUser" class="form-control" placeholder="Ej: diego" required>
                </div>

                <div class="form-group">
                    <label>Contraseña</label>
                    <input type="password" name="txtPass" class="form-control" placeholder="********" required>
                </div>

                <button type="submit" class="btn-primary">Ingresar</button>
            </form>

            <div class="link-registro">
                ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
            </div>
        </div>
    </body>
</html>