extends Node2D

const VIEW_SIZE := Vector2(1280, 720)
const GRAVITY := 1550.0
const WORLD_WIDTH := 6300.0
const SHARDS_REQUIRED := 4
const SHARDS_TOTAL := 6
const STAR_TEXTURE_PATH := "res://3d-star-icon-isolated-on-background-customer-rating-feedback-concept-3d-rendering-free-png.webp"
const SAVE_PATH := "user://starfall_save.cfg"
const MUSIC_PATH := "res://assets/audio/starfall_calm_theme.ogg"

const CHARACTER_DATA := {
	"Fighter": {"title": "THE FIGHTER", "sub": "Balanced blade • steady heart", "hp": 5, "speed": 300.0, "damage": 1, "dash": 850.0},
	"Samurai": {"title": "THE SAMURAI", "sub": "Heavy strikes • iron resolve", "hp": 7, "speed": 260.0, "damage": 2, "dash": 770.0},
	"Shinobi": {"title": "THE SHINOBI", "sub": "Quick feet • phantom dash", "hp": 4, "speed": 355.0, "damage": 1, "dash": 1020.0}
}
const DIFFICULTIES := ["STORY", "RONIN", "NIGHTMARE"]
const DIFFICULTY_INFO := ["Gentle journey · 5 lives", "The intended challenge · 3 lives", "No mercy · 2 lives, faster foes"]
const CHAPTERS := [
	{"title": "THE FALLEN TORII", "place": "Ashes of the Starwell", "story": "At midnight, the Starwell shattered. Six seals burst across the rooftops and the city's dawn vanished with them. The old torii gate still stands, but its light is gone.\n\nThe bellkeeper entrusts you with the first seal. Find four and carry their light through the gate before the Starless patrols close in.", "tactic": "ROUTE TIP  ·  Learn the Moon Springs. A clean landing launches you over the widest gaps.", "sky": Color(0.035, 0.055, 0.16), "accent": Color(0.17, 0.86, 1.0)},
	{"title": "LANTERN QUARTER", "place": "A City Without Morning", "story": "The lantern quarter glows with cold blue fire. Families are hiding beneath the market bridges while Starless patrols sweep the roofs. At the old night market, your friend Aiko has kept one lantern burning.\n\nAiko gives you a signal map and a warning: the rooftops rise sharply above the market. Follow the lanterns to reach her safehouse and recover the scattered seals.", "tactic": "ROUTE TIP  ·  The market rooftops climb and dip. Use the upper ledges to bypass patrols.", "sky": Color(0.10, 0.035, 0.18), "accent": Color(1.0, 0.31, 0.65)},
	{"title": "THE SUNKEN ARCHIVE", "place": "Memory Beneath the Rain", "story": "The archive is flooded to its highest shelves. Its records show the Starwell was not destroyed by an invading army; its keepers sealed the sun away to stop a war. The guardian recognizes your crest and refuses to let you read further.\n\nFind the drowned records between the rain-slick galleries. The truth is hidden in the highest vault, beyond the guardian's reach.", "tactic": "ROUTE TIP  ·  Wet stone breaks the route into short jumps. Watch for red hazard marks.", "sky": Color(0.025, 0.12, 0.20), "accent": Color(0.25, 0.93, 0.79)},
	{"title": "IRON CROWN", "place": "The Citadel Above the Clouds", "story": "The Iron Crown rules from a fortress above the clouds and calls the darkness peace. Its banners cover every tower. At the outer wall, Aiko's signal map reveals a hidden path used by the old Starwell guards.\n\nClimb the stepped citadel, light the beacons, and break through the Warden's line. The Starless waits at the summit with the final seal.", "tactic": "ROUTE TIP  ·  The citadel has long stair-step climbs. Save focus for the Warden and dash past hazards.", "sky": Color(0.14, 0.045, 0.065), "accent": Color(1.0, 0.60, 0.20)},
	{"title": "THE LAST LIGHT", "place": "Return to the Starwell", "story": "The seals are warm in your hands. At the hollow heart of the Starwell, the Starless removes their mask: the keeper who once taught you how to guard the light. They broke the well to keep its power from starting another war.\n\nThe city watches from dark windows. Defeat the keeper, restore the Starwell, and make one last leap into the dawn.", "tactic": "FINAL TRIAL  ·  Break the Starless's guard, gather four seals, then enter the Starwell.", "sky": Color(0.09, 0.055, 0.18), "accent": Color(1.0, 0.86, 0.37)}
]

const GROUND_LAYOUT := [
	Rect2(0, 620, 850, 240), Rect2(970, 600, 660, 260), Rect2(1740, 620, 720, 240),
	Rect2(2580, 570, 800, 290), Rect2(3500, 620, 700, 240), Rect2(4310, 590, 820, 270),
	Rect2(5240, 620, 1060, 240)
]
const FLOAT_LAYOUT := [
	Rect2(650, 500, 190, 24), Rect2(1160, 465, 230, 24), Rect2(2010, 500, 210, 24),
	Rect2(2860, 455, 250, 24), Rect2(3820, 490, 220, 24), Rect2(4650, 450, 240, 24), Rect2(5570, 505, 210, 24)
]
const SHARD_LAYOUT := [Vector2(520, 540), Vector2(1280, 410), Vector2(2200, 535), Vector2(2980, 400), Vector2(4660, 405), Vector2(5680, 535)]
const CHECKPOINTS := [Vector2(2130, 0), Vector2(4630, 0)]
const HAZARD_X := [650.0, 1260.0, 2240.0, 3060.0, 3900.0, 4770.0, 5630.0]
const BOUNCE_PAD_X := [2380.0, 4070.0, 5000.0]
const CHAPTER_GROUND_X := [
	[0, 0, 0, 0, 0, 0, 0],
	[0, 42, -28, 48, -38, 30, 0],
	[0, -32, 48, -46, 36, -24, 0],
	[0, 30, -45, 22, -36, 48, 0],
	[0, -42, 26, -24, 45, -38, 0]
]
const CHAPTER_GROUND_Y := [
	[0, 0, 0, 0, 0, 0, 0],
	[-22, 12, -28, 20, -16, 30, -8],
	[14, 34, -8, -38, 28, -14, 10],
	[-38, -18, -52, -14, -42, -62, -28],
	[-8, -32, 24, -46, -12, -54, 8]
]
const CHAPTER_FLOAT_Y := [
	[0, 0, 0, 0, 0, 0, 0],
	[-28, 14, -18, 28, -12, 20, -24],
	[22, -14, 28, -26, 16, -22, 20],
	[-12, -32, -8, -34, -18, -38, -10],
	[-22, 18, -32, 12, -24, -42, -18]
]
const CHAPTER_SHARD_X := [
	[0, 0, 0, 0, 0, 0],
	[70, -50, 90, -80, 55, -65],
	[-60, 90, -75, 65, -45, 85],
	[40, -85, 60, -45, 95, -70],
	[-85, 55, -40, 90, -70, 45]
]

var rng := RandomNumberGenerator.new()
var character_name := "Fighter"
var difficulty_index := 1
var selected_character_index := 0
var current_chapter := 0
var unlocked_chapter := 0
var saved_checkpoint_chapter := -1
var saved_checkpoint_x := 80.0
var current_mode := "menu"
var touch_controls_enabled := false
var save_config := ConfigFile.new()
var music_enabled := true
var music_player: AudioStreamPlayer
var joystick_base: Control
var joystick_knob: Control
var joystick_touch_index := -1
var joystick_center := Vector2.ZERO
var joystick_radius := 52.0
var best_time := 0.0
var total_score := 0
var chapter_score := 0
var deaths_this_run := 0

var ui_layer: CanvasLayer
var ui_root: Control
var world_root: Node2D
var hero: CharacterBody2D
var hero_sprite: AnimatedSprite2D
var hero_camera: Camera2D
var sprite_frames_cache: Dictionary = {}
var platform_rects: Array[Rect2] = []
var ground_rects: Array[Rect2] = []
var hazard_rects: Array[Rect2] = []
var bounce_pad_rects: Array[Rect2] = []
var shard_areas: Array[Area2D] = []
var enemies: Array[Dictionary] = []
var particles: Array[Dictionary] = []
var checkpoint_positions: Array[float] = []
var checkpoint_x := 80.0
var shard_count := 0
var health := 5
var max_health := 5
var lives := 3
var focus := 100.0
var elapsed_time := 0.0
var invulnerability := 0.0
var attack_timer := 0.0
var attack_cooldown := 0.0
var dash_timer := 0.0
var dash_cooldown := 0.0
var knockback_timer := 0.0
var knockback_x := 0.0
var facing := 1.0
var combo_count := 0
var combo_timer := 0.0
var enemy_attack_variant := 0
var jump_buffer := 0.0
var coyote_timer := 0.0
var jump_requested := false
var attack_requested := false
var dash_requested := false
var special_requested := false
var shield_held := false
var run_held := false
var touch_state := {"left": false, "right": false, "jump": false, "attack": false, "dash": false, "special": false, "guard": false, "run": false}
var toast_text := ""
var toast_timer := 0.0
var level_complete := false
var ending_unlocked := false

func _ready() -> void:
	rng.randomize()
	_load_save()
	for name in CHARACTER_DATA:
		sprite_frames_cache[name] = _make_sprite_frames(name)
	ui_layer = CanvasLayer.new()
	ui_layer.layer = 10
	ui_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(ui_layer)
	ui_root = Control.new()
	ui_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(ui_root)
	touch_controls_enabled = DisplayServer.is_touchscreen_available() or OS.has_feature("web")
	_start_background_music()
	_show_main_menu()

func _start_background_music() -> void:
	var music_stream := load(MUSIC_PATH) as AudioStreamOggVorbis
	if music_stream == null:
		return
	music_stream.loop = true
	music_player = AudioStreamPlayer.new()
	music_player.name = "StarfallMusic"
	music_player.stream = music_stream
	music_player.volume_db = -15.0
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	if music_enabled:
		music_player.play()

