class_name IngredientData

## Placeholder colors pulled from docs/ART_GUIDE.md palette.
## Swap this dictionary out for real icon textures later —
## nothing else in the drag/plate/order code needs to change.
const COLORS := {
	"fern": Color("#A7BD40"),
	"bamboo": Color("#667436"),
	"cactus": Color("#C6C954"),
	"beet": Color("#D9828D"),
	"mushroom": Color("#CFBD8C"),
	"flower": Color("#FFEC8E"),
}

const ALL_IDS := ["fern", "bamboo", "cactus", "beet", "mushroom", "flower"]

static func get_color(id: String) -> Color:
	return COLORS.get(id, Color.WHITE)
