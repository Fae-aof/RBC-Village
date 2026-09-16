extends CanvasLayer
var CHAR_READ_RATE = 0.03
@onready var text_box_containter: MarginContainer = $"Text Box Containter"
@onready var text: Label = $"Text Box Containter/Text Box Panel/Text Container/Text Panel/Hbox/Text"
@onready var button: Button = $Button

enum TextStatus{
	ready,
	reading,
	finished
}

var current_state = TextStatus.ready
var tween
var text_queue = []
var dialogue_started = false

@export var lines: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_textbox()
	for i in lines:
		queue_text(i)


func _process(delta: float) -> void:
	match current_state:
		TextStatus.ready:
			if !text_queue.is_empty() and dialogue_started == true:
				display_text()
				Trackers.dialogue_active = true
		TextStatus.reading:
			pass
		TextStatus.finished:
			pass
			
func start_dialogue():
	dialogue_started = true

func hide_textbox():
	text.text = ""
	text_box_containter.hide()
	button.hide()
	text.visible_ratio = 0
	Trackers.dialogue_active = false

func show_textbox():
	text_box_containter.show()
	button.show()

func queue_text(next_text):
	text_queue.push_back(next_text)

func display_text():
	var next_text = text_queue.pop_front()
	text.text = next_text
	text.visible_ratio = 0.0
	show_textbox()
	change_state(TextStatus.reading)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(text, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE)
	tween.connect("finished", on_tween_finished)

func on_tween_finished():
	change_state(TextStatus.finished)	
	
	
func change_state(next_state):
	current_state = next_state


func _on_button_pressed() -> void:
	if current_state == TextStatus.finished:
		change_state(TextStatus.ready)
		if tween:
			tween.kill()
		hide_textbox()
		text.visible_ratio = 0
	if current_state == TextStatus.reading:
		change_state(TextStatus.finished)
		text.visible_ratio = 1
		if tween:
			tween.kill()