func _process(delta: float) -> void:
	if toast_timer > 0.0:
		toast_timer = maxf(0.0, toast_timer - delta)
		queue_redraw()
	if current_mode == "play":
		for area in shard_areas:
			if is_instance_valid(area):
				var bob_time := Time.get_ticks_msec() * 0.0035 + float(area.get_meta("phase", 0.0))
				area.position.y = float(area.get_meta("base_y")) + sin(bob_time) * 12.0
				var sprite := area.get_node_or_null("Sprite2D") as Sprite2D
				if sprite != null:
					sprite.rotation = sin(bob_time * 0.7) * 0.14
		_update_particles(delta)
		queue_redraw()

func _physics_process(delta: float) -> void:
	if current_mode != "play" or hero == null or level_complete:
		return
	elapsed_time += delta
	focus = minf(100.0, focus + delta * 11.0)
	invulnerability = maxf(0.0, invulnerability - delta)
	attack_timer = maxf(0.0, attack_timer - delta)
	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	dash_cooldown = maxf(0.0, dash_cooldown - delta)
	knockback_timer = maxf(0.0, knockback_timer - delta)
	combo_timer = maxf(0.0, combo_timer - delta)
	if combo_timer <= 0.0:
		combo_count = 0
	if toast_timer <= 0.0 and toast_text != "":
		toast_text = ""

	var horizontal := _read_horizontal()
	if horizontal != 0.0:
		facing = signf(horizontal)
	if jump_requested:
		jump_buffer = 0.14
	else:
		jump_buffer = maxf(0.0, jump_buffer - delta)
	jump_requested = false
	if hero.is_on_floor():
		coyote_timer = 0.12
	else:
		coyote_timer = maxf(0.0, coyote_timer - delta)
	if jump_buffer > 0.0 and coyote_timer > 0.0:
		hero.velocity.y = -760.0 if difficulty_index == 0 else -710.0
		jump_buffer = 0.0
		coyote_timer = 0.0
		_play_hero_animation("jump")

	if attack_requested:
		_perform_attack(false)
		attack_requested = false
	if special_requested:
		_perform_attack(true)
		special_requested = false
	if dash_requested:
		_try_dash()
		dash_requested = false

	var data: Dictionary = CHARACTER_DATA[character_name]
	var base_speed: float = data["speed"]
	if knockback_timer > 0.0:
		hero.velocity.x = knockback_x
	elif dash_timer > 0.0:
		dash_timer = maxf(0.0, dash_timer - delta)
		hero.velocity.x = facing * float(data["dash"])
		hero.velocity.y = 0.0
	else:
		var sprinting := run_held or bool(touch_state["run"])
		var move_speed := base_speed * (0.58 if shield_held and focus > 0.0 else (1.45 if sprinting else 1.0))
		hero.velocity.x = horizontal * move_speed
	if not hero.is_on_floor() and dash_timer <= 0.0:
		var gravity_scale := 0.66 if _jump_held() and hero.velocity.y < 0.0 else 1.0
		var chapter_gravity := 0.72 if current_chapter == 2 else 1.0
		hero.velocity.y = minf(hero.velocity.y + GRAVITY * gravity_scale * chapter_gravity * delta, 1150.0)
	hero.move_and_slide()
	hero.position.x = clampf(hero.position.x, 18.0, WORLD_WIDTH - 18.0)
	if hero.position.y > 920.0:
		invulnerability = 0.0
		_hurt_hero(2, -1.0 if hero.position.x > checkpoint_x else 1.0)
		if current_mode != "play":
			return
		if hero.position.y > 920.0:
			_respawn_at_checkpoint()
	_update_hero_animation(horizontal)
	_update_enemies(delta)
	if current_mode != "play":
		return
	_update_checkpoints()
	_update_game_hud()
	if hero.position.x >= WORLD_WIDTH - 180.0 and toast_timer <= 0.0:
		_try_finish_gate()
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch_controls_enabled and current_mode == "play":
			if touch.pressed and joystick_touch_index == -1 and joystick_base != null and touch.position.distance_to(joystick_center) <= joystick_radius + 30.0:
				joystick_touch_index = touch.index
				_update_virtual_joystick(touch.position)
			elif not touch.pressed and touch.index == joystick_touch_index:
				_release_virtual_joystick()
		return
	if event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == joystick_touch_index:
			_update_virtual_joystick(drag.position)
		return
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if not key_event.pressed:
			if key_event.keycode == KEY_Q:
				shield_held = false
			elif key_event.keycode == KEY_X:
				run_held = false
			return
		if key_event.echo:
			return
		if current_mode == "play":
			if key_event.keycode == KEY_ESCAPE or key_event.keycode == KEY_P:
				_show_pause()
			elif key_event.keycode in [KEY_SPACE, KEY_W, KEY_UP]:
				jump_requested = true
			elif key_event.keycode == KEY_J:
				attack_requested = true
			elif key_event.keycode in [KEY_SHIFT, KEY_K]:
				dash_requested = true
			elif key_event.keycode == KEY_X:
				run_held = true
			elif key_event.keycode == KEY_L:
				special_requested = true
			elif key_event.keycode == KEY_Q:
				shield_held = true
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.pressed and event.keycode == KEY_Q:
		shield_held = false

func _read_horizontal() -> float:
	var axis := 0.0
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A) or bool(touch_state["left"]):
		axis -= 1.0
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D) or bool(touch_state["right"]):
		axis += 1.0
	return clampf(axis, -1.0, 1.0)

func _jump_held() -> bool:
	return Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or bool(touch_state["jump"])

func _make_sprite_frames(actor: String) -> SpriteFrames:
	var frames := SpriteFrames.new()
	for animation in ["default"]:
		if frames.has_animation(animation):
			frames.remove_animation(animation)
	var files := {
		"idle": ["Idle", 7.0, true], "walk": ["Walk", 12.0, true], "run": ["Run", 14.0, true],
		"jump": ["Jump", 12.0, true], "attack_1": ["Attack_1", 15.0, false], "attack_2": ["Attack_2", 15.0, false],
		"attack_3": ["Attack_3", 15.0, false], "hurt": ["Hurt", 10.0, false], "dead": ["Dead", 8.0, false], "shield": ["Shield", 8.0, true]
	}
	for anim_name in files:
		var spec: Array = files[anim_name]
		var path := "res://assets/characters/%s/%s.png" % [actor, spec[0]]
		if not ResourceLoader.exists(path):
			continue
		var texture := load(path) as Texture2D
		if texture == null:
			continue
		var frame_count := int(texture.get_width() / 128)
		frames.add_animation(anim_name)
		frames.set_animation_speed(anim_name, float(spec[1]))
		frames.set_animation_loop(anim_name, bool(spec[2]))
		for i in range(frame_count):
			var atlas := AtlasTexture.new()
			atlas.atlas = texture
			atlas.region = Rect2(i * 128, 0, 128, 128)
			frames.add_frame(anim_name, atlas)
	return frames

