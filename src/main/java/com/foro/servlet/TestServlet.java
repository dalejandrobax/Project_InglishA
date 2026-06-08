package com.foro.servlet;

import com.foro.bean.Usuario;
import com.foro.dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "TestServlet", urlPatterns = {"/TestServlet"})
public class TestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();
        Usuario u = (Usuario) sesion.getAttribute("usuarioLogueado");

        if (u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int puntos = 0;
        for (int i = 1; i <= 5; i++) {
            String resp = request.getParameter("p" + i);
            if (resp != null && resp.equals("1")) {
                puntos++;
            }
        }

        int idNivel;
        if (puntos <= 2) {
            idNivel = 1; // Básico
        } else if (puntos <= 4) {
            idNivel = 2; // Intermedio
        } else {
            idNivel = 3; // Avanzado
        }

        UsuarioDAO dao = new UsuarioDAO();
        dao.actualizarNivel(u.getIdUsuario(), idNivel);

        u.setIdNivel(idNivel);
        sesion.setAttribute("usuarioLogueado", u);

        response.sendRedirect("foro.jsp");
    }
}
