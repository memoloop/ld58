extends CanvasLayer

@onready var money_label: Label = $MoneyLabel
@onready var collection_stuff_label: Label = $CollectionStuffLabel
@onready var collector_label: Label = $CollectorLabel

func _process(_delta):
	money_label.text = "Money: " + str(Global.money)
	collection_stuff_label.text = "Collection Stuffs: " + str(Global.collection_stuffs)
	collector_label.text = "Collectors: " + str(Global.collectors)