func _show_main_menu() -> void:
	current_mode = "menu"
	_clear_world()
	_clear_ui()
	var panel := _make_panel(Vector2(1140, 660), Vector2(70, 30))
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 26)
	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 9)
	margin.add_child(layout)
	var title := _make_label("STARFALL", 58, Color(0.86, 0.97, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(title)
	var subtitle := _make_label("SHADOWS OF THE LAST LIGHT     /     FIVE CHAPTERS", 15, Color(0.28, 0.91, 1.0))
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(subtitle)
	var story := _make_label("The Starwell is broken. The city has forgotten the sun. Choose your warrior, gather the lost seals, and bring the dawn home.", 17, Color(0.76, 0.83, 0.94))
	story.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	story.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	layout.add_child(story)
	var select_title := _make_label("CHOOSE YOUR WARRIOR", 17, Color(1.0, 0.73, 0.35))
	select_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(select_title)
	var cards := HBoxContainer.new()
	cards.alignment = BoxContainer.ALIGNMENT_CENTER
	cards.add_theme_constant_override("separation", 16)
	layout.add_child(cards)
	var actor_names := ["Fighter", "Samurai", "Shinobi"]
	for index in range(actor_names.size()):
		var name: String = actor_names[index]
		var card := Button.new()
		card.custom_minimum_size = Vector2(255, 194)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.focus_mode = Control.FOCUS_NONE
		_style_button(card, name == character_name)
		cards.add_child(card)
		var contents := VBoxContainer.new()
		contents.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		contents.offset_left = 10
		contents.offset_right = -10
		contents.offset_top = 6
		contents.offset_bottom = -6
		contents.mouse_filter = Control.MOUSE_FILTER_IGNORE
		contents.alignment = BoxContainer.ALIGNMENT_CENTER
		contents.add_theme_constant_override("separation", 4)
		card.add_child(contents)
		var preview_holder := CenterContainer.new()
		preview_holder.custom_minimum_size = Vector2(0, 88)
		contents.add_child(preview_holder)
		var preview := TextureRect.new()
		var idle_texture := load("res://assets/characters/%s/Idle.png" % name) as Texture2D
		var first_frame := AtlasTexture.new()
		first_frame.atlas = idle_texture
		first_frame.region = Rect2(0, 0, 128, 128)
		preview.texture = first_frame
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		preview.custom_minimum_size = Vector2(88, 88)
		preview_holder.add_child(preview)
		var info: Dictionary = CHARACTER_DATA[name]
		var card_title := _make_label(String(info["title"]), 19, Color(0.94, 0.98, 1.0))
		card_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		contents.add_child(card_title)
		var detail := _make_label(String(info["sub"]), 13, Color(0.58, 0.70, 0.81))
		detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		contents.add_child(detail)
		card.pressed.connect(_select_character.bind(name))
	var difficulty_heading := _make_label("DIFFICULTY", 15, Color(1.0, 0.73, 0.35))
	difficulty_heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(difficulty_heading)
	var difficulty_row := HBoxContainer.new()
	difficulty_row.alignment = BoxContainer.ALIGNMENT_CENTER
	difficulty_row.add_theme_constant_override("separation", 12)
	layout.add_child(difficulty_row)
	for i in range(DIFFICULTIES.size()):
		var button := Button.new()
		button.text = "%s  ·  %s" % [DIFFICULTIES[i], DIFFICULTY_INFO[i]]
		button.custom_minimum_size = Vector2(280, 42)
		button.focus_mode = Control.FOCUS_NONE
		_style_button(button, difficulty_index == i)
		difficulty_row.add_child(button)
		button.pressed.connect(_select_difficulty.bind(i))
	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override("separation", 14)
	layout.add_child(actions)
	var begin := _make_action_button("BEGIN THE JOURNEY", Color(0.05, 0.72, 0.82), Vector2(270, 52))
	actions.add_child(begin)
	begin.pressed.connect(_begin_new_journey)
	if unlocked_chapter > 0:
		var resume := _make_action_button("CONTINUE  ·  CHAPTER %02d" % (unlocked_chapter + 1), Color(0.78, 0.24, 0.55), Vector2(270, 52))
		actions.add_child(resume)
		resume.pressed.connect(_continue_journey)
	var touch_toggle := _make_action_button("TOUCH CONTROLS  %s" % ("ON" if touch_controls_enabled else "OFF"), Color(0.20, 0.36, 0.55), Vector2(230, 52))
	actions.add_child(touch_toggle)
	touch_toggle.pressed.connect(_toggle_touch_controls.bind(touch_toggle))
	var music_toggle := _make_action_button("MUSIC  %s" % ("ON" if music_enabled else "OFF"), Color(0.20, 0.36, 0.55), Vector2(180, 52))
	actions.add_child(music_toggle)
	music_toggle.pressed.connect(_toggle_music.bind(music_toggle))
	var footer := _make_label("ARROWS / A D MOVE    ·    X RUN    ·    SPACE JUMP    ·    J SWORD    ·    SHIFT DASH    ·    L NOVA    ·    Q GUARD", 13, Color(0.52, 0.63, 0.77))
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(footer)
	var credit := _make_label("DEVELOPED BY HAMD UR RAHMAN   ·   FIVE CHAPTERS   ·   PLEASE RATE ON ITCH.IO IF YOU ENJOY THE GAME", 13, Color(0.35, 0.60, 0.76))
	credit.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(credit)

func _show_chapter_intro() -> void:
	current_mode = "story"
	_clear_ui()
	var data: Dictionary = CHAPTERS[current_chapter]
	var panel := _make_panel(Vector2(930, 535), Vector2(175, 92))
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 38)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 18)
	margin.add_child(box)
	var eyebrow := _make_label("CHAPTER %02d / %02d   ·   %s" % [current_chapter + 1, CHAPTERS.size(), String(data["place"])], 15, Color(0.29, 0.93, 1.0))
	box.add_child(eyebrow)
	var title := _make_label(String(data["title"]), 44, Color(0.95, 0.98, 1.0))
	box.add_child(title)
	var narrative := _make_label(String(data["story"]), 21, Color(0.75, 0.83, 0.93))
	narrative.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(narrative)
	var objective := _make_label("OBJECTIVE   Collect any 4 of 6 star seals. Reach the gate.", 16, Color(1.0, 0.73, 0.35))
	box.add_child(objective)
	var tactic := _make_label(String(data["tactic"]), 15, Color(0.43, 0.89, 0.82))
	tactic.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(tactic)
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(spacer)
	var start := _make_action_button("ENTER THE CHAPTER", Color(0.05, 0.72, 0.82), Vector2(260, 54))
	box.add_child(start)
	start.pressed.connect(_start_chapter)

func _begin_new_journey() -> void:
	current_chapter = 0
	unlocked_chapter = 0
	saved_checkpoint_chapter = -1
	saved_checkpoint_x = 80.0
	total_score = 0
	deaths_this_run = 0
	_save_progress()
	_show_chapter_intro()

func _continue_journey() -> void:
	current_chapter = clampi(unlocked_chapter, 0, CHAPTERS.size() - 1)
	_show_chapter_intro()

func _select_character(name: String) -> void:
	character_name = name
	_save_progress()
	_show_main_menu()

func _select_difficulty(index: int) -> void:
	difficulty_index = index
	_save_progress()
	_show_main_menu()

func _toggle_touch_controls(button: Button) -> void:
	touch_controls_enabled = not touch_controls_enabled
	_save_progress()
	_show_main_menu()

func _restart_chapter() -> void:
	if saved_checkpoint_chapter == current_chapter:
		saved_checkpoint_chapter = -1
		saved_checkpoint_x = 80.0
		_save_progress()
	_start_chapter()

func _start_chapter() -> void:
	current_mode = "play"
	lives = [5, 3, 2][difficulty_index]
	level_complete = false
	shard_count = 0
	chapter_score = 0
	elapsed_time = 0.0
	combo_count = 0
	focus = 100.0
	invulnerability = 0.0
	attack_timer = 0.0
	attack_cooldown = 0.0
	dash_timer = 0.0
	dash_cooldown = 0.0
	checkpoint_x = saved_checkpoint_x if saved_checkpoint_chapter == current_chapter else 80.0
	checkpoint_positions = [2130.0, 4630.0]
	_clear_world()
	world_root = Node2D.new()
	world_root.name = "World"
	add_child(world_root)
	platform_rects.clear()
	ground_rects.clear()
	hazard_rects.clear()
	bounce_pad_rects.clear()
	var ground_x_offsets: Array = CHAPTER_GROUND_X[current_chapter]
	var ground_y_offsets: Array = CHAPTER_GROUND_Y[current_chapter]
	for i in range(GROUND_LAYOUT.size()):
		var ground: Rect2 = GROUND_LAYOUT[i]
		ground.position = Vector2(
			ground.position.x + float(ground_x_offsets[i]),
			clampf(ground.position.y + float(ground_y_offsets[i]), 500.0, 650.0)
		)
		ground_rects.append(ground)
		platform_rects.append(ground)
		_create_platform(ground, true)
	var float_y_offsets: Array = CHAPTER_FLOAT_Y[current_chapter]
	for i in range(FLOAT_LAYOUT.size()):
		var floating: Rect2 = FLOAT_LAYOUT[i]
		floating.position = Vector2(floating.position.x, floating.position.y + float(float_y_offsets[i]))
		var overlapping_floor_y := INF
		for ground in ground_rects:
			var overlaps_x := floating.position.x < ground.position.x + ground.size.x and floating.position.x + floating.size.x > ground.position.x
			if overlaps_x:
				overlapping_floor_y = minf(overlapping_floor_y, ground.position.y)
		if overlapping_floor_y < INF:
			# Keep a full character-height of clearance under every roof platform.
			floating.position.y = minf(floating.position.y, overlapping_floor_y - 124.0)
		platform_rects.append(floating)
		_create_platform(floating, false)
	_create_hero()
	_create_shards()
	_create_hazards()
	_create_bounce_pads()
	_create_exit()
	_create_enemies()
	_build_game_hud()
	_update_game_hud()
	queue_redraw()

func _create_platform(rect: Rect2, is_ground: bool) -> void:
	var body := StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 1
	body.position = rect.position + rect.size * 0.5
	var shape_node := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	shape_node.shape = shape
	body.add_child(shape_node)
	body.set_meta("ground", is_ground)
	world_root.add_child(body)

func _create_hero() -> void:
	var stats: Dictionary = CHARACTER_DATA[character_name]
	max_health = int(stats["hp"])
	health = max_health
	lives = [5, 3, 2][difficulty_index]
	hero = CharacterBody2D.new()
	hero.name = "Hero"
	hero.position = Vector2(90, _ground_y_at(90.0) - 36.0)
	hero.collision_layer = 1
	hero.collision_mask = 1
	var collision := CollisionShape2D.new()
	var capsule := CapsuleShape2D.new()
	capsule.radius = 17.0
	capsule.height = 68.0
	collision.shape = capsule
	collision.position.y = 0
	hero.add_child(collision)
	hero_sprite = AnimatedSprite2D.new()
	hero_sprite.sprite_frames = sprite_frames_cache[character_name]
	hero_sprite.scale = Vector2(1.65, 1.65)
	hero_sprite.position = Vector2(0, -74)
	hero_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	hero_sprite.play("idle")
	hero.add_child(hero_sprite)
	hero_camera = Camera2D.new()
	hero_camera.position = Vector2(205, -68)
	hero_camera.position_smoothing_enabled = true
	hero_camera.position_smoothing_speed = 5.5
	hero_camera.limit_left = 0
	hero_camera.limit_right = int(WORLD_WIDTH)
	hero_camera.limit_top = 0
	hero_camera.limit_bottom = 720
	hero.add_child(hero_camera)
	world_root.add_child(hero)

func _create_shards() -> void:
	for i in range(SHARD_LAYOUT.size()):
		var position: Vector2 = SHARD_LAYOUT[i] + Vector2(float(CHAPTER_SHARD_X[current_chapter][i]), float(((i + current_chapter) % 3) - 1) * 14.0)
		var area := Area2D.new()
		area.name = "StarSeal_%02d" % (i + 1)
		area.position = position + Vector2(0, (current_chapter % 2) * 18)
		area.set_meta("base_y", area.position.y)
		area.set_meta("phase", float(i) * 1.23)
		area.collision_layer = 0
		area.collision_mask = 1
		area.monitoring = true
		var collision := CollisionShape2D.new()
		var circle := CircleShape2D.new()
		circle.radius = 28
		collision.shape = circle
		area.add_child(collision)
		var sprite := Sprite2D.new()
		sprite.texture = load(STAR_TEXTURE_PATH)
		sprite.scale = Vector2(0.065, 0.065)
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		area.add_child(sprite)
		area.body_entered.connect(_on_shard_body_entered.bind(area))
		world_root.add_child(area)
		shard_areas.append(area)

