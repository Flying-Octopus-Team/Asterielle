extends Resource

class_name Item

# Should be ItemType
export(Resource) var type

# Should be array of StatChangers
export(Array, Resource) var stat_changers