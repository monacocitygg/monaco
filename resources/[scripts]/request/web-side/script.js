let timer = null;

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.name === 'Open') {
        const payload = data.payload || [];
        const messageText = payload[0] || 'Unknown Request';
        // const acceptText = payload[1]; 
        // const rejectText = payload[2];

        document.getElementById('message').innerHTML = messageText;
        
        document.getElementById('app').style.display = 'flex';

        // Clear any existing timer
        if (timer) clearTimeout(timer);

        // Auto-reject after 5 seconds
        timer = setTimeout(() => {
            rejectRequest();
        }, 5000);
    }

    if (data.name === 'Y') {
        acceptRequest();
    }

    if (data.name === 'U') {
        rejectRequest();
    }
});

document.getElementById('accept-btn').addEventListener('click', function() {
    acceptRequest();
});

document.getElementById('reject-btn').addEventListener('click', function() {
    rejectRequest();
});

function acceptRequest() {
    // Clear timer to prevent double action
    if (timer) {
        clearTimeout(timer);
        timer = null;
    }

    // Close UI immediately for better responsiveness
    closeUI();
    
    fetch(`https://${GetParentResourceName()}/Sucess`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).catch(err => {
        console.error('Error posting Sucess:', err);
    });
}

function rejectRequest() {
    // Clear timer to prevent double action
    if (timer) {
        clearTimeout(timer);
        timer = null;
    }

    // Close UI immediately for better responsiveness
    closeUI();

    fetch(`https://${GetParentResourceName()}/Failure`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).catch(err => {
        console.error('Error posting Failure:', err);
    });
}

function closeUI() {
    document.getElementById('app').style.display = 'none';
}

// Key listener fallback (core.lua handles keys, but this is backup)
document.addEventListener('keydown', function(event) {
    if (document.getElementById('app').style.display !== 'none') {
        if (event.key === 'y' || event.key === 'Y') {
            acceptRequest();
        } else if (event.key === 'u' || event.key === 'U') {
            rejectRequest();
        }
    }
});
