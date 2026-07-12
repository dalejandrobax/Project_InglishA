package com.foro.servlet;

import com.foro.bean.Usuario;
import com.foro.dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ConfiguracionServlet", urlPatterns = {"/ConfiguracionServlet"})
public class ConfiguracionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Usuario u = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        UsuarioDAO dao = new UsuarioDAO();

        if ("datos".equals(accion)) {
            String username = request.getParameter("username");
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");

            if (username != null && nombres != null && apellidos != null
                    && !username.trim().isEmpty() && !nombres.trim().isEmpty()) {
                int actualizado = dao.actualizarDatosCuenta(
                        u.getIdUsuario(), username.trim(), nombres.trim(), apellidos.trim());

                if (actualizado > 0) {
                    u.setUsername(username.trim());
                    u.setNombres(nombres.trim());
                    u.setApellidos(apellidos.trim());
                    request.getSession().setAttribute("usuarioLogueado", u);
                    response.sendRedirect("configuracion.jsp?datos=ok");
                    return;
                }
            }
            response.sendRedirect("configuracion.jsp?datos=error");
            return;
        }

        if ("password".equals(accion)) {
            String actual = request.getParameter("passwordActual");
            String nueva = request.getParameter("passwordNueva");
            String confirmar = request.getParameter("passwordConfirmar");

            if (actual != null && nueva != null && confirmar != null
                    && !nueva.trim().isEmpty() && nueva.equals(confirmar)) {
                int actualizado = dao.actualizarPassword(u.getIdUsuario(), actual, nueva);
                if (actualizado > 0) {
                    response.sendRedirect("configuracion.jsp?password=ok");
                    return;
                }
            }
            response.sendRedirect("configuracion.jsp?password=error");
            return;
        }

        response.sendRedirect("configuracion.jsp");
    }
}
