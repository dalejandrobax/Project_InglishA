<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>EnglishConnect - Test de Nivel</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
        <style>
            .test-container {
                text-align: left;
                max-width: 500px;
            }
            .pregunta {
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }
            .pregunta p {
                font-weight: bold;
                margin-bottom: 8px;
            }
            .opcion {
                margin: 5px 0;
                display: block;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="login-container test-container">
            <div class="logo-title">Diagnostic Test</div>
            <p style="font-size: 0.9rem; color: #666; margin-bottom: 20px;">
                Responde estas preguntas para asignarte al foro correcto.
            </p>

            <form action="TestServlet" method="POST">
                <!-- Pregunta 1: Básico -->
                <div class="pregunta">
                    <p>1. Which sentence is correct?</p>
                    <label class="opcion"><input type="radio" name="p1" value="0"> She have a car.</label>
                    <label class="opcion"><input type="radio" name="p1" value="1"> She has a car.</label>
                </div>

                <!-- Pregunta 2: Básico -->
                <div class="pregunta">
                    <p>2. "Where _____ you from?"</p>
                    <label class="opcion"><input type="radio" name="p2" value="0"> is</label>
                    <label class="opcion"><input type="radio" name="p2" value="1"> are</label>
                </div>

                <!-- Pregunta 3: Intermedio -->
                <div class="pregunta">
                    <p>3. If I _____ more money, I would buy a house.</p>
                    <label class="opcion"><input type="radio" name="p3" value="0"> have</label>
                    <label class="opcion"><input type="radio" name="p3" value="1"> had</label>
                </div>

                <!-- Pregunta 4: Intermedio -->
                <div class="pregunta">
                    <p>4. I have been living here _____ 2010.</p>
                    <label class="opcion"><input type="radio" name="p4" value="1"> since</label>
                    <label class="opcion"><input type="radio" name="p4" value="0"> for</label>
                </div>

                <!-- Pregunta 5: Avanzado -->
                <div class="pregunta">
                    <p>5. By the time he arrived, the meeting _____.</p>
                    <label class="opcion"><input type="radio" name="p5" value="1"> had already finished</label>
                    <label class="opcion"><input type="radio" name="p5" value="0"> has already finished</label>
                </div>

                <button type="submit" class="btn-primary">Finalizar Test</button>
            </form>
        </div>
    </body>
</html>