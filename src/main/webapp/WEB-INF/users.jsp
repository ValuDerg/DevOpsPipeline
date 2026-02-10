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