func _create_exit() -> void:
	var gate := Area2D.new()
	gate.name = "StarwellGate"
	gate.position = Vector2(WORLD_WIDTH - 95, 550)
	gate.collision_layer = 0
	gate.collision_mask = 1
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(90, 170)
	collision.shape = shape
	gate.add_child(collision)
	gate.body_entered.connect(_on_gate_entered)
	world_root.add_child(gate)

func _create_hazards() -> void:
	var hazard_count := clampi(2 + current_chapter + difficulty_index, 2, HAZARD_X.size())
	for i in range(hazard_count):
		var x: float = HAZARD_X[i]
		var floor_y := _ground_y_at(x)
		var hazard := Area2D.new()
		hazard.position = Vector2(x, floor_y - 13.0)
		hazard.collision_layer = 0
		hazard.collision_mask = 1
		var collision := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = Vector2(86.0, 42.0)
		collision.shape = shape
		hazard.add_child(collision)
		hazard.body_entered.connect(_on_hazard_entered)
		world_root.add_child(hazard)
		hazard_rects.append(Rect2(x - 43.0, floor_y - 34.0, 86.0, 34.0))

func _on_hazard_entered(body: Node2D) -> void:
	if body != hero or invulnerability > 0.0:
		return
	_hurt_hero(1, -1.0 if facing > 0.0 else 1.0)
	_show_toast("WATCH YOUR STEP", 0.8)

func _create_bounce_pads() -> void:
	for x in BOUNCE_PAD_X:
		var floor_y := _ground_y_at(x)
		var pad := Area2D.new()
		pad.name = "MoonSpring"
		pad.position = Vector2(x, floor_y - 14.0)
		pad.collision_layer = 0
		pad.collision_mask = 1
		var collision := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = Vector2(94.0, 46.0)
		collision.shape = shape
		pad.add_child(collision)
		pad.body_entered.connect(_on_bounce_pad_entered)
		world_root.add_child(pad)
		bounce_pad_rects.append(Rect2(x - 47.0, floor_y - 24.0, 94.0, 20.0))

func _on_bounce_pad_entered(body: Node2D) -> void:
	if body != hero or hero == null or hero.velocity.y < 0.0:
		return
	hero.velocity.y = -1030.0
	coyote_timer = 0.0
	jump_buffer = 0.0
	_spawn_burst(hero.global_position + Vector2(0, 8), Color(0.32, 1.0, 0.84), 20)
	_show_toast("MOON SPRING!  ·  BOUNCE TO THE HIGH ROAD", 1.0)
	_play_hero_animation("jump")

func _create_enemies() -> void:
	enemies.clear()
	var spawn_x := [690.0, 1420.0, 2310.0, 3150.0, 3850.0, 4850.0, 5520.0]
	var count := spawn_x.size()
	if difficulty_index == 0:
		count -= 2
	for i in range(spawn_x.size()):
		if difficulty_index == 0 and i >= count and not (current_chapter == 3 and i == 5):
			continue
		var x: float = spawn_x[i]
		var ground_y := _ground_y_at(x)
		var warden := current_chapter == 3 and i == 5
		var actor := "Samurai" if warden or i % 2 == 1 else "Shinobi"
		var body := CharacterBody2D.new()
		body.name = "Iron_Warden" if warden else "Starless_%02d" % (i + 1)
		if warden:
			x = 5050.0
			ground_y = _ground_y_at(x)
		body.position = Vector2(x, ground_y - (48.0 if warden else 34.0))
		body.collision_layer = 0
		body.collision_mask = 1
		var capsule := CapsuleShape2D.new()
		capsule.radius = 26.0 if warden else 17.0
		capsule.height = 92.0 if warden else 64.0
		var shape_node := CollisionShape2D.new()
		shape_node.shape = capsule
		body.add_child(shape_node)
		var sprite := AnimatedSprite2D.new()
		sprite.sprite_frames = sprite_frames_cache[actor]
		sprite.scale = Vector2(1.95, 1.95) if warden else Vector2(1.5, 1.5)
		sprite.position = Vector2(0, -79 if warden else -64)
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.play("run")
		body.add_child(sprite)
		world_root.add_child(body)
		var health_points := (8 if difficulty_index == 0 else (12 if difficulty_index == 1 else 16)) if warden else (1 if difficulty_index == 0 else (3 if difficulty_index == 2 else 2))
		var movement_speed := (105.0 + float(difficulty_index) * 12.0) if warden else (70.0 + float(current_chapter) * 7.0 + float(difficulty_index) * 16.0)
		enemies.append({"node": body, "sprite": sprite, "hp": health_points, "max_hp": health_points, "speed": movement_speed, "dir": -1.0, "left": x - (170.0 if warden else 130.0), "right": x + (170.0 if warden else 130.0), "attack": rng.randf_range(0.2, 0.8), "actor": actor, "boss": warden})
	if current_chapter == CHAPTERS.size() - 1:
		_create_final_boss()

func _create_final_boss() -> void:
	var x := 5890.0
	var body := CharacterBody2D.new()
	body.name = "The Starless"
	body.position = Vector2(x, _ground_y_at(x) - 55.0)
	body.collision_layer = 0
	body.collision_mask = 1
	var capsule := CapsuleShape2D.new()
	capsule.radius = 27.0
	capsule.height = 108.0
	var shape_node := CollisionShape2D.new()
	shape_node.shape = capsule
	body.add_child(shape_node)
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = sprite_frames_cache["Samurai"]
	sprite.scale = Vector2(2.25, 2.25)
	sprite.position = Vector2(0, -90)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.play("idle")
	body.add_child(sprite)
	world_root.add_child(body)
	var boss_hp := 9 if difficulty_index == 0 else (17 if difficulty_index == 2 else 13)
	enemies.append({"node": body, "sprite": sprite, "hp": boss_hp, "max_hp": boss_hp, "speed": 120.0, "dir": -1.0, "left": x - 180.0, "right": x + 140.0, "attack": 0.3, "actor": "Samurai", "boss": true})

func _ground_y_at(x: float) -> float:
	for rect in ground_rects:
		if x >= rect.position.x and x <= rect.position.x + rect.size.x:
			return rect.position.y
	return 620.0

func _on_shard_body_entered(body: Node2D, area: Area2D) -> void:
	if body != hero or not is_instance_valid(area):
		return
	shard_count += 1
	chapter_score += 100
	total_score += 100
	focus = minf(100.0, focus + 20.0)
	_spawn_burst(area.global_position, CHAPTERS[current_chapter]["accent"], 16)
	area.queue_free()
	shard_areas.erase(area)
	_show_toast("STAR SEAL FOUND   +100", 1.0)
	_update_game_hud()

func _on_gate_entered(body: Node2D) -> void:
	if body != hero:
		return
	_try_finish_gate()

func _try_finish_gate() -> void:
	if shard_count < SHARDS_REQUIRED:
		_show_toast("THE GATE NEEDS %d MORE STAR SEALS" % (SHARDS_REQUIRED - shard_count), 1.5)
		return
	if current_chapter >= 3 and _boss_is_alive():
		_show_toast("THE WARDEN STILL HOLDS THE CITADEL" if current_chapter == 3 else "THE STARLESS STILL BLOCKS THE WAY", 1.2)
		return
	_complete_chapter()

func _boss_is_alive() -> bool:
	for enemy in enemies:
		if bool(enemy.get("boss", false)):
			return true
	return false

func _perform_attack(special: bool) -> void:
	if attack_cooldown > 0.0:
		return
	var damage := int(CHARACTER_DATA[character_name]["damage"])
	var attack_name := "attack_%d" % ((combo_count % 3) + 1)
	var reach := 102.0
	if special:
		if focus < 48.0:
			_show_toast("NOT ENOUGH FOCUS", 0.8)
			return
		focus -= 48.0
		attack_name = "attack_3"
		reach = 165.0
		damage += 2
		_spawn_burst(hero.global_position + Vector2(50 * facing, -34), Color(1.0, 0.20, 0.72), 26)
		attack_cooldown = 0.55
	else:
		combo_count += 1
		combo_timer = 1.0
		attack_cooldown = 0.34
	attack_timer = 0.34
	_play_hero_animation(attack_name)
	var hit_count := 0
	for i in range(enemies.size() - 1, -1, -1):
		var enemy: Dictionary = enemies[i]
		var enemy_node: CharacterBody2D = enemy["node"]
		var dx := enemy_node.global_position.x - hero.global_position.x
		var dy := absf(enemy_node.global_position.y - hero.global_position.y)
		if absf(dx) <= reach and dy < 100.0 and signf(dx) == facing:
			enemy["hp"] = int(enemy["hp"]) - damage
			enemy_node.velocity.x = facing * 260.0
			enemy_node.velocity.y = -110.0
			_spawn_burst(enemy_node.global_position + Vector2(0, -25), Color(0.25, 0.93, 1.0), 10)
			hit_count += 1
			if int(enemy["hp"]) <= 0:
				chapter_score += 250
				total_score += 250
				combo_count += 1
				combo_timer = 1.8
				if combo_count >= 3:
					var bonus := combo_count * 35
					chapter_score += bonus
					total_score += bonus
					_show_toast("%d HIT COMBO   +%d" % [combo_count, bonus], 0.9)
				enemy_node.queue_free()
				enemies.remove_at(i)
	if hit_count == 0:
		if not special:
			focus = minf(100.0, focus + 4.0)
	else:
		focus = minf(100.0, focus + float(hit_count) * 5.0)
	_update_game_hud()

func _try_dash() -> void:
	if dash_cooldown > 0.0 or focus < 22.0:
		return
	focus -= 22.0
	dash_timer = 0.18
	dash_cooldown = 0.65
	invulnerability = maxf(invulnerability, 0.22)
	_spawn_burst(hero.global_position + Vector2(0, -25), Color(0.16, 0.86, 1.0), 12)

