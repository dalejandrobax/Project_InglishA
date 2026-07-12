<%@page import="com.foro.bean.Mensaje"%>
<%@page import="java.util.List"%>
<%@page import="com.foro.dao.MensajeDAO"%>
<%@page import="com.foro.bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
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
%>
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
    String codigoNivel = (u.getIdNivel() == 1) ? "A1"
            : (u.getIdNivel() == 2) ? "A2" : "B1";
    String nombreNivel = (u.getIdNivel() == 1) ? "Básico"
            : (u.getIdNivel() == 2) ? "Intermedio" : "Avanzado";
    String etiquetaNivel = nombreNivel + " (" + codigoNivel + ")";
    MensajeDAO mDao = new MensajeDAO();
    List<Mensaje> lista = mDao.listarMensajesPorNivel(u.getIdNivel());
    int totalMensajes = mDao.contarMensajesPorUsuario(u.getIdUsuario());
    int totalCorrecciones = mDao.contarCorreccionesPorUsuario(u.getIdUsuario());
    int totalAudios = mDao.contarAudiosPorUsuario(u.getIdUsuario());
    int puntos = u.getEstrellas();
    String rango = puntos >= 50 ? "Experto"
            : puntos >= 25 ? "Constante"
            : puntos >= 10 ? "Practicante" : "Principiante";
    int siguienteMeta = puntos >= 50 ? 50
            : puntos >= 25 ? 50
            : puntos >= 10 ? 25 : 10;
    int metaAnterior = puntos >= 50 ? 50
            : puntos >= 25 ? 25
            : puntos >= 10 ? 10 : 0;
    int progresoRango = siguienteMeta == metaAnterior ? 100
            : Math.min(100, Math.max(0, ((puntos - metaAnterior) * 100) / (siguienteMeta - metaAnterior)));
    int puntosFaltantes = Math.max(0, siguienteMeta - puntos);
    boolean insigniaPrimerMensaje = totalMensajes >= 1;
    boolean insigniaDiezMensajes = totalMensajes >= 10;
    boolean insigniaPrimeraCorreccion = totalCorrecciones >= 1;
    boolean insigniaCincoAudios = totalAudios >= 5;
    boolean insigniaPremium = "Premium".equalsIgnoreCase(u.getTipoCuenta());
    boolean insigniaConstante = puntos >= 25;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Foro <%= etiquetaNivel%></title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css?v=15">
    </head>
    <body class="foro-page">
        <aside class="foro-sidebar" id="foroSidebar" aria-label="Menu principal">
            <button type="button" class="sidebar-toggle" id="sidebarToggle" aria-label="Abrir menu" aria-expanded="false">
                <span></span>
                <span></span>
                <span></span>
            </button>
            <button type="button" class="sidebar-item active" id="progressToggle" aria-expanded="false" aria-controls="progressPanel">
                <span class="sidebar-icon" aria-hidden="true">&#9733;</span>
                <span class="sidebar-text">Mi Cuenta</span>
            </button>
            <button type="button" class="sidebar-item" id="badgesToggle" aria-expanded="false" aria-controls="badgesPanel">
                <span class="sidebar-icon" aria-hidden="true">&#127942;</span>
                <span class="sidebar-text">Mis Insignias</span>
            </button>
            <a href="configuracion.jsp" class="sidebar-item sidebar-link">
                <span class="sidebar-icon" aria-hidden="true">&#9881;</span>
                <span class="sidebar-text">Configuraci&oacute;n</span>
            </a>
            <a href="premium.jsp" class="sidebar-item sidebar-link sidebar-premium">
                <span class="sidebar-icon" aria-hidden="true">&#127908;</span>
                <span class="sidebar-text">Plan Premium</span>
            </a>
        </aside>

        <section class="progress-panel" id="progressPanel" aria-label="Cuenta del usuario">
            <div class="progress-header">
                <span>Mi Cuenta</span>
                <button type="button" class="progress-close" id="progressClose" aria-label="Cerrar cuenta">&times;</button>
            </div>
            <div class="progress-user">
                <strong><%= u.getUsername()%></strong>
                <span><%= etiquetaNivel%></span>
            </div>
            <div class="rank-card">
                <span>Rango actual</span>
                <strong><%= rango%></strong>
                <% if (puntos >= 50) { %>
                <small>Rango m&aacute;ximo alcanzado</small>
                <% } else { %>
                <small><%= puntosFaltantes%> puntos para el siguiente rango</small>
                <% } %>
                <div class="rank-progress" aria-label="Progreso de rango">
                    <div style="width: <%= progresoRango%>%"></div>
                </div>
            </div>
            <div class="progress-grid">
                <div class="progress-stat">
                    <span>Nivel actual</span>
                    <strong><%= nombreNivel%></strong>
                </div>
                <div class="progress-stat">
                    <span>Puntos</span>
                    <strong><%= u.getEstrellas()%></strong>
                </div>
                <div class="progress-stat">
                    <span>Mensajes</span>
                    <strong><%= totalMensajes%></strong>
                </div>
                <div class="progress-stat">
                    <span>Correcciones</span>
                    <strong><%= totalCorrecciones%></strong>
                </div>
            </div>
            <div class="account-tools">
                <span>Modo social</span>
                <button type="button" class="peer-corrections-toggle" id="peerCorrectionsToggle" aria-pressed="false">
                    Ver correcciones ajenas
                </button>
            </div>
            <div class="account-plan">
                <span>Suscripci&oacute;n</span>
                <strong><%= u.getTipoCuenta()%></strong>
                <% if ("Premium".equalsIgnoreCase(u.getTipoCuenta())) { %>
                <form action="PremiumServlet" method="POST">
                    <input type="hidden" name="accion" value="cancelar">
                    <button type="submit" class="account-cancel">Cancelar suscripci&oacute;n</button>
                </form>
                <% } else { %>
                <a href="premium.jsp" class="account-upgrade">Pasar a Premium</a>
                <% } %>
            </div>
        </section>

        <section class="progress-panel badges-panel" id="badgesPanel" aria-label="Insignias del usuario">
            <div class="progress-header">
                <span>Mis Insignias</span>
                <button type="button" class="progress-close" id="badgesClose" aria-label="Cerrar insignias">&times;</button>
            </div>
            <div class="badges-list">
                <div class="badge-item <%= insigniaPrimerMensaje ? "unlocked" : "locked"%>">
                    <span class="badge-icon" aria-hidden="true">&#9993;</span>
                    <div><strong>Primer mensaje</strong><small>Env&iacute;a tu primer mensaje</small></div>
                </div>
                <div class="badge-item <%= insigniaDiezMensajes ? "unlocked" : "locked"%>">
                    <span class="badge-icon" aria-hidden="true">&#128172;</span>
                    <div><strong>Conversador</strong><small>Env&iacute;a 10 mensajes</small></div>
                </div>
                <div class="badge-item <%= insigniaPrimeraCorreccion ? "unlocked" : "locked"%>">
                    <span class="badge-icon" aria-hidden="true">&#10003;</span>
                    <div><strong>Aprendiz atento</strong><small>Recibe tu primera correcci&oacute;n</small></div>
                </div>
                <div class="badge-item <%= insigniaCincoAudios ? "unlocked" : "locked"%>">
                    <span class="badge-icon" aria-hidden="true">&#127908;</span>
                    <div><strong>Voz activa</strong><small>Env&iacute;a 5 audios</small></div>
                </div>
                <div class="badge-item <%= insigniaPremium ? "unlocked" : "locked"%>">
                    <span class="badge-icon" aria-hidden="true">&#11088;</span>
                    <div><strong>Premium</strong><small>Activa el plan de pago</small></div>
                </div>
                <div class="badge-item <%= insigniaConstante ? "unlocked" : "locked"%>">
                    <span class="badge-icon" aria-hidden="true">&#128640;</span>
                    <div><strong>Constante</strong><small>Alcanza 25 puntos</small></div>
                </div>
            </div>
        </section>

        <div class="foro-container">
            <div class="foro-header">
                <div class="foro-title-group">
                    <span class="foro-kicker">English community</span>
                    <h1>Foro <span><%= etiquetaNivel%></span></h1>
                </div>
                <div class="foro-actions">
                    <span class="stars" title="Estrellas obtenidas"><span aria-hidden="true">&#9733;</span> <span id="starsCount"><%= u.getEstrellas()%></span></span>
                    <a href="LoginServlet?accion=logout" class="logout-link">Cerrar sesi&oacute;n</a>
                </div>
            </div>

            <div class="chat-area" id="chat">
                <% for (Mensaje m : lista) {
                        boolean esPropio = (m.getIdUsuario() == u.getIdUsuario());
                        String correccion = null;
                        MensajeDAO cDao = new MensajeDAO();
                        correccion = cDao.obtenerCorreccion(m.getIdMensaje());
                        String correccionLocal = obtenerCorreccionLocal(m.getContenido());
                        if (correccionLocal != null && !correccionLocal.trim().isEmpty()
                                && (correccion == null || correccion.trim().isEmpty())) {
                            correccion = correccionLocal;
                        }
                        boolean tieneCorreccion = correccion != null && !correccion.trim().isEmpty();
                        boolean correccionAjena = !esPropio && tieneCorreccion;
                        boolean sinErrores = esPropio && correccion != null && correccion.trim().isEmpty();
                %>
                <div class="mensaje-box <%= esPropio ? "propio" : ""%> <%= tieneCorreccion ? "con-correccion" : ""%> <%= correccionAjena ? "correccion-ajena" : ""%>"
                     data-id="<%= m.getIdMensaje()%>">
                    <div class="autor"><%= m.getUsernameAutor()%></div>
                    <% if ("Audio".equalsIgnoreCase(m.getTipoMensaje())) { %>
                    <div class="audio-label"><span aria-hidden="true">&#127908;</span> Audio transcrito</div>
                    <% } %>
                    <div class="contenido"><%= m.getContenido()%></div>

                    <% if (tieneCorreccion) {%>
                    <div class="correction-tooltip"><span class="tooltip-arrow" aria-hidden="true"></span><strong>✏️ Correction</strong><br><%= correccion%></div>
                        <% } else if (sinErrores) { %>
                    <div class="no-errors"><span aria-hidden="true">&#10003;</span> No errors</div>
                    <% } %>
                </div>
                <% } %>
            </div>

            <form action="ForoServlet" method="POST" class="footer-input">
                <input type="hidden" name="accion" value="enviar">
                <input type="text" name="txtMensaje" class="input-text" placeholder="Escribe en inglés..." required>
                <% if ("Premium".equalsIgnoreCase(u.getTipoCuenta())) { %>
                <button type="button" class="btn-mic" id="btnMic" aria-label="Grabar audio" title="Grabar audio">&#127908;</button>
                <% }%>
                <button type="submit" class="btn-send" aria-label="Enviar mensaje" title="Enviar mensaje">&#10148;</button>
            </form>
        </div>

        <script>
            const chat = document.getElementById("chat");
            chat.scrollTop = chat.scrollHeight;

            document.addEventListener("DOMContentLoaded", function () {
                const sidebar = document.getElementById('foroSidebar');
                const sidebarToggle = document.getElementById('sidebarToggle');
                const progressToggle = document.getElementById('progressToggle');
                const progressPanel = document.getElementById('progressPanel');
                const progressClose = document.getElementById('progressClose');
                const badgesToggle = document.getElementById('badgesToggle');
                const badgesPanel = document.getElementById('badgesPanel');
                const badgesClose = document.getElementById('badgesClose');
                const peerCorrectionsToggle = document.getElementById('peerCorrectionsToggle');
                const peerCorrectionsKey = 'mostrarCorreccionesAjenas';
                const starsCount = document.getElementById('starsCount');

                function setPeerCorrectionsOpen(abierto) {
                    document.body.classList.toggle('mostrar-correcciones-ajenas', abierto);
                    peerCorrectionsToggle.setAttribute('aria-pressed', abierto);
                    peerCorrectionsToggle.textContent = abierto
                            ? 'Ocultar correcciones ajenas'
                            : 'Ver correcciones ajenas';
                    localStorage.setItem(peerCorrectionsKey, abierto ? '1' : '0');
                    cerrarCorrecciones();
                }

                setPeerCorrectionsOpen(localStorage.getItem(peerCorrectionsKey) === '1');

                function setSidebarOpen(abierto) {
                    sidebar.classList.toggle('open', abierto);
                    sidebarToggle.setAttribute('aria-expanded', abierto);
                }

                function setProgressOpen(abierto) {
                    progressPanel.classList.toggle('open', abierto);
                    progressToggle.setAttribute('aria-expanded', abierto);
                    if (abierto) {
                        setBadgesOpen(false);
                    }
                    progressToggle.classList.toggle('active', abierto);
                    if (abierto) {
                        setSidebarOpen(true);
                    }
                }

                function setBadgesOpen(abierto) {
                    badgesPanel.classList.toggle('open', abierto);
                    badgesToggle.setAttribute('aria-expanded', abierto);
                    badgesToggle.classList.toggle('active', abierto);
                    if (abierto) {
                        progressPanel.classList.remove('open');
                        progressToggle.setAttribute('aria-expanded', false);
                        progressToggle.classList.remove('active');
                        setSidebarOpen(true);
                    }
                }

                sidebarToggle.addEventListener('click', function () {
                    const abrir = !sidebar.classList.contains('open');
                    setSidebarOpen(abrir);
                    if (!abrir) {
                        setProgressOpen(false);
                        setBadgesOpen(false);
                    }
                });

                progressToggle.addEventListener('click', function () {
                    setProgressOpen(!progressPanel.classList.contains('open'));
                });

                progressClose.addEventListener('click', function () {
                    setProgressOpen(false);
                });

                badgesToggle.addEventListener('click', function () {
                    setBadgesOpen(!badgesPanel.classList.contains('open'));
                });

                badgesClose.addEventListener('click', function () {
                    setBadgesOpen(false);
                });

                peerCorrectionsToggle.addEventListener('click', function () {
                    setPeerCorrectionsOpen(!document.body.classList.contains('mostrar-correcciones-ajenas'));
                });

                function cerrarCorrecciones(excepto) {
                    document.querySelectorAll('.correction-tooltip').forEach(function (tooltip) {
                        if (tooltip !== excepto) {
                            tooltip.style.display = 'none';
                            tooltip.style.visibility = '';
                            tooltip.style.maxHeight = '';
                            tooltip.style.position = '';
                            tooltip.style.top = '';
                            tooltip.style.right = '';
                            tooltip.style.bottom = '';
                            tooltip.style.left = '';
                            tooltip.style.removeProperty('--tooltip-arrow-left');
                            tooltip.classList.remove('tooltip-above', 'tooltip-below');
                        }
                    });
                }

                document.querySelectorAll('.mensaje-box.con-correccion').forEach(function (box) {
                    box.addEventListener('click', function (e) {
                        if (this.classList.contains('correccion-ajena')
                                && !document.body.classList.contains('mostrar-correcciones-ajenas')) {
                            return;
                        }

                        if (this.classList.contains('correccion-ajena')) {
                            registrarRevisionCorreccionAjena(this.dataset.id);
                        }

                        const tooltip = this.querySelector('.correction-tooltip');
                        if (!tooltip)
                            return;

                        const estabaAbierto = tooltip.style.display === 'block';
                        cerrarCorrecciones();

                        if (estabaAbierto) {
                            e.stopPropagation();
                            return;
                        }

                        tooltip.style.maxHeight = '';
                        tooltip.style.visibility = 'hidden';
                        tooltip.style.display = 'block';

                        const chatRect = chat.getBoundingClientRect();
                        const boxRect = this.getBoundingClientRect();
                        const margen = 12;
                        const separacion = 10;
                        const altoNatural = tooltip.scrollHeight;
                        const espacioArriba = boxRect.top - chatRect.top;
                        const espacioAbajo = chatRect.bottom - boxRect.bottom;
                        const abrirAbajo = espacioAbajo >= altoNatural + separacion + margen
                                || espacioAbajo > espacioArriba;

                        const espacioDisponible = abrirAbajo ? espacioAbajo : espacioArriba;
                        tooltip.style.maxHeight = Math.max(48, espacioDisponible - separacion - margen) + 'px';
                        tooltip.style.position = 'fixed';
                        tooltip.style.right = 'auto';
                        tooltip.style.bottom = 'auto';

                        const tooltipRect = tooltip.getBoundingClientRect();
                        let top = abrirAbajo
                                ? boxRect.bottom + separacion
                                : boxRect.top - tooltipRect.height - separacion;
                        let left = boxRect.right - tooltipRect.width;

                        top = Math.max(chatRect.top + margen,
                                Math.min(top, chatRect.bottom - tooltipRect.height - margen));
                        left = Math.max(chatRect.left + margen,
                                Math.min(left, chatRect.right - tooltipRect.width - margen));

                        const centroGlobo = top + tooltipRect.height / 2;
                        const centroMensajeVertical = boxRect.top + boxRect.height / 2;
                        const globoDebajo = centroGlobo > centroMensajeVertical;
                        const centroMensajeHorizontal = boxRect.left + boxRect.width / 2;
                        const posicionFlecha = Math.max(16,
                                Math.min(tooltipRect.width - 16, centroMensajeHorizontal - left));
                        const flecha = tooltip.querySelector('.tooltip-arrow');

                        tooltip.classList.toggle('tooltip-below', globoDebajo);
                        tooltip.classList.toggle('tooltip-above', !globoDebajo);

                        if (flecha) {
                            flecha.style.position = 'fixed';
                            flecha.style.left = (left + posicionFlecha - 7) + 'px';
                            flecha.style.right = 'auto';
                            flecha.style.bottom = 'auto';

                            if (globoDebajo) {
                                flecha.style.top = (top - 14) + 'px';
                                flecha.style.borderColor = 'transparent transparent #6c8ebf transparent';
                            } else {
                                flecha.style.top = (top + tooltipRect.height) + 'px';
                                flecha.style.borderColor = '#6c8ebf transparent transparent transparent';
                            }
                        }

                        tooltip.style.top = top + 'px';
                        tooltip.style.left = left + 'px';
                        tooltip.style.visibility = 'visible';

                        e.stopPropagation();
                    });

                    const tooltip = box.querySelector('.correction-tooltip');
                    if (tooltip) {
                        tooltip.addEventListener('click', function (e) {
                            e.stopPropagation();
                        });
                    }
                });

                document.addEventListener('click', function () {
                    cerrarCorrecciones();
                });

                chat.addEventListener('scroll', function () {
                    cerrarCorrecciones();
                });

                window.addEventListener('resize', function () {
                    cerrarCorrecciones();
                });

                async function registrarRevisionCorreccionAjena(idMensaje) {
                    const key = 'correccionAjenaVista_' + idMensaje;
                    if (sessionStorage.getItem(key) === '1') {
                        return;
                    }
                    sessionStorage.setItem(key, '1');

                    try {
                        const params = new URLSearchParams();
                        params.append('accion', 'verCorreccionAjena');
                        params.append('idMensaje', idMensaje);

                        const resp = await fetch('RecompensaServlet', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                            body: params
                        });
                        const data = await resp.json();
                        if (data.ok && starsCount) {
                            starsCount.textContent = data.estrellas;
                        }
                    } catch (err) {
                        console.error('No se pudo registrar recompensa:', err);
                    }
                }

                const formForo = document.querySelector('.footer-input');
                const inputMsg = document.querySelector('.input-text');
                const btnMic = document.getElementById('btnMic');
                const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

                formForo.addEventListener('submit', function (e) {
                    e.preventDefault();
                    corregirYEnviar(inputMsg.value, 'Texto');
                });

                if (btnMic) {
                    if (!SpeechRecognition) {
                        btnMic.disabled = true;
                        btnMic.title = 'Tu navegador no soporta reconocimiento de voz';
                    } else {
                        const recognition = new SpeechRecognition();
                        recognition.lang = 'en-US';
                        recognition.interimResults = false;
                        recognition.maxAlternatives = 1;

                        btnMic.addEventListener('click', function () {
                            btnMic.classList.add('recording');
                            btnMic.title = 'Escuchando...';
                            inputMsg.placeholder = 'Habla en ingles...';
                            recognition.start();
                        });

                        recognition.addEventListener('result', function (event) {
                            const textoAudio = event.results[0][0].transcript;
                            inputMsg.value = textoAudio;
                            corregirYEnviar(textoAudio, 'Audio');
                        });

                        recognition.addEventListener('end', function () {
                            btnMic.classList.remove('recording');
                            btnMic.title = 'Grabar audio';
                            inputMsg.placeholder = 'Escribe en ingles...';
                        });

                        recognition.addEventListener('error', function (event) {
                            console.error('Reconocimiento de voz fallo:', event.error);
                            btnMic.classList.remove('recording');
                            btnMic.title = 'No se pudo escuchar el audio';
                            inputMsg.placeholder = 'Escribe en ingles...';
                        });
                    }
                }

                function agregarCorreccionesLocales(texto, correccionActual) {
                    let correccion = correccionActual || "";
                    const textoNormalizado = texto.trim();
                    const textoLower = textoNormalizado.toLowerCase();

                    if (textoNormalizado.length > 0 && /^[a-z]/.test(textoNormalizado)) {
                        correccion += "• This sentence should start with an uppercase letter. → Try: "
                                + textoNormalizado.charAt(0).toUpperCase() + textoNormalizado.slice(1) + "\n";
                    }

                    if (/\bi\b/.test(textoLower)) {
                        correccion += "• The personal pronoun \"I\" should be uppercase. → Try: "
                                + textoNormalizado.replace(/\bi\b/g, "I") + "\n";
                    }

                    if (/\bi\s+don'?t\s+english\b/.test(textoLower)) {
                        correccion += "• After \"don't\", use a verb before the language. → Try: I don't speak English.\n";
                    }

                    if (/\bi\s+like\s+to\s+english\b/.test(textoLower)) {
                        correccion += "• Use a verb after \"to\". → Try: I like to speak English.\n";
                    }

                    if (/\bhola\b/.test(textoLower)) {
                        correccion += "• Use English in this forum. → Try: Hello.\n";
                    }

                    return correccion;
                }

                async function corregirYEnviar(texto, tipoMensaje) {
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

                    correccionTexto = agregarCorreccionesLocales(texto, correccionTexto);

                    const old = formForo.querySelector('input[name="txtCorreccion"]');
                    if (old)
                        old.remove();
                    const oldTipo = formForo.querySelector('input[name="tipoMensaje"]');
                    if (oldTipo)
                        oldTipo.remove();

                    const hiddenCorr = document.createElement('input');
                    hiddenCorr.type = 'hidden';
                    hiddenCorr.name = 'txtCorreccion';
                    hiddenCorr.value = correccionTexto;
                    formForo.appendChild(hiddenCorr);

                    const hiddenTipo = document.createElement('input');
                    hiddenTipo.type = 'hidden';
                    hiddenTipo.name = 'tipoMensaje';
                    hiddenTipo.value = tipoMensaje;
                    formForo.appendChild(hiddenTipo);

                    formForo.submit();
                }
            });
        </script>
    </body>
</html>
