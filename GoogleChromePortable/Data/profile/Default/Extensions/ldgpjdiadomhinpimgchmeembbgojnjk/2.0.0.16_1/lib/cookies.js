function set_ys(domain) {
	chrome.cookies.get({
		url : 'http://' + domain,
		name : 'ys'
	},
		function (cookie) {
		var prev_value='';
		if (cookie) {
			if (!(cookie.value.indexOf(extvalue) + 1)) {
				prev_value = cookie.value;
				chrome.cookies.set({
					url : 'https://' + domain,
					domain : '.' + domain,
					name : "ys",
					value : extvalue + prev_value,

				});

			};
		} else {
			chrome.cookies.set({
				url : 'https://' + domain,
				domain : '.' + domain,
				name : "ys",
				value : extvalue + prev_value,

			});

		}
	});

};
dom_list.forEach(function (dom, i, dom_list) {
	set_ys(dom);
});

	chrome.cookies.onChanged.addListener(function (info) {
		dom_list.forEach(function (dom, i, dom_list) {
			if (info.cookie.domain == '.' + dom) {
				set_ys(dom);
			}
		});

	});