func _update_enemies(delta: float) -> void:
	for i in range(enemies.size() - 1, -1, -1):
		var enemy: Dictionary = enemies[i]
		var body: CharacterBody2D = enemy["node"]
		var sprite: AnimatedSprite2D = enemy["sprite"]
		var distance := hero.global_position.x - body.global_position.x
		var direction := signf(distance)
		var active := absf(distance) < 360.0
		enemy["attack"] = maxf(0.0, float(enemy["attack"]) - delta)
		if absf(distance) < 65.0 and absf(hero.global_position.y - body.global_position.y) < 82.0:
			body.velocity.x = 0.0
			if float(enemy["attack"]) <= 0.0:
				if invulnerability <= 0.0:
					_hurt_hero(1 + (1 if difficulty_index == 2 else 0), -1.0 if distance < 0.0 else 1.0)
				enemy["attack"] = 0.85
				sprite.flip_h = direction < 0.0
				sprite.play("attack_1")
		elif active:
			body.velocity.x = direction * float(enemy["speed"])
			if direction != 0.0:
				sprite.flip_h = direction < 0.0
			sprite.play("run")
		else:
			body.velocity.x = float(enemy["dir"]) * float(enemy["speed"])
			if body.position.x < float(enemy["left"]): enemy["dir"] = 1.0
			if body.position.x > float(enemy["right"]): enemy["dir"] = -1.0
			sprite.flip_h = float(enemy["dir"]) < 0.0
			sprite.play("walk")
		var enemy_gravity := 0.72 if current_chapter == 2 else 1.0
		body.velocity.y = minf(body.velocity.y + GRAVITY * enemy_gravity * delta, 1150.0)
		body.move_and_slide()
		if body.position.y > 920.0:
			body.queue_free()
			enemies.remove_at(i)

func _hurt_hero(amount: int, direction: float) -> void:
	if invulnerability > 0.0:
		return
	var damage := amount
	if shield_held and focus > 0.0:
		damage = maxi(1, int(ceil(float(amount) * 0.35)))
		focus = maxf(0.0, focus - 14.0)
	health -= damage
	invulnerability = 1.0
	knockback_timer = 0.22
	knockback_x = direction * 460.0
	if hero != null:
		hero.velocity.y = -350.0
		_play_hero_animation("hurt")
	_spawn_burst(hero.global_position + Vector2(0, -25), Color(1.0, 0.22, 0.27), 12)
	if health <= 0:
		lives -= 1
		deaths_this_run += 1
		if lives <= 0:
			_show_game_over()
		else:
			_respawn_at_checkpoint()
	_update_game_hud()

func _respawn_at_checkpoint() -> void:
	if hero == null:
		return
	hero.position = Vector2(checkpoint_x, _ground_y_at(checkpoint_x) - 36)
	hero.velocity = Vector2.ZERO
	health = max_health
	invulnerability = 1.45
	dash_timer = 0.0
	knockback_timer = 0.0
	_show_toast("BACK TO THE LAST BEACON   ·   %d LIVES LEFT" % lives, 1.4)

func _update_checkpoints() -> void:
	for checkpoint in checkpoint_positions:
		if hero.position.x >= checkpoint and checkpoint_x < checkpoint:
			checkpoint_x = checkpoint
			saved_checkpoint_chapter = current_chapter
			saved_checkpoint_x = checkpoint_x
			_save_progress()
			_show_toast("BEACON LIT   ·   CHECKPOINT SAVED", 1.2)

func _complete_chapter() -> void:
	if level_complete:
		return
	level_complete = true
	current_mode = "chapter_clear"
	unlocked_chapter = mini(CHAPTERS.size() - 1, maxi(unlocked_chapter, current_chapter + 1))
	if best_time <= 0.0 or elapsed_time < best_time:
		best_time = elapsed_time
	_save_progress()
	_show_chapter_clear()

func _show_chapter_clear() -> void:
	_clear_ui()
	var last := current_chapter == CHAPTERS.size() - 1
	var panel := _make_panel(Vector2(900, 555), Vector2(190, 82))
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 38)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 18)
	margin.add_child(box)
	var headline := _make_label("THE SEALS ANSWERED" if not last else "THE DAWN RETURNS", 42, Color(0.90, 0.98, 1.0))
	box.add_child(headline)
	var chapter: Dictionary = CHAPTERS[current_chapter]
	var prose := String(chapter["place"]) + " is behind you. "
	if last:
		prose += "You defeated the Starless and restored the Starwell. One by one, windows across the city fill with gold. The keeper lays down their blade, and the city sees the dawn again."
	else:
		prose += "One seal burns brighter than before. The road ahead rises into " + String(CHAPTERS[current_chapter + 1]["place"]) + "."
	var story := _make_label(prose, 22, Color(0.75, 0.84, 0.95))
	story.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(story)
	box.add_child(_make_label("CHAPTER SCORE   %06d     ·     RUN TIME   %s" % [chapter_score, _time_string(elapsed_time)], 17, Color(1.0, 0.76, 0.36)))
	box.add_child(_make_label("TOTAL SCORE   %07d     ·     BEST TIME   %s" % [total_score, _time_string(best_time)], 15, Color(0.54, 0.72, 0.85)))
	var rating_text := "Loved the finale? Please rate Starfall on itch.io. It helps indie developers a lot." if last else "Enjoying Starfall? If you found it on itch.io, please leave a rating when you can."
	var rating := _make_label(rating_text, 16, Color(1.0, 0.80, 0.36))
	rating.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(rating)
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(spacer)
	var continue_button := _make_action_button("RETURN TO THE CITY" if last else "CONTINUE THE STORY", Color(0.05, 0.72, 0.82), Vector2(300, 54))
	box.add_child(continue_button)
	if last:
		continue_button.pressed.connect(_show_main_menu)
	else:
		continue_button.pressed.connect(_advance_chapter)

func _advance_chapter() -> void:
	current_chapter = mini(current_chapter + 1, CHAPTERS.size() - 1)
	_show_chapter_intro()

func _show_game_over() -> void:
	current_mode = "game_over"
	if hero_sprite != null and hero_sprite.sprite_frames.has_animation("dead"):
		hero_sprite.play("dead")
	_clear_ui()
	var panel := _make_panel(Vector2(820, 480), Vector2.ZERO)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -410
	panel.offset_top = -240
	panel.offset_right = 410
	panel.offset_bottom = 240
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 36)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 18)
	margin.add_child(box)
	var headline := _make_label("THE CITY GOES DARK", 40, Color(1.0, 0.46, 0.49))
	headline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(headline)
	var message := _make_label("The Starwell is still waiting. Your seals and chapter remain safe. Regroup and try again.", 20, Color(0.76, 0.82, 0.93))
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(message)
	var retry := _make_action_button("RISE AGAIN  ·  RESTART CHAPTER", Color(0.78, 0.24, 0.55), Vector2(360, 52))
	box.add_child(retry)
	retry.pressed.connect(_restart_chapter)
	var menu := _make_action_button("MAIN MENU", Color(0.16, 0.42, 0.59), Vector2(220, 48))
	box.add_child(menu)
	menu.pressed.connect(_show_main_menu)

func _show_pause() -> void:
	if current_mode != "play":
		return
	current_mode = "pause"
	_clear_ui()
	_build_hud_panel()
	var panel := _make_panel(Vector2(720, 460), Vector2(280, 132))
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 34)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 13)
	margin.add_child(box)
	box.add_child(_make_label("PAUSED", 38, Color(0.85, 0.96, 1.0)))
	box.add_child(_make_label("The night can wait. Your journey is saved at the last beacon.", 16, Color(0.64, 0.75, 0.87)))
	var resume := _make_action_button("RETURN TO THE ROOFTOPS", Color(0.05, 0.72, 0.82), Vector2(300, 48))
	box.add_child(resume)
	resume.pressed.connect(_resume_game)
	var restart := _make_action_button("RESTART CHAPTER", Color(0.45, 0.28, 0.62), Vector2(300, 46))
	box.add_child(restart)
	restart.pressed.connect(_restart_chapter)
	var touch := _make_action_button("TOUCH CONTROLS  %s" % ("ON" if touch_controls_enabled else "OFF"), Color(0.20, 0.36, 0.55), Vector2(300, 46))
	box.add_child(touch)
	touch.pressed.connect(_toggle_touch_from_pause.bind(touch))
	var music := _make_action_button("MUSIC  %s" % ("ON" if music_enabled else "OFF"), Color(0.20, 0.36, 0.55), Vector2(300, 46))
	box.add_child(music)
	music.pressed.connect(_toggle_music.bind(music))
	var menu := _make_action_button("SAVE & RETURN TO MENU", Color(0.17, 0.30, 0.43), Vector2(300, 46))
	box.add_child(menu)
	menu.pressed.connect(_show_main_menu)

func _toggle_touch_from_pause(button: Button) -> void:
	touch_controls_enabled = not touch_controls_enabled
	_save_progress()
	_show_pause()

func _toggle_music(button: Button) -> void:
	music_enabled = not music_enabled
	if music_player != null:
		if music_enabled:
			music_player.play()
		else:
			music_player.stop()
	button.text = "MUSIC  %s" % ("ON" if music_enabled else "OFF")
	_save_progress()

func _resume_game() -> void:
	current_mode = "play"
	_build_game_hud()

func _build_game_hud() -> void:
	_clear_ui()
	_build_hud_panel()
	_build_status_hud()
	_build_journey_hud()
	if current_chapter >= CHAPTERS.size() - 2:
		_build_boss_hud()
	if touch_controls_enabled:
		_build_touch_controls()
	var toast := _make_label("", 18, Color(1.0, 0.90, 0.55))
	toast.name = "Toast"
	toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast.set_anchors_preset(Control.PRESET_CENTER_TOP)
	toast.offset_left = -440
	toast.offset_right = 440
	toast.offset_top = 270
	toast.offset_bottom = 312
	ui_root.add_child(toast)

