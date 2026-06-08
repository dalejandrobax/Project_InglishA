package com.foro.servlet;

import com.foro.bean.Usuario;
import com.foro.dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/RegistroServlet"})
public class RegistroServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("txtUser");
        String pass = request.getParameter("txtPass");
        String nombres = request.getParameter("txtNombres");
        String apellidos = request.getParameter("txtApellidos");

        Usuario u = new Usuario();
        u.setUsername(user);
        u.setPassword(pass);
        u.setNombres(nombres);
        u.setApellidos(apellidos);

        UsuarioDAO dao = new UsuarioDAO();
        int res = dao.registrarUsuario(u);

        if (res > 0) {
            request.setAttribute("msgSuccess", "Registro exitoso. Ya puedes iniciar sesión.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("msg", "Error al registrar. El usuario ya podría existir.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}
