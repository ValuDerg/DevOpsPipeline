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
