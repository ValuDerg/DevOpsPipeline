#!/bin/bash

# =============================================================================
# DevOps Pipeline - Java Files Creator
# Fügt alle Java-Klassen, JSPs, CSS und JS hinzu
# =============================================================================

set -e

echo "☕ Erstelle Java-Dateien und Web-Ressourcen..."
echo ""

# Prüfe ob wir im richtigen Verzeichnis sind
if [ ! -f "pom.xml" ]; then
    echo "❌ Fehler: Bitte führe dieses Script im DevOpsPipeline Verzeichnis aus"
    exit 1
fi

# ========== Java: DatabaseUtil ==========
echo "📝 Erstelle DatabaseUtil.java..."
cat > src/main/java/com/devops/webapp/util/DatabaseUtil.java << 'EOF'
package com.devops.webapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {
    
    private static final String DB_URL = System.getenv().getOrDefault("DB_URL", "jdbc:mysql://devops-mysql:3306/webapp_db");
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "webapp_user");
    private static final String DB_PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "webapp_password_change_me");
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
    
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
EOF

# ========== Java: User Model ==========
echo "📝 Erstelle User.java..."
cat > src/main/java/com/devops/webapp/model/User.java << 'EOF'
package com.devops.webapp.model;

public class User {
    
    private int id;
    private String username;
    private String email;
    private String createdAt;
    
    public User() {}
    
    public User(String username, String email) {
        this.username = username;
        this.email = email;
    }
    
    public User(int id, String username, String email, String createdAt) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.createdAt = createdAt;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', email='" + email + "'}";
    }
}
EOF

# ========== Java: UserDAO ==========
echo "📝 Erstelle UserDAO.java..."
cat > src/main/java/com/devops/webapp/dao/UserDAO.java << 'EOF'
package com.devops.webapp.dao;

import com.devops.webapp.model.User;
import com.devops.webapp.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public boolean createUser(User user) {
        String sql = "INSERT INTO users (username, email) VALUES (?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("created_at")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
EOF

# ========== Java: HomeServlet ==========
echo "📝 Erstelle HomeServlet.java..."
cat > src/main/java/com/devops/webapp/servlets/HomeServlet.java << 'EOF'
package com.devops.webapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/")
public class HomeServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/index.jsp").forward(request, response);
    }
}
EOF

# ========== Java: UserServlet ==========
echo "📝 Erstelle UserServlet.java..."
cat > src/main/java/com/devops/webapp/servlets/UserServlet.java << 'EOF'
package com.devops.webapp.servlets;

import com.devops.webapp.dao.UserDAO;
import com.devops.webapp.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/users.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        
        if (username != null && !username.trim().isEmpty() && 
            email != null && !email.trim().isEmpty()) {
            
            User user = new User(username.trim(), email.trim());
            boolean success = userDAO.createUser(user);
            
            if (success) {
                request.setAttribute("message", "Benutzer erfolgreich erstellt!");
            } else {
                request.setAttribute("error", "Fehler beim Erstellen des Benutzers.");
            }
        } else {
            request.setAttribute("error", "Bitte alle Felder ausfüllen.");
        }
        
        doGet(request, response);
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                boolean success = userDAO.deleteUser(id);
                response.setStatus(success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
EOF

# ========== SQL Schema ==========
echo "📝 Erstelle schema.sql..."
cat > src/main/resources/schema.sql << 'EOF'
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (username, email) VALUES 
    ('admin', 'admin@devops.local'),
    ('testuser', 'test@devops.local'),
    ('developer', 'dev@devops.local')
ON DUPLICATE KEY UPDATE username=username;
EOF

# ========== Unit Test ==========
echo "📝 Erstelle UserTest.java..."
cat > src/test/java/com/devops/webapp/UserTest.java << 'EOF'
package com.devops.webapp;

import com.devops.webapp.model.User;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class UserTest {
    
    @Test
    public void testUserCreation() {
        User user = new User("testuser", "test@example.com");
        assertEquals("testuser", user.getUsername());
        assertEquals("test@example.com", user.getEmail());
    }
    
    @Test
    public void testUserSetters() {
        User user = new User();
        user.setId(1);
        user.setUsername("admin");
        user.setEmail("admin@example.com");
        
        assertEquals(1, user.getId());
        assertEquals("admin", user.getUsername());
        assertEquals("admin@example.com", user.getEmail());
    }
}
EOF

# ========== web.xml ==========
echo "📝 Erstelle web.xml..."
cat > src/main/webapp/WEB-INF/web.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee 
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">

    <display-name>DevOps WebApp</display-name>
    
    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>
    
    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>
</web-app>
EOF

echo ""
echo "✨ Alle Java-Dateien erfolgreich erstellt!"
echo ""
echo "Nächster Schritt:"
echo "Führe ./add-web-files.sh aus, um JSP, CSS und JS zu erstellen"
