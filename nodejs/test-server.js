// Runs on nodejs
var http = require("http");
var fs = require("fs");
var url = require("url");
var crypto = require("crypto");

var items = process.argv[2].split(/,/);
// Single argument is comma separated list of test files

var config = (function() {
	var lines = fs.readFileSync(__dirname + "/config.ini", "utf-8").split(/\r\n/);
	
	var settings = {};
	var mimetypes = {};
	var assets = {};
	var cache = {};
	
	var type = null;
	
	for(var i = 0; i < lines.length; ++i) {
		if(!lines[i].length) {
			continue;
		} else if(lines[i][0] === "[") {
			type = lines[i].replace(/[\[\]]/g, "").toLowerCase();
		} else {
			var sides = lines[i].split(/\=/);
			switch(type) {
				case "assets":
					var parts = sides[0].split(/\./);
					if(assets[parts[0]] == null) {
						assets[parts[0]] = {};
					}
					assets[parts[0]][parts[1]] = __dirname + sides[1];
					break;
				case "mimetypes":
					mimetypes[sides[0]] = sides[1];
					break;
				case "cache":
					cache[sides[0]] = !!sides[1];
					break;
				default:
					settings[sides[0]] = sides[1];
			}
		}
	}
	
	return {
		getSetting: function(name, defval) {
			return settings[name] || defval;
		},
		getAsset: function(type, name) {
			return assets[type][name];
		},
		getMimeType: function(type) {
			return mimetypes[type];
		},
		isCachable: function(type) {
			return cache[type] == true;
		}
	}
	
}) ();

var port = config.getSetting("port", 8383);
var maxwait = config.getSetting("maxwait", 10000);

http.createServer(function(request, response) {
	
	var location = url.parse(request.url, true), 
	    action;
	
	if(location.query.asset)
		action = "asset";
	
	if(location.query.action)
		action = location.query.action;
		
	switch(action) {
		
		case "check":			
			waitAndCheckForScriptChanges(new Date().valueOf(), location.query.hash, response);
			// The request is a long poll where it periodically tests that the 
			// watched resources haven't changed. If the hash is the same then 
			// it will wait and check again until the TEST_SERVER_MAX_WAIT time 
			// has elapsed. It returns the new hash as soon as the check shows 
			// the resources have changed
			break;
			
		case "test":
			serveAsset(response, "html", "test");
			break;
		case "test.assets":
			respond(response, getSource(items), config.getMimeType("script"));
			break;
		case "asset":
			serveAsset(response, location.query.asset, location.query.name);
			break;
		default:
			serveAsset(response, "html", "live");
			break;
	}
	
}).listen(port);

function serveAsset(response, type, name) {
	var content = "", 
	    asset;
	if(asset = config.getAsset(type, name))
		content = fs.readFileSync(asset);
	respond(response, content, config.getMimeType(type), config.isCachable(type));
}

function hashSource(items) {
	var hash = crypto.createHash("sha1");
	hash.update(getSource(items));
	return hash.digest("hex");
}

function getSource(items) {
	var content = "";
	getSourceFiles(items).forEach(function(val) {
		content += fs.readFileSync(val);
	});
	return content;	
}

function getSourceFiles(items) {
	var r = [];
	items.forEach(function(val) {
		r = r.concat(getSourceFilesForItem(val));
	});
	return r;
}

function getSourceFilesForItem(item) {
	var stat = fs.statSync(item), 
	    r = [];
	if(stat.isDirectory() && item.search(/^\./) == -1) {
		var items = fs.readdirSync(item);
		items.forEach(function(val) {
			r = r.concat(getSourceFilesForItem(item + "/" + val));
		})
	} else if(stat.isFile() && item.search(/\.js$/) != -1) {
		r.push(item);
	}
	return r;
}

// TODO Detect if watch can be used and use that instead
function waitAndCheckForScriptChanges(start, check, response) {
	setTimeout(function() {
		if(start + maxwait < new Date().valueOf() 
			|| check != (hash = hashSource(items))) {
			respond(response, JSON.stringify({
				"hash" : hashSource(items)
			}), "application/json");
		} else {
			waitAndCheckForScriptChanges(start, check, response);
		}
	}, 10);
}

function respond(response, content, mimetype, cachable) {
	response.setHeader("Content-Type", (mimetype || "text/plain") + "; charset=utf-8");
	response.setHeader("Content-Length", content.length);
	if(!cachable)
		response.setHeader("Cache-Control", "no-cache");
	response.end(content);
}

console.log("Browse to http://localhost:" + port + " to run tests");
