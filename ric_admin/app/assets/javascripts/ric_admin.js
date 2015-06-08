
function index_table_collapse() 
{
	$("table.index_table").each(function(table_index) {
		var labels = [];
		$(this).find("th").each(function (th_index) {
			labels.push($(this).text());
		});
		$(this).find("tr").each(function (tr_index) {
			$(this).find("td").each(function (td_index) {
				var _this = $(this);
				if (_this.find("span.before").length == 0) {
					_this.html("<span class=\"before\">" + labels[td_index] + "</span>" + _this.html());
				}
			});
		});
	});
}

function index_table_uncollapse() 
{
	$("table.index_table").each(function(table_index) {
		$(this).find("tr").each(function (tr_index) {
			$(this).find("td").each(function (td_index) {
				$(this).find("span.before").remove();
			});
		});
	});
}

function index_table_ready() 
{
	var width = $(document).width();
	if (width <= 768) {
		index_table_collapse();
	} else {
		index_table_uncollapse();
	}
}

$(document).ready(index_table_ready);
$(window).resize(index_table_ready);

