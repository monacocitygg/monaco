$(document).ready(function() {
    window.addEventListener("message", function(event) {
        let action = event.data.action;
        let data = event.data.data;

        if (action === "open") {
            openPanel(data);
        } else if (action === "close") {
            closePanel();
        }
    });

    // Close on ESC
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post("http://painel/close");
            closePanel();
        }
    };

    // Add Member
    $("#add-btn").click(function() {
        let userId = $("#passport-input").val();
        if (userId) {
            $.post("http://painel/invite", JSON.stringify({ user_id: userId }));
            $("#passport-input").val("");
        }
    });
});

function openPanel(data) {
    $("#app").fadeIn(200).css("display", "flex");
    $("#group-name").text(data.groupName || "Organização");
    renderMembers(data.members);
}

function closePanel() {
    $("#app").fadeOut(200);
}

function renderMembers(members) {
    const list = $(".member-list");
    list.empty();

    // Sort: Online first, then by ID
    members.sort((a, b) => {
        if (a.online === b.online) {
            return a.id - b.id;
        }
        return b.online ? 1 : -1; // Correct sorting: Online comes first
    });

    // Update Total Count
    $("#total-members").text(members.length);

    members.forEach(member => {
        let statusClass = member.online ? "online" : "";
        let role = member.role || "Membro";
        
        // Don't show action buttons for self (optional logic, but good for safety)
        // Since we don't know "self" ID here easily without passing it, we render all.
        // Server handles permission checks.

        let html = `
            <div class="member-row">
                <div class="col-status">
                    <div class="status-dot ${statusClass}"></div>
                </div>
                <div class="col-name">
                    ${member.name}
                    <span>ID: ${member.id}</span>
                </div>
                <div class="col-role">
                    <span class="role-badge">${role}</span>
                </div>
                <div class="col-phone">
                    ${member.phone}
                </div>
                <div class="col-actions">
                    <div class="action-btn promote" onclick="action('promote', ${member.id})">
                        <i class="fa-solid fa-chevron-up"></i>
                    </div>
                    <div class="action-btn demote" onclick="action('demote', ${member.id})">
                        <i class="fa-solid fa-chevron-down"></i>
                    </div>
                    <div class="action-btn kick" onclick="action('dismiss', ${member.id})">
                        <i class="fa-solid fa-trash"></i>
                    </div>
                </div>
            </div>
        `;
        list.append(html);
    });
}

function action(type, id) {
    $.post(`http://painel/${type}`, JSON.stringify({ user_id: id }));
}
