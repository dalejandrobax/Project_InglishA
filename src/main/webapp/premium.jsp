<%@page import="com.foro.bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    boolean esPremium = "Premium".equalsIgnoreCase(u.getTipoCuenta());
    boolean activado = "1".equals(request.getParameter("activado"));
    boolean error = "1".equals(request.getParameter("error"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Plan Premium</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css?v=6">
    </head>
    <body class="premium-page">
        <main class="premium-shell">
            <header class="premium-topbar">
                <a href="foro.jsp" class="premium-back">&larr; Volver al foro</a>
                <span>English community</span>
            </header>

            <section class="premium-hero">
                <p class="premium-kicker">Plan de pago</p>
                <h1>Activa mensajes de audio para practicar pronunciaci&oacute;n</h1>
                <p>Con Premium podr&aacute;s enviar audio en el foro y preparar la siguiente mejora: transcripci&oacute;n y correcci&oacute;n del mensaje hablado.</p>
            </section>

            <% if (activado) { %>
            <div class="premium-alert success">Tu cuenta Premium fue activada. Ya puedes volver al foro y usar el bot&oacute;n de micr&oacute;fono.</div>
            <% } else if (error) { %>
            <div class="premium-alert error">No se pudo activar el plan. Int&eacute;ntalo nuevamente.</div>
            <% } %>

            <section class="pricing-grid">
                <article class="plan-card">
                    <div class="plan-title">
                        <h2>Gratis</h2>
                        <span>Plan actual base</span>
                    </div>
                    <div class="plan-price">S/ 0 <small>/ mes</small></div>
                    <ul class="plan-benefits">
                        <li>Foro por nivel de ingl&eacute;s</li>
                        <li>Mensajes de texto</li>
                        <li>Correcci&oacute;n gramatical privada</li>
                        <li>Puntos por participaci&oacute;n</li>
                    </ul>
                    <% if (!esPremium) { %>
                    <span class="plan-current">Tu plan actual</span>
                    <% } %>
                </article>

                <article class="plan-card featured">
                    <div class="plan-badge">Recomendado</div>
                    <div class="plan-title">
                        <h2>Premium</h2>
                        <span>Para practicar speaking</span>
                    </div>
                    <div class="plan-price">S/ 9.90 <small>/ mes</small></div>
                    <ul class="plan-benefits">
                        <li>Env&iacute;o de mensajes de audio</li>
                        <li>Acceso al bot&oacute;n de micr&oacute;fono en el foro</li>
                        <li>Preparado para transcripci&oacute;n del audio</li>
                        <li>Preparado para correcci&oacute;n de pronunciaci&oacute;n</li>
                        <li>Mayor pr&aacute;ctica comunicativa</li>
                    </ul>

                    <% if (esPremium) { %>
                    <a href="foro.jsp" class="plan-button secondary">Ya eres Premium</a>
                    <% } else { %>
                    <form action="PremiumServlet" method="POST">
                        <button type="submit" class="plan-button">Activar Premium</button>
                    </form>
                    <% } %>
                </article>
            </section>
        </main>
    </body>
</html>
