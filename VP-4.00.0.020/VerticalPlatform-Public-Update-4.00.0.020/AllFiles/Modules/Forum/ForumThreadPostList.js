$(document).ready(function () {
    $("a.reportAbuseLink").click(function (e) {
        var linkText = $(this).text();
        var link = $(this);
        var args = link.attr("href").split('_');
        if (linkText != "Reported" && args.length==3) {
            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                url: VP.AjaxWebServiceUrl + "/ReportAbuseOrSpam",
                data: "{'postRef':'" + $(this).attr("href") + "' }",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    $(link).text("Reported");
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }
        e.preventDefault();
    });
});