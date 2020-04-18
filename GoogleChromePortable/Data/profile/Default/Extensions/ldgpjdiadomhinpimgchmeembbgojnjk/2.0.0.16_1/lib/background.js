console.log(yasoft);
function get_parametr(stat_param, default_value) {
	if (!localStorage.getItem(stat_param)) {
		localStorage.setItem(stat_param, default_value);
	};
	var param = localStorage.getItem(stat_param);
	if (param.charAt(0) == '"') {
		param = param.substr(1, (param.length - 2));
	};
	return param;
};
function send_stat(stat_type, stat_yasoft, stat_ui, stat_version, stat_clid1, update_status, stat_cui) {

	url = "https://soft.export.yandex.ru/status.xml?yasoft=" + stat_yasoft + "&ui=" + stat_ui + "&ver=" + stat_version + "&os=winnt&stat=" + stat_type + "&clid=" + stat_clid1; //dayuse - install
	stat_url = update_status ? (url + '&update=1') : url;
	stat_url = stat_cui ? (stat_url + "&cui=" + stat_cui + "&time=" + Date.now()) : (stat_url + "&time=" + Date.now());

	var StateChange = function () {
		switch (xhr.readyState) {
		case 0:
		case 1:
		case 2:
		case 3:
			break;
		case 4:
			if (xhr.status != 200) {
				console.log(xhr.status + ': ' + xhr.statusText);
				localStorage.setItem('yandex.statistics.time', 0);
			} else {

				localStorage.setItem('yandex.statistics.time', (Date.now() / 1000));
				if (stat_type == 'install') {
					localStorage.setItem('yandex.statistics.installDate', (Date.now() / 1000));
					localStorage.setItem('yandex.statistics.install', 'install');
				}
				if (update_status == 1) {
					localStorage.setItem('yandex.statistics.updateDate', (Date.now() / 1000));
					localStorage.setItem('yandex.statistics.update', 'update.send');
					localStorage.setItem('yandex.statistics.version', chrome.runtime.getManifest().version);
				}
				console.log(xhr.responseText);
			}

			break;
		default:
			console.log("error");
		}
	}
	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = StateChange;
	xhr.open('GET', stat_url, true);
	xhr.send();

}
function set_cookies(set_ui) {
	chrome.cookies.set({
		url : "http://" + cookie_domain + "/",
		domain : '.chrome-elements.yandex.addons',
		name : 'yandex.statistics.ui',
		value : set_ui,
		path : "/",
		expirationDate : Date.now() / 1000 + 31556926,
	});
	chrome.cookies.set({
		url : "http://" + cookie_domain + "/",
		domain : '.chrome-elements.yandex.addons',
		name : 'yandex.statistics.yandex-ui',
		value : set_ui,
		path : "/",
		expirationDate : Date.now() / 1000 + 31556926,
	});

	chrome.cookies.set({
		url : "http://" + cookie_domain + "/",
		domain : '.chrome-elements.yandex.addons',
		name : 'yandex.statistics.is-yandex-ui',
		value : 'true',
		path : "/",
		expirationDate : Date.now() / 1000 + 31556926,
	});
}
function check_cui(cui_param) {
	if ((localStorage.getItem('yandex.statistics.exist.ui')) && (localStorage.getItem('yandex.statistics.exist.ui') != 'none')) {
		var storage_ui = localStorage.getItem('yandex.statistics.ui').substr(1, (localStorage.getItem('yandex.statistics.ui').length - 2));
		var ui = (storage_ui.indexOf("none") + 1) ? storage_ui : ('%7B' + storage_ui.substr(1, storage_ui.length - 2) + '%7D');
		console.log(ui + ' - ' + localStorage.getItem('yandex.statistics.exist.ui'))
		if ((ui == localStorage.getItem('yandex.statistics.exist.ui')) | (localStorage.getItem('yandex.statistics.ui') == localStorage.getItem('yandex.statistics.exist.ui'))) {
			localStorage.removeItem('yandex.statistics.exist.ui');
			console.log('rm');
			return null;
		}
	}
	return cui_param
}
check_cui();
if (localStorage.getItem('yandex.statistics.ui')) {
	chrome.cookies.getAll({
		domain : ".chrome-elements.yandex.addons",

	}, function (cookies) {
		var exist_ui = '';
		var storage_ui = get_parametr('yandex.statistics.ui', default_ui);
		cookies.forEach(function (cookie, i, cookies) {
			if ((cookie.name == 'yandex.statistics.ui') && (cookie.value != ('%7B' + storage_ui.substr(1, storage_ui.length - 2) + '%7D')) && (cookie.value != localStorage.getItem('yandex.statistics.ui'))) {
				exist_ui = cookie.value;
			}
		});
		exist_ui=check_cui(exist_ui);
		if (!exist_ui) {
			if (!localStorage.getItem('yandex.statistics.exist.ui')) {
				set_cookies(localStorage.getItem('yandex.statistics.ui'));
				console.log('set_self');
			} else {

				chrome.cookies.set({
					url : "http://" + cookie_domain + "/",
					domain : '.chrome-elements.yandex.addons',
					name : 'yandex.statistics.ui',
					value : localStorage.getItem('yandex.statistics.exist.ui'),
					path : "/",
					expirationDate : Date.now() / 1000 + 31556926,
				});
				console.log('set_exist');
			}
		} else if (exist_ui != get_parametr('yandex.statistics.ui', default_ui) && (!localStorage.getItem('yandex.statistics.exist.ui'))) {
			localStorage.setItem('yandex.statistics.exist.ui', exist_ui);
		}

		//}
	});
}
var now = new Date();
var lastsend = new Date(localStorage.getItem('yandex.statistics.time') * 1000);
var install_time = new Date(localStorage.getItem('yandex.statistics.installDate') * 1000);
//var update_tome =new Date(localStorage.getItem('yandex.statistics.updateDate')*1000);
function send_install() {
	var storage_ui = get_parametr('yandex.statistics.ui', default_ui);
	var ui = (storage_ui.indexOf("none") + 1) ? storage_ui : ('%7B' + storage_ui.substr(1, storage_ui.length - 2) + '%7D');
	var clid1 = get_parametr('yandex.statistics.clid.1', default_clid1);
	var version = 'none';
	var install_date = Date.now() / 1000;
	version = get_parametr('yandex.statistics.version', chrome.runtime.getManifest().version);

	chrome.cookies.getAll({

		domain : ".chrome-elements.yandex.addons",

	}, function (cookies) {
		var exist_ui = '';
		var is_yandex_ui = false;
		cookies.forEach(function (cookie, i, cookies) {
			if ((cookie.name == 'yandex.statistics.ui') && (cookie.value != localStorage.getItem('yandex.statistics.ui'))) {
				exist_ui = cookie.value;
			} else if (cookie.name == 'yandex.statistics.is-yandex-ui') {
				is_yandex_ui = true;
			}
		});
		exist_ui=check_cui(exist_ui);
		console.log(exist_ui);
		if ((!exist_ui) | (is_yandex_ui)) {
			set_cookies(ui);
			send_stat('install', yasoft, ui, version, clid1, 0, 0);
			console.log("send_install");
		} else if (!is_yandex_ui) {
			send_stat('install', yasoft, ui, version, clid1, 0, exist_ui);
			localStorage.setItem('yandex.statistics.exist.ui', exist_ui);
			console.log("send_nstall");
		}
	});

}

