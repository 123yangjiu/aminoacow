class_name WeaponPack
extends Node2D

@onready var up_weapon: Node2D = $UpWeapon
@onready var down_weapon: Node2D = $DownWeapon
@onready var else_weapon: Node2D = $ElseWeapon

#func to_idle(who:NewPlayer,all_status:Array[NewWeapon])->void:
#who.is_pack_idle = true
#who.no_attack.append(who.t_pack_idle)
#who.no_exchange.append(who.t_pack_idle)
#who.no_idle.append(who.t_pack_idle)
#if ! up_weapon and ! down_weapon:
#for weapon in all_status:
	#if weapon.status.name == NewWeaponStatus.TYPE_NAME.QIANG:
		#down_weapon.sprite_2d.texture= weapon.texture
		#down_weapon.position = weapon.pack_idle_position-weapon.status.sprite_offset
		#down_weapon.rotation_degrees = weapon.pack_idle_rotation
		#down_weapon.scale = weapon.pack_idle_scale
	#elif  weapon.status.name == NewWeaponStatus.TYPE_NAME.JIAN:
		#up_weapon.sprite_2d.texture = weapon.texture
		#up_weapon.position = weapon.pack_idle_position-weapon.status.sprite_offset
		#up_weapon.rotation_degrees = weapon.pack_idle_rotation
		#up_weapon.scale = weapon.pack_idle_scale
	#elif weapon.status.name == NewWeaponStatus.TYPE_NAME.GONG:
		#else_weapon.sprite_2d.texture = weapon.texture
		#else_weapon.position = weapon.pack_idle_position-weapon.status.sprite_offset
		#else_weapon.rotation_degrees = weapon.pack_idle_rotation
		#else_weapon.scale = weapon.pack_idle_scale
	#weapon.status.place = NewWeaponStatus.TYPE_PLACE._idle
##else:
		#var tween = create_tween().bind_node(who)
		#who.tween_commend.add_tween(tween,"pack_to_idle")
