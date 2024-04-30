extends Panel

@onready var history := $History
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(history)
	history.clear()

func add_history(stuff:String):
	history.add_text(stuff)
	history.newline()
	history.scroll_to_line(history.get_line_count())
