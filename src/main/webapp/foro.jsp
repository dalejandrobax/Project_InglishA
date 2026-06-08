<%@page import="com.foro.bean.Mensaje"%>
<%@page import="java.util.List"%>
<%@page import="com.foro.dao.MensajeDAO"%>
<%@page import="com.foro.bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (u.getIdNivel() == null || u.getIdNivel() == 0) {
        response.sendRedirect("testNivel.jsp");
        return;
    }
    String nombreNivel = (u.getIdNivel() == 1) ? "A1 - Básico"
            : (u.getIdNivel() == 2) ? "A2 - Intermedio" : "B1 - Avanzado";
    MensajeDAO mDao = new MensajeDAO();
    List<Mensaje> lista = mDao.listarMensajesPorNivel(u.getIdNivel());
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Foro Nivel: <%= nombreNivel%></title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    </head>
    <body style="height: 100vh; display: flex; justify-content: center; align-items: center; background: #333;">
        <div class="foro-container">
            <div class="foro-header">
                <div>
                    <h3 style="margin:0">Foro Nivel: <%= u.getIdNivel() == 1 ? "A1" : u.getIdNivel() == 2 ? "A2" : "B1"%></h3>
                </div>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <span style="background: #eef2f7; padding: 5px 10px; border-radius: 10px; font-size: 0.8rem;">⭐ <%= u.getEstrellas()%></span>
                    <a href="LoginServlet?accion=logout" style="color: #ff6b6b; text-decoration: none; font-size: 0.8rem; font-weight: bold;">Cerrar</a>
                </div>
            </div>

            <div class="chat-area" id="chat">
                <% for (Mensaje m : lista) {
                        boolean esPropio = (m.getIdUsuario() == u.getIdUsuario());
                        String correccion = null;
                        if (esPropio) {
                            MensajeDAO cDao = new MensajeDAO();
                            correccion = cDao.obtenerCorreccion(m.getIdMensaje());
                        }
                        boolean tieneCorreccion = esPropio && correccion != null && !correccion.trim().isEmpty();
                        boolean sinErrores = esPropio && correccion != null && correccion.trim().isEmpty();
                %>
                <div class="mensaje-box <%= esPropio ? "propio" : ""%> <%= tieneCorreccion ? "con-correccion" : ""%>"
                     data-id="<%= m.getIdMensaje()%>">
                    <div class="autor"><%= m.getUsernameAutor()%></div>
                    <div class="contenido"><%= m.getContenido()%></div>

                    <% if (tieneCorreccion) {%>
                    <div class="correction-tooltip"><strong>✏️ Correction</strong><br><%= correccion%></div>
                        <% } else if (sinErrores) { %>
                    <div style="font-size:0.75rem; color:#aaa; margin-top:4px; font-style:italic;">✅ No errors</div>
                    <% } %>
                </div>
                <% } %>
            </div>

            <form action="ForoServlet" method="POST" class="footer-input">
                <input type="hidden" name="accion" value="enviar">
                <input type="text" name="txtMensaje" class="input-text" placeholder="Escribe en inglés..." required>
                <% if (u.getTipoCuenta().equals("Premium")) { %>
                <button type="button" class="btn-mic">🎤</button>
                <% }%>
                <button type="submit" class="btn-send">➤</button>
            </form>
        </div>

        <script>
            const chat = document.getElementById("chat");
            chat.scrollTop = chat.scrollHeight;

            document.addEventListener("DOMContentLoaded", function () {

                document.querySelectorAll('.mensaje-box.con-correccion').forEach(function (box) {
                    box.addEventListener('click', function (e) {
                        const tooltip = this.querySelector('.correction-tooltip');
                        if (!tooltip)
                            return;

                        document.querySelectorAll('.correction-tooltip').forEach(function (t) {
                            if (t !== tooltip)
                                t.style.display = 'none';
                        });

                        tooltip.style.display = (tooltip.style.display === 'block') ? 'none' : 'block';
                        e.stopPropagation();
                    });
                });

                document.addEventListener('click', function () {
                    document.querySelectorAll('.correction-tooltip').forEach(function (t) {
                        t.style.display = 'none';
                    });
                });

                const formForo = document.querySelector('.footer-input');
                const inputMsg = document.querySelector('.input-text');

                formForo.addEventListener('submit', function (e) {
                    e.preventDefault();
                    corregirYEnviar(inputMsg.value);
                });

                async function corregirYEnviar(texto) {
                    let correccionTexto = "";

                    try {
                        const params = new URLSearchParams();
                        params.append('text', texto);
                        params.append('language', 'en-US');

                        const resp = await fetch('https://api.languagetool.org/v2/check', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                            body: params
                        });

                        const data = await resp.json();

                        if (data.matches && data.matches.length > 0) {
                            data.matches.forEach(function (match) {
                                const mejor = match.replacements.length > 0 ? match.replacements[0].value : "—";
                                correccionTexto += "• " + match.message + " → Try: " + mejor + "\n";
                            });
                        }
                    } catch (err) {
                        console.error("LanguageTool falló:", err);
                        correccionTexto = "";
                    }

                    const old = formForo.querySelector('input[name="txtCorreccion"]');
                    if (old)
                        old.remove();

                    const hiddenCorr = document.createElement('input');
                    hiddenCorr.type = 'hidden';
                    hiddenCorr.name = 'txtCorreccion';
                    hiddenCorr.value = correccionTexto;
                    formForo.appendChild(hiddenCorr);

                    formForo.submit();
                }
            });
        </script>
    </body>
</html>