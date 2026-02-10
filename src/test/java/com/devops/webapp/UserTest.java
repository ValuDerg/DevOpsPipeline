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
