$(document).ready(function() {
    window.addEventListener("message", function(event) {
        var item = event.data;

        if (item.show) {
            var key = item.key || "E";
            var title = item.title || "Título";
            var legend = item.legend || "Pressione para abrir";

            var html = `
                <div class="hover-container fadeIn">
                    <div class="hexagon-box">
                        <div class="hexagon"></div>
                        <span class="key-text">${key}</span>
                    </div>
                    <div class="text-content">
                        <div class="title">${title}</div>
                        <div class="subtitle">${legend}</div>
                    </div>
                </div>
            `;

            $("#displayNotify").html(html).fadeIn(200);
        } else {
            $("#displayNotify").fadeOut(200, function() {
                $(this).empty();
            });
        }
    });
});