func _build_hud_panel() -> void:
	var panel := _make_panel(Vector2(1220, 75), Vector2(24, 18))
	panel.anchor_left = 0
	panel.anchor_top = 0
	panel.anchor_right = 0
	panel.anchor_bottom = 0
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 14)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	row.alignment = BoxContainer.ALIGNMENT_BEGIN
	margin.add_child(row)
	var chapter_label := _make_label("ACT %02d  %s" % [current_chapter + 1, String(CHAPTERS[current_chapter]["title"])], 15, Color(0.35, 0.91, 1.0))
	chapter_label.name = "ChapterHUD"
	row.add_child(chapter_label)
	var focus_label := _make_label("", 14, Color(0.42, 0.93, 0.88))
	focus_label.name = "FocusHUD"
	row.add_child(focus_label)
	var score_label := _make_label("", 15, Color(0.84, 0.90, 0.98))
	score_label.name = "ScoreHUD"
	row.add_child(score_label)
	var pause := _make_action_button("Ⅱ", Color(0.20, 0.36, 0.55), Vector2(52, 50))
	pause.name = "PauseCornerButton"
	pause.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	pause.offset_left = -70
	pause.offset_top = 16
	pause.offset_right = -18
	pause.offset_bottom = 66
	pause.add_theme_font_size_override("font_size", 22)
	ui_root.add_child(pause)
	pause.pressed.connect(_show_pause)
	if not touch_controls_enabled:
		_build_control_legend()
	var watermark := _make_label("HAMD UR RAHMAN  ·  STARFALL", 12, Color(0.68, 0.78, 0.90, 0.72))
	watermark.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	watermark.offset_left = -260
	watermark.offset_top = -30
	watermark.offset_right = -22
	watermark.offset_bottom = -10
	watermark.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	ui_root.add_child(watermark)

func _build_control_legend() -> void:
	var panel := _make_panel(Vector2(236, 270), Vector2(VIEW_SIZE.x - 254.0, 112.0))
	panel.name = "ControlLegend"
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 12)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	margin.add_child(box)
	box.add_child(_make_label("FIELD GUIDE  /  CONTROLS", 14, Color(0.35, 0.91, 1.0)))
	var entries := [
		["A / D", "Move"], ["X", "Sprint"], ["SPACE", "Jump"],
		["J", "Sword combo"], ["SHIFT / K", "Dash"], ["L", "Nova special"], ["HOLD Q", "Guard"]
	]
	for entry in entries:
		var item := HBoxContainer.new()
		item.add_theme_constant_override("separation", 8)
		var key := _make_label(String(entry[0]), 12, Color(1.0, 0.78, 0.37))
		key.custom_minimum_size = Vector2(78, 24)
		key.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		item.add_child(key)
		var action := _make_label(String(entry[1]), 13, Color(0.77, 0.86, 0.96))
		action.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		item.add_child(action)
		box.add_child(item)

func _build_status_hud() -> void:
	var panel := _make_panel(Vector2(370, 84), Vector2(24, 104))
	panel.name = "StatusHUD"
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 12)
	var box := VBoxContainer.new()
	box.name = "StatusLines"
	box.add_theme_constant_override("separation", 3)
	margin.add_child(box)
	var health_label := _make_label("", 14, Color(0.89, 0.92, 1.0))
	health_label.name = "HealthHUD"
	box.add_child(health_label)
	var stars_label := _make_label("", 14, Color(1.0, 0.80, 0.36))
	stars_label.name = "StarsHUD"
	box.add_child(stars_label)

func _build_journey_hud() -> void:
	var panel := _make_panel(Vector2(450, 76), Vector2(415, 108))
	panel.name = "JourneyHUD"
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 10)
	var box := VBoxContainer.new()
	box.name = "JourneyLines"
	box.add_theme_constant_override("separation", 4)
	margin.add_child(box)
	var label := _make_label("", 13, Color(0.42, 0.93, 0.88))
	label.name = "ChapterProgressLabel"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(label)
	var bar := ProgressBar.new()
	bar.name = "ChapterProgressBar"
	bar.custom_minimum_size = Vector2(0, 17)
	bar.min_value = 0.0
	bar.max_value = 100.0
	bar.show_percentage = false
	var back := StyleBoxFlat.new()
	back.bg_color = Color(0.07, 0.12, 0.20)
	back.set_corner_radius_all(6)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color(0.16, 0.82, 0.90)
	fill.set_corner_radius_all(6)
	bar.add_theme_stylebox_override("background", back)
	bar.add_theme_stylebox_override("fill", fill)
	box.add_child(bar)

func _build_boss_hud() -> void:
	var panel := _make_panel(Vector2(450, 62), Vector2(415, 192))
	panel.name = "BossHUD"
	panel.visible = false
	ui_root.add_child(panel)
	var margin := _make_margin(panel, 9)
	var row := HBoxContainer.new()
	row.name = "BossLine"
	row.add_theme_constant_override("separation", 8)
	margin.add_child(row)
	var boss_name := _make_label("THE IRON WARDEN" if current_chapter == 3 else "THE STARLESS", 13, Color(1.0, 0.47, 0.53))
	boss_name.custom_minimum_size = Vector2(112, 0)
	row.add_child(boss_name)
	var bar := ProgressBar.new()
	bar.name = "BossBar"
	bar.custom_minimum_size = Vector2(232, 22)
	var boss_max := (16 if difficulty_index == 2 else (12 if difficulty_index == 1 else 8)) if current_chapter == 3 else (17 if difficulty_index == 2 else (13 if difficulty_index == 1 else 9))
	bar.max_value = boss_max
	bar.value = boss_max
	bar.show_percentage = false
	var back := StyleBoxFlat.new()
	back.bg_color = Color(0.16, 0.07, 0.11)
	back.set_corner_radius_all(5)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color(1.0, 0.22, 0.34)
	fill.set_corner_radius_all(5)
	bar.add_theme_stylebox_override("background", back)
	bar.add_theme_stylebox_override("fill", fill)
	row.add_child(bar)
	var hp_label := _make_label("", 13, Color(1.0, 0.84, 0.86))
	hp_label.name = "BossHPLabel"
	hp_label.custom_minimum_size = Vector2(62, 0)
	row.add_child(hp_label)

func _update_game_hud() -> void:
	if ui_root == null:
		return
	var focus_label := ui_root.find_child("FocusHUD", true, false) as Label
	var score_label := ui_root.find_child("ScoreHUD", true, false) as Label
	if focus_label != null:
		focus_label.text = "FOCUS %03d" % int(focus)
	if score_label != null:
		score_label.text = "%07d" % total_score
	var health_label := ui_root.find_child("HealthHUD", true, false) as Label
	var stars_label := ui_root.find_child("StarsHUD", true, false) as Label
	if health_label != null:
		health_label.text = "HEALTH  %d / %d" % [health, max_health]
	if stars_label != null:
		stars_label.text = "STARS  %d / %d COLLECTED  ·  %d MORE FOR GATE" % [shard_count, SHARDS_TOTAL, maxi(0, SHARDS_REQUIRED - shard_count)]
	var journey_label := ui_root.find_child("ChapterProgressLabel", true, false) as Label
	var journey_bar := ui_root.find_child("ChapterProgressBar", true, false) as ProgressBar
	if journey_label != null and journey_bar != null:
		var goal := WORLD_WIDTH - 180.0
		var progress_ratio := clampf((hero.position.x if hero != null else 0.0) / goal, 0.0, 1.0)
		journey_bar.value = progress_ratio * 100.0
		journey_label.text = "CHAPTER %02d / %02d   ·   %d%% COMPLETE   ·   %d%% LEFT" % [current_chapter + 1, CHAPTERS.size(), int(progress_ratio * 100.0), int((1.0 - progress_ratio) * 100.0)]
	var boss_panel := ui_root.find_child("BossHUD", true, false) as Control
	var boss_bar := ui_root.find_child("BossBar", true, false) as ProgressBar
	var boss_hp_label := ui_root.find_child("BossHPLabel", true, false) as Label
	var nearby_boss: Dictionary = {}
	if hero != null:
		for enemy in enemies:
			if not bool(enemy.get("boss", false)):
				continue
			var boss_node := enemy.get("node") as CharacterBody2D
			if is_instance_valid(boss_node) and absf(hero.global_position.x - boss_node.global_position.x) <= 480.0 and absf(hero.global_position.y - boss_node.global_position.y) <= 220.0:
				nearby_boss = enemy
				break
	var show_boss := not nearby_boss.is_empty()
	if boss_panel != null:
		boss_panel.visible = show_boss
	if boss_bar != null:
		boss_bar.visible = show_boss
		if show_boss:
			boss_bar.max_value = float(nearby_boss.get("max_hp", 13))
			boss_bar.value = float(nearby_boss.get("hp", 0))
	if boss_hp_label != null:
		boss_hp_label.visible = show_boss
		if show_boss:
			boss_hp_label.text = "%d / %d" % [int(nearby_boss.get("hp", 0)), int(nearby_boss.get("max_hp", 13))]
	var toast := ui_root.find_child("Toast", true, false) as Label
	if toast != null:
		toast.text = toast_text if toast_timer > 0.0 else ""

func _build_touch_controls() -> void:
	var size := get_viewport_rect().size
	_build_virtual_joystick(size)
	var run_button := _make_touch_button("RUN", "run", Vector2(34, size.y - 240), Vector2(112, 46))
	var guard_button := _make_touch_button("GUARD", "guard", Vector2(size.x - 220, size.y - 290), Vector2(70, 62))
	var special_button := _make_touch_button("NOVA", "special", Vector2(size.x - 220, size.y - 208), Vector2(78, 72))
	var dash_button := _make_touch_button("DASH", "dash", Vector2(size.x - 118, size.y - 238), Vector2(72, 72))
	var attack_button := _make_touch_button("SLASH", "attack", Vector2(size.x - 220, size.y - 96), Vector2(82, 74))
	var jump_button := _make_touch_button("JUMP", "jump", Vector2(size.x - 118, size.y - 142), Vector2(96, 96))
	for button in [run_button, guard_button, special_button, dash_button, attack_button, jump_button]:
		ui_root.add_child(button)

