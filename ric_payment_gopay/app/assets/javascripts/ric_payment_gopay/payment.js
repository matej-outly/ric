//
// TODO move to merchant helper!!!
//

function payment_pay(options) 
{
	// Get create payment URL
	var create_url = "";
	if (options["create_url"] != null) {
		create_url = options["create_url"];
	} else {
		create_url = window.location.pathname.replace(/\/new.*/, "") + window.location.search; // Try to compute create URL from current URL
	}
	if (options["type"] != null) {
		create_url += ((create_url.indexOf("?") > -1) ? "&" : "?") + "type=" + options["type"];
	}

	// Get GoPay redirect URL
	var redirect_url = options["redirect_url"];

	console.log(create_url);
	console.log(redirect_url);

	$.ajax({
		url: create_url,
		dataType: "json",
		type: "POST",
		success: function(callback) 
		{
			if (callback == false) { // Payment cannot be performed => reload to display error message
				window.location.reload();
			} else {
				$().redirect(redirect_url, {
					"sessionInfo.targetGoId": callback.target_go_id, 
					"sessionInfo.paymentSessionId": callback.payment_id,
					"sessionInfo.encryptedSignature": callback.encrypted_signature
				});
			}
		},
		error: function(callback) 
		{
		}
	});
}

function payment_redirect(options) 
{
	window.location = options["url"];
}

var payment_timeout = null;
function payment_set_timeout(callback, options)
{
	var timeout = options["timeout"] != null ? options["timeout"] : 0;
	if (payment_timeout) {
		clearTimeout(payment_timeout);
	}
	payment_timeout = setTimeout(function() { 
		callback(options);
		payment_timeout = null;
	}, timeout);
}

function payment_ready()
{
	if ($(".payment.perform-pay").length > 0) {
		var create_url = $(".payment").data("createUrl");
		var redirect_url = $(".payment").data("redirectUrl");
		var timeout = parseInt($(".payment").data("timeout"));
		payment_set_timeout(payment_pay, {
			create_url: create_url,
			redirect_url: redirect_url,
			timeout: timeout,
		});
	}
	if ($(".payment.perform-redirect").length > 0) {
		var url = $(".payment.perform-redirect").data("url");
		var timeout = parseInt($(".payment").data("timeout"));
		payment_set_timeout(payment_redirect, {
			url: url,
			timeout: timeout,
		});
	}
	$(".payment a.payment-type").click(function(e) {
		var create_url = $(".payment").data("createUrl");
		var redirect_url = $(".payment").data("redirectUrl");
		var type = $(this).data("type");
		payment_pay({
			type: type,
			create_url: create_url,
			redirect_url: redirect_url,
		});
		e.preventDefault();
		return false;
	});
}
