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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion.equals("login")) {
            this.validar(request, response);
        } else if (accion.equals("logout")) {
            this.cerrarSesion(request, response);
        }
    }

    private void validar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("txtUser");
        String pass = request.getParameter("txtPass");

        UsuarioDAO dao = new UsuarioDAO();
        Usuario u = dao.validarLogin(user, pass);

        if (u != null) {
            HttpSession sesion = request.getSession();
            sesion.setAttribute("usuarioLogueado", u);

            if (u.getIdNivel() == null && u.getIdRol() == 1) {
                response.sendRedirect("testNivel.jsp");
            } else {
                response.sendRedirect("foro.jsp");
            }
        } else {
            request.setAttribute("msg", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getSession().invalidate();
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
