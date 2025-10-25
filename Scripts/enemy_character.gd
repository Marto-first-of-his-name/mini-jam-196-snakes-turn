class_name EnemyCharacter extends Character

@export var range_active := 500

func move_or_attack(destination = null, target = null):
	if actions_available>0:
		if target and destination:
			if (destination - position).length() <= attack_range:
				print("attacking", target)
				attack(target)
			else:
				print("moving to", target)
				move_towards(destination, walk_range)
				print("new pos", position)
			
	

func closest_player_in_range(player_characters: Array[PlayerCharacter]) -> PlayerCharacter:
	var players_in_range: Array[PlayerCharacter] = []
	for player in player_characters:
		if (player.position - position).length() < range_active:
			players_in_range.append(player)
	if players_in_range:
		var closest_player = players_in_range[0]
		for player in players_in_range:
			if (player.position - position).length() < (closest_player.position - position).length():
				closest_player = player
		return closest_player
	return null
	
