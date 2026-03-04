document.addEventListener("DOMContentLoaded", () => {
    const uiContainer = document.getElementById("ui-container");
    const playerName = document.getElementById("player-name");
    const playerId = document.getElementById("player-id");
    const discordBtn = document.getElementById("discord-btn");

    window.addEventListener("message", (event) => {
        if (event.data.action === "openUI") {
            if (uiContainer) {
                uiContainer.classList.add("active");
            }
            
            if (playerName) {
                // Combina nome e sobrenome
                playerName.textContent = `${event.data.name} ${event.data.surname}`;
            }

            if (playerId) {
                // Mostra o ID formatado
                playerId.textContent = `Passaporte: ${event.data.id}`;
            }

        } else if (event.data.action === "closeUI") {
            if (uiContainer) {
                uiContainer.classList.remove("active");
            }
        }
    });

    if (discordBtn) {
        discordBtn.addEventListener("click", () => {
            // Tenta abrir o link (dependendo se a função invokeNative está disponível no contexto)
            try {
                window.invokeNative("openUrl", "https://discord.gg/monacogg");
            } catch (e) {
                console.log("Não foi possível abrir a URL nativamente.");
            }
        });
    }

    // Fechar ao pressionar ESC (apenas para teste/debug se necessário, mas geralmente bloqueado por Lua)
    document.addEventListener('keyup', (e) => {
        if (e.key === "Escape") {
            fetch(`https://${GetParentResourceName()}/close`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            }).catch(err => {});
        }
    });
});
