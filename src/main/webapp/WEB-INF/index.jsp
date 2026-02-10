<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps WebApp - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>🚀 DevOps WebApp</h1>
            <p class="subtitle">Java Servlet/JSP mit MySQL - CI/CD Pipeline Demo</p>
        </header>
        
        <main>
            <div class="card">
                <h2>Willkommen!</h2>
                <p>Diese WebApp demonstriert eine vollständige DevOps Pipeline:</p>
                <ul>
                    <li>✅ Java 21 mit Servlets/JSP</li>
                    <li>✅ MySQL Datenbank</li>
                    <li>✅ Docker Container (Tomcat 11, Jenkins, MySQL)</li>
                    <li>✅ Automatisches Build & Deployment via Jenkins</li>
                    <li>✅ GitHub Integration</li>
                </ul>
            </div>
            
            <div class="card">
                <h2>Funktionen</h2>
                <div class="button-group">
                    <a href="${pageContext.request.contextPath}/users" class="btn btn-primary">
                        👥 Benutzerverwaltung
                    </a>
                </div>
            </div>
            
            <div class="info-box">
                <h3>ℹ️ System Info</h3>
                <p><strong>Server:</strong> <%= application.getServerInfo() %></p>
                <p><strong>Servlet Version:</strong> <%= application.getMajorVersion() %>.<%= application.getMinorVersion() %></p>
                <p><strong>Deploy Zeit:</strong> <%= new java.util.Date() %></p>
            </div>
        </main>
        
        <footer>
            <p>&copy; 2026 DevOps Pipeline Demo</p>
        </footer>
    </div>
</body>
</html>
