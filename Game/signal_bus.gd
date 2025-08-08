extends Node
#Game
signal start_spawning
signal stop_spawning
signal round_over
signal game_timer_changed(new_number: float)
signal game_over
#Shop
signal item_hovered(description: String)
signal item_unhovered
signal refresh_shop
signal refresh_player_textures(bucket: Texture2D, band: Texture2D)
signal item_bought(item: ShopItem)
#Screen Manager
signal screen_swapped(screen: Node)
signal overlay_activated(overlay: Control)
signal overlay_deactivated(overlay: Control)
