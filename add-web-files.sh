#!/bin/bash

# =============================================================================
# DevOps Pipeline - Web Files Creator
# Erstellt alle JSP, CSS und JavaScript Dateien
# =============================================================================

set -e

echo "🌐 Erstelle Web-Dateien (JSP, CSS, JS)..."
echo ""

# Prüfe ob wir im richtigen Verzeichnis sind
if [ ! -f "pom.xml" ]; then
    echo "❌ Fehler: Bitte führe dieses Script im DevOpsPipeline Verzeichnis aus"
    exit 1
fi

# ========== index.jsp ==========
echo "📝 Erstelle index.jsp..."
cat > src/main/webapp/WEB-INF/index.jsp << 'EOF'
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
EOF

# ========== users.jsp ==========
echo "📝 Erstelle users.jsp..."
cat > src/main/webapp/WEB-INF/users.jsp << 'EOF'
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Benutzerverwaltung - DevOps WebApp</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>👥 Benutzerverwaltung</h1>
            <a href="${pageContext.request.contextPath}/" class="btn-back">← Zurück zur Startseite</a>
        </header>
        
        <main>
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <div class="card">
                <h2>Neuen Benutzer hinzufügen</h2>
                <form method="post" action="${pageContext.request.contextPath}/users" class="user-form">
                    <div class="form-group">
                        <label for="username">Benutzername:</label>
                        <input type="text" id="username" name="username" required>
                    </div>
                    <div class="form-group">
                        <label for="email">E-Mail:</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Benutzer erstellen</button>
                </form>
            </div>
            
            <div class="card">
                <h2>Alle Benutzer</h2>
                <c:choose>
                    <c:when test="${not empty users}">
                        <table class="user-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Benutzername</th>
                                    <th>E-Mail</th>
                                    <th>Erstellt am</th>
                                    <th>Aktionen</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr id="user-${user.id}">
                                        <td>${user.id}</td>
                                        <td>${user.username}</td>
                                        <td>${user.email}</td>
                                        <td>${user.createdAt}</td>
                                        <td>
                                            <button onclick="deleteUser(${user.id})" class="btn btn-danger btn-small">
                                                Löschen
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p class="no-data">Keine Benutzer vorhanden. Füge den ersten Benutzer hinzu!</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
        
        <footer>
            <p>&copy; 2026 DevOps Pipeline Demo</p>
        </footer>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
EOF

# ========== style.css ==========
echo "📝 Erstelle style.css..."
cat > src/main/webapp/css/style.css << 'EOF'
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    padding: 20px;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    background: white;
    border-radius: 15px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    overflow: hidden;
}

header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 40px;
    text-align: center;
    position: relative;
}

header h1 {
    font-size: 2.5em;
    margin-bottom: 10px;
}

.subtitle {
    font-size: 1.1em;
    opacity: 0.9;
}

.btn-back {
    position: absolute;
    top: 20px;
    left: 20px;
    color: white;
    text-decoration: none;
    padding: 10px 20px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 5px;
    transition: background 0.3s;
}

.btn-back:hover {
    background: rgba(255, 255, 255, 0.3);
}

main {
    padding: 40px;
}

