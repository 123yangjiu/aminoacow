extends Node

#inside_player
@warning_ignore_start("unused_signal")
signal idled(who:NewPlayer)
signal cancel_idle(who:NewPlayer)
signal weapon_exchange_up(which:NewWeaponStatus)
signal weapon_exchange_down(which:NewWeaponStatus)