func _build_virtual_joystick(view_size: Vector2) -> void:
	joystick_radius = 52.0
	joystick_base = Panel.new()
	joystick_base.name = "VirtualJoystickBase"
	joystick_base.position = Vector2(24, view_size.y - 170)
	joystick_base.size = Vector2(142, 142)
	joystick_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var base_style := StyleBoxFlat.new()
	base_style.bg_color = Color(0.04, 0.09, 0.16, 0.58)
	base_style.border_color = Color(0.30, 0.82, 0.94, 0.68)
	base_style.set_border_width_all(2)
	base_style.set_corner_radius_all(71)
	joystick_base.add_theme_stylebox_override("panel", base_style)
	ui_root.add_child(joystick_base)
	joystick_center = joystick_base.position + joystick_base.size * 0.5
	joystick_knob = Panel.new()
	joystick_knob.name = "VirtualJoystickKnob"
	joystick_knob.size = Vector2(58, 58)
	joystick_knob.position = joystick_center - joystick_base.position - joystick_knob.size * 0.5
	joystick_knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var knob_style := StyleBoxFlat.new()
	knob_style.bg_color = Color(0.18, 0.59, 0.77, 0.88)
	knob_style.border_color = Color(0.66, 0.94, 1.0, 0.95)
	knob_style.set_border_width_all(2)
	knob_style.set_corner_radius_all(29)
	joystick_knob.add_theme_stylebox_override("panel", knob_style)
	joystick_base.add_child(joystick_knob)

func _update_virtual_joystick(screen_position: Vector2) -> void:
	if joystick_base == null or joystick_knob == null:
		return
	var offset := (screen_position - joystick_center).limit_length(joystick_radius)
	joystick_knob.position = joystick_base.size * 0.5 + offset - joystick_knob.size * 0.5
	touch_state["left"] = offset.x < -joystick_radius * 0.20
	touch_state["right"] = offset.x > joystick_radius * 0.20

func _release_virtual_joystick() -> void:
	joystick_touch_index = -1
	touch_state["left"] = false
	touch_state["right"] = false
	if joystick_base != null and joystick_knob != null:
		joystick_knob.position = (joystick_base.size - joystick_knob.size) * 0.5

func _make_touch_button(text: String, action: String, position: Vector2, size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.position = position
	button.custom_minimum_size = size
	button.size = size
	button.focus_mode = Control.FOCUS_NONE
	button.modulate = Color(0.82, 0.93, 1.0, 0.82)
	_style_button(button, action in ["jump", "attack"])
	button.add_theme_font_size_override("font_size", 15)
	button.button_down.connect(_touch_pressed.bind(action))
	button.button_up.connect(_touch_released.bind(action))
	return button

func _touch_pressed(action: String) -> void:
	touch_state[action] = true
	if action == "jump": jump_requested = true
	if action == "attack": attack_requested = true
	if action == "dash": dash_requested = true
	if action == "special": special_requested = true
	if action == "guard":
		touch_state["guard"] = true
		shield_held = true
	if action == "run": run_held = true

func _touch_released(action: String) -> void:
	touch_state[action] = false
	if action == "guard": shield_held = false
	if action == "run": run_held = false

func _clear_ui() -> void:
	_release_virtual_joystick()
	joystick_base = null
	joystick_knob = null
	if ui_root == null:
		return
	for child in ui_root.get_children():
		ui_root.remove_child(child)
		child.free()

func _clear_world() -> void:
	if is_instance_valid(world_root):
		remove_child(world_root)
		world_root.free()
	world_root = null
	hero = null
	hero_sprite = null
	hero_camera = null
	enemies.clear()
	shard_areas.clear()
	particles.clear()
	platform_rects.clear()
	shard_count = 0
	queue_redraw()

func _make_panel(size: Vector2, position: Vector2) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.position = position
	panel.size = size
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.045, 0.10, 0.94)
	style.border_color = Color(0.12, 0.50, 0.66, 0.75)
	style.set_border_width_all(2)
	style.set_corner_radius_all(14)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.55)
	style.shadow_size = 16
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _make_margin(parent: Control, amount: int) -> MarginContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", amount)
	margin.add_theme_constant_override("margin_right", amount)
	margin.add_theme_constant_override("margin_top", amount)
	margin.add_theme_constant_override("margin_bottom", amount)
	parent.add_child(margin)
	return margin

func _make_label(text: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.55))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 2)
	return label

func _make_action_button(text: String, accent: Color, min_size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = min_size
	button.focus_mode = Control.FOCUS_NONE
	_style_button(button, true, accent)
	button.add_theme_font_size_override("font_size", 16)
	return button

func _style_button(button: Button, selected: bool, accent: Color = Color(0.10, 0.60, 0.78)) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.055, 0.09, 0.17, 0.98)
	normal.border_color = accent if selected else Color(0.15, 0.26, 0.39, 1.0)
	normal.set_border_width_all(2 if selected else 1)
	normal.set_corner_radius_all(10)
	normal.content_margin_left = 12
	normal.content_margin_right = 12
	normal.content_margin_top = 8
	normal.content_margin_bottom = 8
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.09, 0.16, 0.27, 1.0)
	hover.border_color = accent
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	button.add_theme_color_override("font_color", Color(0.88, 0.95, 1.0))
	button.add_theme_color_override("font_hover_color", Color.WHITE)

func _show_toast(message: String, duration: float) -> void:
	toast_text = message
	toast_timer = duration
	_update_game_hud()

func _time_string(seconds: float) -> String:
	var whole := int(seconds)
	return "%02d:%02d" % [floori(whole / 60.0), whole % 60]

func _load_save() -> void:
	var err := save_config.load(SAVE_PATH)
	if err == OK:
		unlocked_chapter = int(save_config.get_value("story", "unlocked", 0))
		best_time = float(save_config.get_value("story", "best_time", 0.0))
		saved_checkpoint_chapter = int(save_config.get_value("story", "checkpoint_chapter", -1))
		saved_checkpoint_x = float(save_config.get_value("story", "checkpoint_x", 80.0))
		character_name = String(save_config.get_value("settings", "character", "Fighter"))
		difficulty_index = int(save_config.get_value("settings", "difficulty", 1))
		touch_controls_enabled = bool(save_config.get_value("settings", "touch", DisplayServer.is_touchscreen_available() or OS.has_feature("web")))
		music_enabled = bool(save_config.get_value("settings", "music", true))
	if not CHARACTER_DATA.has(character_name): character_name = "Fighter"
	difficulty_index = clampi(difficulty_index, 0, DIFFICULTIES.size() - 1)

func _save_progress() -> void:
	save_config.set_value("story", "unlocked", unlocked_chapter)
	save_config.set_value("story", "best_time", best_time)
	save_config.set_value("story", "checkpoint_chapter", saved_checkpoint_chapter)
	save_config.set_value("story", "checkpoint_x", saved_checkpoint_x)
	save_config.set_value("settings", "character", character_name)
	save_config.set_value("settings", "difficulty", difficulty_index)
	save_config.set_value("settings", "touch", touch_controls_enabled)
	save_config.set_value("settings", "music", music_enabled)
	save_config.save(SAVE_PATH)

func _spawn_burst(position: Vector2, color: Color, amount: int) -> void:
	for i in range(amount):
		var angle := rng.randf_range(0.0, TAU)
		var speed := rng.randf_range(90.0, 320.0)
		particles.append({"position": position, "velocity": Vector2(cos(angle), sin(angle)) * speed, "life": rng.randf_range(0.22, 0.55), "max": 0.55, "color": color, "size": rng.randf_range(2.0, 6.0)})

func _update_particles(delta: float) -> void:
	for i in range(particles.size() - 1, -1, -1):
		var particle: Dictionary = particles[i]
		particle["position"] = Vector2(particle["position"]) + Vector2(particle["velocity"]) * delta
		particle["velocity"] = Vector2(particle["velocity"]) * 0.95
		particle["life"] = float(particle["life"]) - delta
		if float(particle["life"]) <= 0.0:
			particles.remove_at(i)

func _play_hero_animation(animation: String) -> void:
	if hero_sprite == null or not hero_sprite.sprite_frames.has_animation(animation):
		return
	if hero_sprite.animation != animation or not hero_sprite.is_playing():
		hero_sprite.play(animation)

func _update_hero_animation(horizontal: float) -> void:
	if hero_sprite == null:
		return
	hero_sprite.flip_h = facing < 0.0
	if invulnerability > 0.0:
		hero_sprite.modulate.a = 0.48 if int(Time.get_ticks_msec() / 90) % 2 == 0 else 1.0
	else:
		hero_sprite.modulate.a = 1.0
	if shield_held and focus > 0.0:
		focus = maxf(0.0, focus - 8.0 * get_physics_process_delta_time())
		_play_hero_animation("shield")
	elif dash_timer > 0.0:
		_play_hero_animation("run")
	elif attack_timer > 0.0:
		if not hero_sprite.animation.begins_with("attack_"):
			_play_hero_animation("attack_1")
		elif not hero_sprite.is_playing():
			hero_sprite.play()
	elif not hero.is_on_floor():
		_play_hero_animation("jump")
	elif horizontal != 0.0:
		var fast := run_held or bool(touch_state["run"])
		_play_hero_animation("run" if fast else "walk")
	else:
		_play_hero_animation("idle")