function ch_stat_type() {

	if (((!localStorage.getItem('yandex.statistics.install')) && (!localStorage.getItem('yandex.statistics.update'))) && (localStorage.getItem('yandex.statistics.ui'))) {
		return 'install';
	} else if ((localStorage.getItem('yandex.statistics.update') == 'update') | (chrome.runtime.getManifest().version != localStorage.getItem('yandex.statistics.version'))) {
		return 'update';
	} else
		return 'dayuse';
}
if (((!lastsend) | (lastsend.getDate() != now.getDate()) | (lastsend.getMonth() != now.getMonth()))) {
	var stat_type = ch_stat_type();
	switch (stat_type) {
	case 'install':
		send_install();
		console.log('!!!!!!!!!!!!!!!!!!!!!!!!');
		break;
	case 'update':
		var storage_ui = get_parametr('yandex.statistics.ui', default_ui);
		var ui = (storage_ui.indexOf("none") + 1) ? storage_ui : ('%7B' + storage_ui.substr(1, storage_ui.length - 2) + '%7D');
		var clid1 = get_parametr('yandex.statistics.clid.1', default_clid1);
		localStorage.setItem('yandex.statistics.update', 'update');
		chrome.cookies.getAll({
			domain : ".chrome-elements.yandex.addons",

		}, function (cookies) {
			var exist_ui = '';
			var is_yandex_ui = false;
			cookies.forEach(function (cookie, i, cookies) {
				if ((cookie.name == 'yandex.statistics.ui') && (cookie.value != localStorage.getItem('yandex.statistics.ui'))) {
					exist_ui = cookie.value;
				} else if (cookie.name == 'yandex.statistics.is-yandex-ui') {
					is_yandex_ui = true;
				}
			});
			exist_ui=check_cui(exist_ui);
			console.log(exist_ui);
			if ((!exist_ui) | (is_yandex_ui)) {
				set_cookies(ui);
				console.log("dayuse");
			} else if (!is_yandex_ui) {
				localStorage.setItem('yandex.statistics.exist.ui', exist_ui);
				console.log("dayuse");
			}
			var chrome_ui = localStorage.getItem('yandex.statistics.exist.ui') ? localStorage.getItem('yandex.statistics.exist.ui') : 0;
			send_stat('dayuse', yasoft, ui, chrome.runtime.getManifest().version, clid1, 1, chrome_ui);
		});

		break;

	case 'dayuse':
		var storage_ui = get_parametr('yandex.statistics.ui', default_ui);
		var ui = (storage_ui.indexOf("none") + 1) ? storage_ui : ('%7B' + storage_ui.substr(1, storage_ui.length - 2) + '%7D');
		var clid1 = get_parametr('yandex.statistics.clid.1', default_clid1);
		var chrome_ui = localStorage.getItem('yandex.statistics.exist.ui') ? localStorage.getItem('yandex.statistics.exist.ui') : 0;
		chrome_ui=check_cui(chrome_ui);
		send_stat('dayuse', yasoft, ui, chrome.runtime.getManifest().version, clid1, 0, chrome_ui);
		localStorage.setItem('yandex.statistics.time', Date.now() / 1000);
		break;
	}
}
chrome.alarms.create('stat', {
	periodInMinutes : 5
});
chrome.alarms.onAlarm.addListener(function (alarm) {
	now = new Date();
	lastsend = new Date(localStorage.getItem('yandex.statistics.time') * 1000);
	if (((!lastsend) | (lastsend.getDate() != now.getDate()) | (lastsend.getMonth() != now.getMonth()))) {
		var stat_type = ch_stat_type();
		switch (stat_type) {
		case 'install':
			send_install();
			console.log('!!!!!!!!!!!!!!!!!!!!!!!!');
			break;
		case 'update':
			console.log('upd');
			var storage_ui = get_parametr('yandex.statistics.ui', default_ui);
			var ui = (storage_ui.indexOf("none") + 1) ? storage_ui : ('%7B' + storage_ui.substr(1, storage_ui.length - 2) + '%7D');
			var clid1 = get_parametr('yandex.statistics.clid.1', default_clid1);
			chrome.cookies.getAll({
				domain : ".chrome-elements.yandex.addons",

			}, function (cookies) {
				var exist_ui = '';
				var is_yandex_ui = false;
				cookies.forEach(function (cookie, i, cookies) {
					if ((cookie.name == 'yandex.statistics.ui') && (cookie.value != localStorage.getItem('yandex.statistics.ui'))) {
						exist_ui = cookie.value;
					} else if (cookie.name == 'yandex.statistics.is-yandex-ui') {
						is_yandex_ui = true;
					}
				});
				exist_ui=check_cui(exist_ui);
				console.log(exist_ui);
				if ((!exist_ui) | (is_yandex_ui)) {
					set_cookies(ui);
					console.log("dayuse");
				} else if (!is_yandex_ui) {
					localStorage.setItem('yandex.statistics.exist.ui', exist_ui);
					console.log("dayuse");
				}
				var chrome_ui = localStorage.getItem('yandex.statistics.exist.ui') ? localStorage.getItem('yandex.statistics.exist.ui') : 0;
				send_stat('dayuse', yasoft, ui, chrome.runtime.getManifest().version, clid1, 1, chrome_ui);
			});

			break;

		case 'dayuse':
			var storage_ui = get_parametr('yandex.statistics.ui', default_ui);
			var ui = (storage_ui.indexOf("none") + 1) ? storage_ui : ('%7B' + storage_ui.substr(1, storage_ui.length - 2) + '%7D');
			var clid1 = get_parametr('yandex.statistics.clid.1', default_clid1);
			var chrome_ui = localStorage.getItem('yandex.statistics.exist.ui') ? localStorage.getItem('yandex.statistics.exist.ui') : 0;
			chrome_ui=check_cui(chrome_ui);
			send_stat('dayuse', yasoft, ui, chrome.runtime.getManifest().version, clid1, 0, chrome_ui);
			localStorage.setItem('yandex.statistics.time', Date.now() / 1000);
			break;
		}
	}
});

