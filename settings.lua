local settings = {
	mode = "dev",
	testMenu = true,
	enableLog = true,
	enableProtector = false,
	databaseChecksum = false,
	debugDatabase = false,
	autoLoadScenes = false,
	fontName = "VAGRounded",
	keySound = "pop",
	maxProfiles = 8,
	gameName = "HeroesSaludables",
	gameVersion = "0.9",
	mixpanelTokens = {
		prod = "NOTOKEN",
		dev = "NOTOKEN",
	},
	mohoundKey = "NOKEY",
    mohoundSecret = "NOSECRET",
	pushWooshID = "NOID",
	pushWooshRegisterHostname = "https://cp.pushwoosh.com/json/1.3/registerDevice",
	server = {
		hostname = "https://heroesofknowledge.appspot.com",
		--hostname = "http://192.168.15.69:8888",
		--hostname = "http://localhost:8888",
		contentType = "application/json",
		appID = "NOID",
		restKey = "NOKEY",
	},
	iOSAppId = 0000000,
	bundle = "com.yogome.HeroesSaludables",
	languagesDataPath = "data/languages/",
}

return settings