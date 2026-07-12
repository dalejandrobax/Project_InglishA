package com.foro.servlet;

import com.foro.bean.Mensaje;
import com.foro.bean.Usuario;
import com.foro.dao.MensajeDAO;
import com.foro.dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ForoServlet", urlPatterns = {"/ForoServlet"})
public class ForoServlet extends HttpServlet {

    private String obtenerCorreccionLocal(String texto) {
        if (texto == null) {
            return "";
        }

        StringBuilder correccion = new StringBuilder();
        String limpio = texto.trim();
        String lower = limpio.toLowerCase();

        if (lower.matches(".*\\bi\\s+don'?t\\s+english\\b.*")) {
            correccion.append("• After \"don't\", use a verb before the language. → Try: I don't speak English.\n");
        }

        if (lower.matches(".*\\bi\\s+like\\s+to\\s+english\\b.*")) {
            correccion.append("• Use a verb after \"to\". → Try: I like to speak English.\n");
        }

        if (lower.matches(".*\\bhola\\b.*")) {
            correccion.append("• Use English in this forum. → Try: Hello.\n");
        }

        return correccion.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Usuario u = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        String texto = request.getParameter("txtMensaje");
        String correccion = request.getParameter("txtCorreccion");
        String tipoMensaje = request.getParameter("tipoMensaje");

        if (u != null && texto != null && !texto.trim().isEmpty()) {
            boolean puedeEnviarAudio = "Premium".equalsIgnoreCase(u.getTipoCuenta());
            boolean esAudio = "Audio".equalsIgnoreCase(tipoMensaje) && puedeEnviarAudio;

            Mensaje m = new Mensaje();
            m.setIdUsuario(u.getIdUsuario());
            m.setIdNivel(u.getIdNivel());
            m.setTipoMensaje(esAudio ? "Audio" : "Texto");
            m.setContenido(texto);

            MensajeDAO dao = new MensajeDAO();
            int idMensaje = dao.registrarMensajeRetornarId(m);

            if (idMensaje > 0) {
                String corrFinal = (correccion != null && !correccion.trim().isEmpty())
                                   ? correccion.trim()
                                   : "";
                String correccionLocal = obtenerCorreccionLocal(texto);
                if (!correccionLocal.trim().isEmpty() && !corrFinal.contains(correccionLocal.trim())) {
                    corrFinal = (corrFinal + "\n" + correccionLocal).trim();
                }
                dao.registrarCorreccion(idMensaje, corrFinal);

                UsuarioDAO usuarioDAO = new UsuarioDAO();
                int puntosGanados = 1;
                if (corrFinal.trim().isEmpty()) {
                    puntosGanados += 2;
                }
                if (esAudio) {
                    puntosGanados += 2;
                }

                int estrellasActualizadas = usuarioDAO.sumarEstrellas(u.getIdUsuario(), puntosGanados);
                if (estrellasActualizadas >= 0) {
                    u.setEstrellas(estrellasActualizadas);
                    request.getSession().setAttribute("usuarioLogueado", u);
                }
            }
        }

        response.sendRedirect("foro.jsp");
    }
}
