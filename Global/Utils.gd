extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"playerGold": Game.playerGold,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	print("save")
	
func loadGame():
	var file = null
	file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file != null:
		print("Load")
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.playerHP = current_line["playerHP"]
				Game.playerGold = current_line["playerGold"]