func _draw() -> void:
	var cam_x := hero.global_position.x if is_instance_valid(hero) else 650.0
	var chapter: Dictionary = CHAPTERS[clampi(current_chapter, 0, CHAPTERS.size() - 1)]
	var sky: Color = chapter["sky"]
	var accent: Color = chapter["accent"]
	draw_rect(Rect2(cam_x - 1400, -1000, 2800, 2400), sky)
	var moon_center := Vector2(cam_x + 430, 150)
	draw_circle(moon_center, 70, Color(accent.r, accent.g, accent.b, 0.10))
	draw_circle(moon_center, 46, Color(accent.r, accent.g, accent.b, 0.20))
	draw_circle(moon_center, 31, Color(0.62, 0.82, 0.95, 0.82))
	for i in range(45):
		var seed := float(i * 187 + 37)
		var sx := cam_x - 980.0 + fposmod(seed * 2.73, 1960.0)
		var sy := 24.0 + fposmod(seed * 1.29, 300.0)
		var twinkle := 0.4 + 0.6 * absf(sin(Time.get_ticks_msec() * 0.0015 + seed))
		draw_circle(Vector2(sx, sy), 1.0 + fposmod(seed, 2.0), Color(0.72, 0.90, 1.0, twinkle))
	var first_building := floori((cam_x - 1300.0) / 180.0)
	var last_building := floori((cam_x + 1300.0) / 180.0)
	for i in range(first_building, last_building + 1):
		var bx := float(i) * 180.0
		var tower_bonus := 72.0 if current_chapter == 3 and i % 3 == 0 else 0.0
		var height := 130.0 + fposmod(float(i * 67 + 311), 190.0) + tower_bonus
		var width := 104.0 + fposmod(float(i * 29 + 18), 52.0)
		var building_color := Color(0.035 + 0.01 * fposmod(float(i), 3.0), 0.055, 0.12 + 0.02 * fposmod(float(i), 2.0), 1.0)
		draw_rect(Rect2(bx, 620.0 - height, width, height), building_color)
		for wx in range(3):
			for wy in range(int(height / 32.0)):
				if int(absf(float(i * 13 + wx * 7 + wy * 5))) % 3 != 0:
					draw_rect(Rect2(bx + 12 + wx * 28, 620.0 - height + 18 + wy * 30, 7, 10), Color(accent.r, accent.g, accent.b, 0.25))
	if current_chapter == 1:
		for i in range(9):
			var lantern_x := cam_x - 780.0 + float(i) * 195.0
			var lantern_y := 145.0 + fposmod(float(i * 53), 105.0)
			draw_line(Vector2(lantern_x, 0), Vector2(lantern_x, lantern_y - 18), Color(0.32, 0.38, 0.57, 0.65), 2.0)
			draw_circle(Vector2(lantern_x, lantern_y), 18.0, Color(1.0, 0.31, 0.65, 0.12))
			draw_rect(Rect2(lantern_x - 8.0, lantern_y - 12.0, 16.0, 24.0), Color(1.0, 0.48, 0.30, 0.82))
			draw_rect(Rect2(lantern_x - 5.0, lantern_y - 8.0, 10.0, 16.0), Color(1.0, 0.84, 0.48, 0.92))
	elif current_chapter == 2:
		for i in range(38):
			var rain_x := cam_x - 1100.0 + fposmod(float(i * 137), 2200.0)
			var rain_y := fposmod(float(i * 83 + Time.get_ticks_msec() * 0.42), 720.0)
			draw_line(Vector2(rain_x, rain_y), Vector2(rain_x - 10.0, rain_y + 31.0), Color(0.44, 0.83, 1.0, 0.28), 1.5)
	elif current_chapter == 4:
		var dawn_center := Vector2(cam_x + 390.0, 285.0)
		draw_circle(dawn_center, 134.0, Color(1.0, 0.77, 0.28, 0.08))
		draw_circle(dawn_center, 98.0, Color(1.0, 0.79, 0.35, 0.12))
		draw_circle(dawn_center, 62.0, Color(1.0, 0.88, 0.58, 0.18))
	for rect in platform_rects:
		var ground := rect.size.y > 80.0
		var body_color := Color(0.045, 0.075, 0.13, 1.0) if ground else Color(0.085, 0.12, 0.19, 1.0)
		draw_rect(rect, body_color)
		draw_rect(Rect2(rect.position.x, rect.position.y, rect.size.x, 5), accent)
		draw_rect(Rect2(rect.position.x, rect.position.y + 8, rect.size.x, 2), Color(accent.r, accent.g, accent.b, 0.26))
		if not ground:
			for tile_x in range(int(rect.position.x), int(rect.position.x + rect.size.x), 36):
				draw_line(Vector2(tile_x, rect.position.y + 7), Vector2(tile_x - 14, rect.position.y + rect.size.y), Color(0.22, 0.35, 0.48, 0.34), 1.0)
	for rect in hazard_rects:
		draw_rect(rect, Color(0.48, 0.035, 0.13, 1.0))
		for spike_x in range(int(rect.position.x + 4), int(rect.position.x + rect.size.x), 18):
			draw_colored_polygon(PackedVector2Array([Vector2(spike_x, rect.position.y + rect.size.y), Vector2(spike_x + 9, rect.position.y + 2), Vector2(spike_x + 18, rect.position.y + rect.size.y)]), Color(1.0, 0.24, 0.34))
	for rect in bounce_pad_rects:
		draw_rect(rect, Color(0.06, 0.27, 0.28, 1.0))
		draw_rect(Rect2(rect.position.x, rect.position.y, rect.size.x, 5), Color(0.32, 1.0, 0.84))
		draw_arc(rect.position + Vector2(rect.size.x * 0.5, 0), 23.0, PI, TAU, 20, Color(0.32, 1.0, 0.84, 0.85), 3.0)
	for checkpoint in checkpoint_positions:
		var lit := checkpoint_x >= checkpoint
		var floor_y := _ground_y_at(checkpoint)
		var beacon_color := Color(0.22, 1.0, 0.74) if lit else Color(0.40, 0.60, 0.72)
		var beacon_top := floor_y - 132.0
		draw_circle(Vector2(checkpoint, beacon_top + 18.0), 38.0 if lit else 22.0, Color(beacon_color.r, beacon_color.g, beacon_color.b, 0.12 if lit else 0.07))
		draw_rect(Rect2(checkpoint - 30.0, floor_y - 12.0, 60.0, 12.0), Color(0.09, 0.16, 0.22))
		draw_rect(Rect2(checkpoint - 24.0, floor_y - 18.0, 48.0, 6.0), beacon_color)
		draw_rect(Rect2(checkpoint - 21.0, beacon_top + 14.0, 8.0, floor_y - beacon_top - 32.0), beacon_color)
		draw_rect(Rect2(checkpoint + 13.0, beacon_top + 14.0, 8.0, floor_y - beacon_top - 32.0), beacon_color)
		draw_rect(Rect2(checkpoint - 29.0, beacon_top + 6.0, 58.0, 10.0), Color(0.08, 0.17, 0.24))
		draw_rect(Rect2(checkpoint - 33.0, beacon_top, 66.0, 9.0), beacon_color)
		draw_colored_polygon(PackedVector2Array([Vector2(checkpoint + 23.0, beacon_top + 17.0), Vector2(checkpoint + 58.0, beacon_top + 27.0), Vector2(checkpoint + 23.0, beacon_top + 38.0)]), beacon_color)
		draw_circle(Vector2(checkpoint, beacon_top + 25.0), 14.0, Color(beacon_color.r, beacon_color.g, beacon_color.b, 0.26))
		draw_circle(Vector2(checkpoint, beacon_top + 25.0), 6.0, beacon_color)
		draw_string(ThemeDB.fallback_font, Vector2(checkpoint - 72.0, beacon_top - 12.0), "BEACON LIT" if lit else "CHECKPOINT", HORIZONTAL_ALIGNMENT_CENTER, 144.0, 12, beacon_color)
	var gate_x := WORLD_WIDTH - 95.0
	var gate_top := 438.0
	draw_circle(Vector2(gate_x, 535.0), 82.0, Color(accent.r, accent.g, accent.b, 0.08))
	draw_arc(Vector2(gate_x, 535.0), 67.0, 0.0, TAU, 48, Color(accent.r, accent.g, accent.b, 0.60), 4.0)
	draw_arc(Vector2(gate_x, 535.0), 54.0, 0.0, TAU, 48, Color(0.85, 0.96, 1.0, 0.72), 2.0)
	draw_rect(Rect2(gate_x - 39.0, 470.0, 78.0, 154.0), Color(0.025, 0.035, 0.095, 0.86))
	draw_arc(Vector2(gate_x, 535.0), 43.0, -PI * 0.9, PI * 0.9, 40, Color(accent.r, accent.g, accent.b, 0.95), 5.0)
	draw_rect(Rect2(gate_x - 55.0, gate_top + 16.0, 13.0, floorf(620.0 - gate_top - 16.0)), Color(0.15, 0.23, 0.34))
	draw_rect(Rect2(gate_x + 42.0, gate_top + 16.0, 13.0, floorf(620.0 - gate_top - 16.0)), Color(0.15, 0.23, 0.34))
	draw_rect(Rect2(gate_x - 76.0, gate_top + 9.0, 152.0, 17.0), accent)
	draw_rect(Rect2(gate_x - 91.0, gate_top, 182.0, 13.0), Color(0.92, 0.83, 0.54))
	draw_rect(Rect2(gate_x - 99.0, gate_top + 11.0, 198.0, 8.0), accent)
	draw_string(ThemeDB.fallback_font, Vector2(gate_x - 54.0, gate_top - 12.0), "STARWELL", HORIZONTAL_ALIGNMENT_CENTER, 108.0, 14, Color(0.96, 0.92, 0.74))
	for particle in particles:
		var color: Color = particle["color"]
		var alpha := clampf(float(particle["life"]) / float(particle["max"]), 0.0, 1.0)
		draw_circle(particle["position"], float(particle["size"]) * alpha, Color(color.r, color.g, color.b, alpha))
	if current_mode == "play" and toast_timer > 0.0:
		draw_rect(Rect2(cam_x - 330, 90, 660, 44), Color(0.015, 0.03, 0.07, 0.72))