chrome.runtime.onInstalled.addListener(function (details) {
	var storage_ui = get_parametr('yandex.statistics.ui', default_ui);
	var ui = (storage_ui.indexOf("none") + 1) ? storage_ui : ('%7B' + storage_ui.substr(1, storage_ui.length - 2) + '%7D');
	var clid1 = get_parametr('yandex.statistics.clid.1', default_clid1);
	var version = 'none';
	var install_date = Date.now() / 1000;
	//	console.log('ping');
	if (((details.reason == "update") && (chrome.runtime.getManifest().version != localStorage.getItem('yandex.statistics.version'))) && (localStorage.getItem('yandex.statistics.update') != 'update')) {
		version = chrome.runtime.getManifest().version;
		localStorage.setItem('yandex.statistics.version', version);
		localStorage.setItem('yandex.statistics.update', 'update');

		chrome.cookies.getAll({
			domain : ".chrome-elements.yandex.addons",

		}, function (cookies) {
			var exist_ui = '';
			var is_yandex_ui = false;
			cookies.forEach(function (cookie, i, cookies) {
				if ((cookie.name == 'yandex.statistics.ui') && (cookie.value != localStorage.getItem('yandex.statistics.ui'))) {
					exist_ui = cookie.value;
				} else if (cookie.name == 'yandex.statistics.is-yandex-ui') {
					is_yandex_ui = true;
				}
			});
			exist_ui=check_cui(exist_ui);
			console.log(exist_ui);
			if ((!exist_ui) | (is_yandex_ui)) {
				set_cookies(ui);
				console.log("dayuse");
			} else if (!is_yandex_ui) {
				localStorage.setItem('yandex.statistics.exist.ui', exist_ui);
				console.log("dayuse");
			}
			var chrome_ui = localStorage.getItem('yandex.statistics.exist.ui') ? localStorage.getItem('yandex.statistics.exist.ui') : 0;
			send_stat('dayuse', yasoft, ui, chrome.runtime.getManifest().version, clid1, 1, chrome_ui);

		});

		//send_stat('dayuse', yasoft, ui, version, clid1, 1, 0);
		console.log("Updated from " + details.previousVersion + " to " + version + "!");
	}

});
chrome.cookies.onChanged.addListener(function (info) {

		if ((info.cookie.name == 'yandex.statistics.ui') && (info.removed) && (info.cause != 'overwrite')) {
		check_cui();
			if (!localStorage.getItem('yandex.statistics.exist.ui')) {
				set_cookies(localStorage.getItem('yandex.statistics.ui'));
				console.log(info.cookie.value + ' ' + info.cookie.name + ' ' + info.removed + ' ' + info.cause);
			} else {
				chrome.cookies.set({
					url : "http://" + cookie_domain + "/",
					domain : '.chrome-elements.yandex.addons',
					name : 'yandex.statistics.ui',
					value : localStorage.getItem('yandex.statistics.exist.ui'),
					path : "/",
					expirationDate : Date.now() / 1000 + 31556926,
				});
			}
		}

});
