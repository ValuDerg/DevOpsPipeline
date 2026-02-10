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
