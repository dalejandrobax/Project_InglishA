package com.foro.servlet;

import com.foro.bean.Mensaje;
import com.foro.bean.Usuario;
import com.foro.dao.MensajeDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ForoServlet", urlPatterns = {"/ForoServlet"})
public class ForoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Usuario u = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        String texto = request.getParameter("txtMensaje");
        String correccion = request.getParameter("txtCorreccion");

        if (u != null && texto != null && !texto.trim().isEmpty()) {
            Mensaje m = new Mensaje();
            m.setIdUsuario(u.getIdUsuario());
            m.setIdNivel(u.getIdNivel());
            m.setTipoMensaje("Texto");
            m.setContenido(texto);

            MensajeDAO dao = new MensajeDAO();
            int idMensaje = dao.registrarMensajeRetornarId(m);

            if (idMensaje > 0) {
                String corrFinal = (correccion != null && !correccion.trim().isEmpty())
                                   ? correccion.trim()
                                   : "";
                dao.registrarCorreccion(idMensaje, corrFinal);
            }
        }

        response.sendRedirect("foro.jsp");
    }
}