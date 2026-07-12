package com.foro.servlet;

import com.foro.bean.Usuario;
import com.foro.dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "PremiumServlet", urlPatterns = {"/PremiumServlet"})
public class PremiumServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario u = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        String tipoCuenta = "cancelar".equals(accion) ? "Gratis" : "Premium";

        UsuarioDAO dao = new UsuarioDAO();
        int actualizado = dao.actualizarTipoCuenta(u.getIdUsuario(), tipoCuenta);
        if (actualizado > 0) {
            u.setTipoCuenta(tipoCuenta);
            request.getSession().setAttribute("usuarioLogueado", u);
            if ("Gratis".equals(tipoCuenta)) {
                response.sendRedirect("foro.jsp?plan=cancelado");
                return;
            }
            response.sendRedirect("premium.jsp?activado=1");
            return;
        }

        response.sendRedirect("premium.jsp?error=1");
    }
}
