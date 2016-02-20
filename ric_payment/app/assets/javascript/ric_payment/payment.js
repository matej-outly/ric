function payment_pay(type) 
{
	var url = window.location.pathname.replace(/\/new.*/, "") + window.location.search;
	if (type != null) {
		url += (window.location.search ? "&" : "?") + "type=" + type;
	}

	$.ajax({
		url: url,
		dataType: "json",
		type: "POST",

		// Success data fetch
		success: function(callback) 
		{
			if (callback == false) { // Payment cannot be performed => reload to display error message
				window.location.reload();
			} else {
				$().redirect($("#payment_redirect_url").val(), {
					"sessionInfo.targetGoId": callback.targetGoId, 
					"sessionInfo.paymentSessionId": callback.paymentSessionId,
					"sessionInfo.encryptedSignature": callback.encryptedSignature
				});
			}
		},
		
		// Error data fetch
		error: function(callback) 
		{
		}
	});
}

function payment_redirect(url) 
{
	window.location = url;
}

var payment_timeout = null;
function payment_set_timeout(callback, param)
{
	if (payment_timeout) {
		clearTimeout(payment_timeout);
	}
	payment_timeout = setTimeout(function() { 
		callback(param);
		payment_timeout = null;
	}, 5000);
}

function payment_ready()
{
	if ($(".payment-pay").length > 0) {
		payment_set_timeout(payment_pay, null);
	}

	if ($(".payment-redirect").length > 0) {
		var url = $(".payment-redirect").data("url");
		payment_set_timeout(payment_redirect, url);
	}

	$(".payment-card a").click(function(event) {
		payment_pay("card");
		return false;
	});

	$(".payment-bank a").click(function(event) {
		payment_pay("bank");
		return false;
	});
}
