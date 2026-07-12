package com.foro.servlet;

import com.foro.bean.Usuario;
import com.foro.dao.MensajeDAO;
import com.foro.dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RecompensaServlet", urlPatterns = {"/RecompensaServlet"})
public class RecompensaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        Usuario u = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (u == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"ok\":false}");
            return;
        }

        String accion = request.getParameter("accion");
        int idMensaje = 0;
        try {
            idMensaje = Integer.parseInt(request.getParameter("idMensaje"));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"ok\":false}");
            return;
        }

        if (!"verCorreccionAjena".equals(accion)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"ok\":false}");
            return;
        }

        MensajeDAO mensajeDAO = new MensajeDAO();
        int autorMensaje = mensajeDAO.obtenerAutorMensaje(idMensaje);
        if (autorMensaje == 0 || autorMensaje == u.getIdUsuario()) {
            response.getWriter().write("{\"ok\":false}");
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        int estrellasActualizadas = usuarioDAO.sumarEstrellas(u.getIdUsuario(), 1);
        if (estrellasActualizadas >= 0) {
            u.setEstrellas(estrellasActualizadas);
            request.getSession().setAttribute("usuarioLogueado", u);
            response.getWriter().write("{\"ok\":true,\"estrellas\":" + estrellasActualizadas + "}");
            return;
        }

        response.getWriter().write("{\"ok\":false}");
    }
}