.card {
    background: #f8f9fa;
    padding: 30px;
    border-radius: 10px;
    margin-bottom: 30px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.card h2 {
    color: #667eea;
    margin-bottom: 20px;
}

.card ul {
    list-style: none;
    padding-left: 0;
}

.card ul li {
    padding: 10px 0;
    font-size: 1.1em;
}

.btn {
    display: inline-block;
    padding: 12px 30px;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
    transition: all 0.3s;
    border: none;
    cursor: pointer;
    font-size: 1em;
}

.btn-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.btn-danger {
    background: #e74c3c;
    color: white;
}

.btn-danger:hover {
    background: #c0392b;
}

.btn-small {
    padding: 6px 15px;
    font-size: 0.9em;
}

.button-group {
    display: flex;
    gap: 15px;
}

.user-form {
    display: grid;
    gap: 20px;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-group label {
    margin-bottom: 8px;
    font-weight: bold;
    color: #555;
}

.form-group input {
    padding: 12px;
    border: 2px solid #ddd;
    border-radius: 5px;
    font-size: 1em;
    transition: border-color 0.3s;
}

.form-group input:focus {
    outline: none;
    border-color: #667eea;
}

.user-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

.user-table th,
.user-table td {
    padding: 15px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

.user-table th {
    background: #667eea;
    color: white;
}

.user-table tbody tr:hover {
    background: #f1f3f5;
}

.no-data {
    text-align: center;
    padding: 40px;
    color: #999;
}

.alert {
    padding: 15px 20px;
    border-radius: 5px;
    margin-bottom: 20px;
    font-weight: bold;
}

.alert-success {
    background: #d4edda;
    color: #155724;
    border-left: 4px solid #28a745;
}

.alert-error {
    background: #f8d7da;
    color: #721c24;
    border-left: 4px solid #dc3545;
}

.info-box {
    background: #e8f4f8;
    padding: 20px;
    border-radius: 10px;
    border-left: 4px solid #17a2b8;
}

.info-box h3 {
    color: #17a2b8;
    margin-bottom: 15px;
}

.info-box p {
    margin: 8px 0;
}

footer {
    background: #2c3e50;
    color: white;
    text-align: center;
    padding: 20px;
}

@media (max-width: 768px) {
    header h1 {
        font-size: 1.8em;
    }
    main {
        padding: 20px;
    }
    .card {
        padding: 20px;
    }
}
EOF

# ========== app.js ==========
echo "📝 Erstelle app.js..."
cat > src/main/webapp/js/app.js << 'EOF'
function deleteUser(userId) {
    if (!confirm('Möchtest du diesen Benutzer wirklich löschen?')) {
        return;
    }
    
    const contextPath = getContextPath();
    
    fetch(`${contextPath}/users?id=${userId}`, {
        method: 'DELETE'
    })
    .then(response => {
        if (response.ok) {
            const row = document.getElementById(`user-${userId}`);
            if (row) {
                row.style.transition = 'opacity 0.3s';
                row.style.opacity = '0';
                setTimeout(() => {
                    row.remove();
                    const tbody = document.querySelector('.user-table tbody');
                    if (tbody && tbody.children.length === 0) {
                        location.reload();
                    }
                }, 300);
            }
            showMessage('Benutzer erfolgreich gelöscht!', 'success');
        } else {
            showMessage('Fehler beim Löschen des Benutzers.', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showMessage('Netzwerkfehler beim Löschen.', 'error');
    });
}

function getContextPath() {
    const path = window.location.pathname;
    const contextPath = path.substring(0, path.indexOf('/', 1));
    return contextPath || '';
}

function showMessage(message, type) {
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    const alert = document.createElement('div');
    alert.className = `alert alert-${type}`;
    alert.textContent = message;
    
    const main = document.querySelector('main');
    if (main) {
        main.insertBefore(alert, main.firstChild);
        setTimeout(() => {
            alert.style.transition = 'opacity 0.3s';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 300);
        }, 3000);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    console.log('DevOps WebApp initialized');
    
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const inputs = form.querySelectorAll('input[required]');
            let isValid = true;
            
            inputs.forEach(input => {
                if (!input.value.trim()) {
                    isValid = false;
                    input.style.borderColor = '#e74c3c';
                } else {
                    input.style.borderColor = '#ddd';
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                showMessage('Bitte fülle alle erforderlichen Felder aus.', 'error');
            }
        });
    });
});
EOF

echo ""
echo "✨ Alle Web-Dateien erfolgreich erstellt!"
echo ""
echo "🎉 Projekt ist jetzt vollständig!"
echo ""
echo "Nächste Schritte:"
echo "1. git init"
echo "2. git add ."
echo "3. git commit -m 'Initial commit'"
echo "4. git remote add origin https://github.com/ValuDerg/DevOpsPipeline.git"
echo "5. git push -u origin main"
