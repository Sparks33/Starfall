extends CharacterBody2D

var delivered_count := 0
var total_stars := 0
var elapsed_time := 0.0
var game_won := false
var showing_pause := false
var last_move_direction := Vector2.RIGHT
var dash_direction := Vector2.RIGHT
var dash_time_left := 0.0
var dash_cooldown_left := 0.0
var delivery_surge_time_left := 0.0

func _ready() -> void:
	# Keep restart and pause keys available while the scene tree is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	total_stars = get_tree().get_nodes_in_group("star").size()
	var notice := $CanvasLayer/StatusMessage
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color(0.025, 0.045, 0.10, 0.94)
	panel.set_corner_radius_all(16)
	panel.content_margin_left = 22
	panel.content_margin_right = 22
	panel.content_margin_top = 18
	panel.content_margin_bottom = 18
	notice.add_theme_stylebox_override("normal", panel)
	_update_hud()

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	if key_event.keycode == KEY_ESCAPE or key_event.keycode == KEY_P:
		if not game_won:
			showing_pause = not showing_pause
			get_tree().paused = showing_pause
			$CanvasLayer/StatusMessage.visible = showing_pause
			$CanvasLayer/StatusMessage.text = "PAUSED\n\nEsc or P to resume\nR to restart"
	elif key_event.keycode == KEY_R:
		get_tree().paused = false
		get_tree().reload_current_scene()
	elif key_event.keycode == KEY_SHIFT and not game_won and not get_tree().paused and dash_cooldown_left <= 0.0:
		dash_direction = last_move_direction
		dash_time_left = 0.15
		dash_cooldown_left = 0.9

func _physics_process(delta: float) -> void:
	if get_tree().paused or game_won:
		return
	elapsed_time += delta
	dash_cooldown_left = maxf(0.0, dash_cooldown_left - delta)
	delivery_surge_time_left = maxf(0.0, delivery_surge_time_left - delta)
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if not input_direction.is_zero_approx():
		last_move_direction = input_direction.normalized()
	if dash_time_left > 0.0:
		dash_time_left = maxf(0.0, dash_time_left - delta)
		velocity = dash_direction * 850.0
	else:
		var move_speed := 520.0 if delivery_surge_time_left > 0.0 else 400.0
		velocity = input_direction * move_speed
	move_and_slide()
	_update_hud()

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("star") and not $HeldStar.visible:
		area.queue_free()
		$HeldStar.visible = true
		_update_hud()
	if area.is_in_group("basket") and $HeldStar.visible:
		$HeldStar.visible = false
		delivered_count += 1
		delivery_surge_time_left = 2.5
		_update_hud()
		if total_stars > 0 and delivered_count >= total_stars:
			game_won = true
			$CanvasLayer/StatusMessage.text = "ALL STARS DELIVERED!\n\nTime: %s\n\nPress R to play again" % _format_time()
			$CanvasLayer/StatusMessage.visible = true
			get_tree().paused = true

func _update_hud() -> void:
	if not is_node_ready():
		return
	$CanvasLayer/LeafCountDisplay.text = "STARS  %d / %d     CARRYING  %s     TIME  %s" % [delivered_count, total_stars, "YES" if $HeldStar.visible else "NO", _format_time()]

func _format_time() -> String:
	var seconds := int(elapsed_time)
	return "%02d:%02d" % [floori(seconds / 60.0), seconds % 60]
