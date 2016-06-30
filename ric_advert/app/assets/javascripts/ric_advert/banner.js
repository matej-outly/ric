//
// TODO move to view helper together with <div ...> renderers
//

/**
 * Load content
 */
function banner_get(selector, kind)
{
	$.ajax({
		url: "/advert/banners/get?kind=" + kind,
		dataType: "json",

		// Success data fetch
		success: function(callback) 
		{
			if (callback) {
				var html = "";
				if (callback.url) html += "<a target=\"_blank\" href=\"" + callback.url + "\">";
				if (callback.file_kind == "image") {
					html += "<img src=\"" + callback.file_url + "\">";
				} else if (callback.file_kind == "flash") {
					html += "<object>"
					html += "<param name=\"movie\" value=\"" + callback.file_url + "\">"
					html += "<embed src=\"" + callback.file_url + "\">"
					html += "</embed>"
					html += "</object>"
				}
				if (callback.url) html += "</a>";
				$(selector).html(html);
				$(selector).data("id", callback.id);				
				if (callback.url) {
					$(selector + " a").click(function(event) {
						banner_click(selector, kind);
					});
				}
			} else {
				$(selector).html("");
			}
		},
		
		// Error data fetch
		error: function(callback) 
		{
		}
	});
}

/**
 * Notice click
 */
function banner_click(selector, kind)
{
	var id = $(".banner." + kind).data("id");
	$.get("/advert/banners/click?id=" + id);
}
