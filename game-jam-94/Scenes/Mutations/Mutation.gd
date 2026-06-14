# Class for mutations. All new mutations should extend this.
# Provides virtual methods that mutations should optionally define behaviour for.
# Extends Node2D as some mutations need to be aware of 2D space.

class_name Mutation
extends Node2D


# Function called when a mutation is first applied to a blob.
# Should apply any one-time changes.
func _ready() -> void: pass


# Function called each physics frame.
# Should implement any physics behaviour.
func _physics_process(delta: float) -> void: pass


# Function called by brain when searching for things to do.
# Should update state + memory accordingly.
func brain_search(brain: Brain) -> void: pass


# Function called by brain when deciding for things to do.
# Should use brain state + memory and create tasks.
func brain_think(brain: Brain) -> void: pass
