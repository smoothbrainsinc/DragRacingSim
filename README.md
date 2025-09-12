# DragRacingSim - A Learning-Focused Drag Racing Game

## Project Philosophy

**NO SHORTCUTS. NO WORKAROUNDS. NO "QUICK FIXES".**

This project is built for learning Godot properly. Every system must be implemented correctly using Godot best practices, even if it takes longer. The goal is to build knowledge alongside the game, not to rush to a playable state with hacky solutions.

### Development Rules:
- ✅ Proper scene organization and node structure
- ✅ Clean, well-commented code following GDScript conventions  
- ✅ Modular systems that can be expanded over time
- ✅ Proper signal connections, not polling in _process()
- ❌ Global variables accessing everything
- ❌ "It works" without understanding why
- ❌ Copy/paste solutions without learning

## Current Project State

### What Works:
- Basic VehicleBody3D setup for player and opponent cars
- Blender car model imported and integrated
- Basic scene structure with track, start, and finish areas

### What Needs Implementation:
- [ ] Game state management system
- [ ] Race countdown UI system
- [ ] Start line detection and control
- [ ] Input locking/unlocking mechanism
- [ ] AI opponent control system
- [ ] Finish line detection and results
- [ ] Proper camera system

## Development Phases

### Phase 1: Core Race Mechanics
**Goal: Get a functional race from start to finish**

#### 1.1 GameManager Singleton
```
Purpose: Central game state management
Location: autoload singleton
Responsibilities:
- Track race states (WAITING, READY, SET, GO, RACING, FINISHED)
- Coordinate between all game systems
- Handle race timing
- Emit signals for state changes
```

#### 1.2 Race UI System
```
Scene: RaceUI.tscn (CanvasLayer)
Components:
- Countdown labels (Ready, Set, GO!)
- Race timer
- Speed displays for both cars
- Finish results overlay
```

#### 1.3 Start Line Control
```
Node: Area3D at starting line
Purpose: 
- Detect both cars in position
- Trigger countdown sequence
- Control race start timing
```

#### 1.4 Input Management
```
System: Input blocking/enabling
Implementation:
- Player input disabled until "GO" signal
- Clean connection to GameManager state
- No input polling, use proper input events
```

#### 1.5 AI Opponent System
```
Script: Enhanced opponent.gd
Features:
- Proper VehicleBody3D control
- Realistic acceleration curves
- Consistent lap times with slight variation
- Disabled until race start
```

#### 1.6 Finish Line Detection
```
Node: Area3D at finish line
Purpose:
- Detect race completion
- Determine winner
- Trigger results display
- Stop race timer
```

### Phase 2: Enhanced Gameplay (Future)
- Multiple tracks
- Car customization
- Performance upgrades
- Weather effects
- Multiplayer support

### Phase 3: Full Simulation (Long-term)
- Realistic physics tuning
- Engine temperature management
- Tire wear simulation
- Advanced AI personalities
- Career mode

## Technical Architecture

### Scene Organization
```
Main.tscn
├── Track (StaticBody3D)
├── StartLine (Area3D)
├── FinishLine (Area3D)  
├── PlayerCar (VehicleBody3D)
├── OpponentCar (VehicleBody3D)
├── CameraManager (Node3D)
└── RaceUI (CanvasLayer)
```

### Script Architecture
```
GameManager (Singleton)
├── Manages overall game state
├── Coordinates all systems
└── Handles race timing

PlayerController
├── Input handling
├── Car control logic
└── UI feedback

OpponentAI  
├── AI decision making
├── Car control logic
└── Performance consistency

RaceUI
├── Countdown display
├── Race information
└── Results presentation
```

## Current File Structure

### Scenes (.tscn)
- `main.tscn` - Main game scene
- `Player.tscn` - Player car setup
- `player_car.tscn` - Car model/physics
- `opponent.tscn` - AI car setup
- `track.tscn` - Track and environment
- `node_3d.tscn` - Utility scene

### Scripts (.gd)
- `player.gd` - Player input and control
- `opponent.gd` - AI behavior
- `track.gd` - Track-specific logic
- `camera_manager.gd` - Camera control system
- `finish_detection.gd` - Race completion logic

### Assets
- `datsun.glb` - Car 3D model from Blender
- `project.godot` - Project configuration

## Next Development Steps

### Immediate Priority (Week 1):
1. Create GameManager singleton with proper state machine
2. Build RaceUI scene with countdown system
3. Implement start line detection and race control
4. Set up proper input blocking/enabling

### Short Term (Month 1):
1. Complete basic race loop (start → race → finish → results)
2. Polish AI opponent behavior  
3. Add basic sound effects and visual feedback
4. Implement restart functionality

### Medium Term (Month 2-3):
1. Add multiple camera angles
2. Create track selection system
3. Implement basic car customization
4. Add performance statistics tracking

## Learning Goals

Each phase focuses on specific Godot concepts:

**Phase 1 Learning:**
- Singleton pattern and autoloads
- Signal-driven architecture  
- Scene instancing and management
- UI/Game separation with CanvasLayer
- Area3D detection systems
- State machine implementation

**Future Learning:**
- Resource management and saving
- Procedural generation
- Advanced physics simulation
- Multiplayer networking
- Performance optimization

## Development Notes

### Why This Approach?
- **Modular Design**: Each system can be enhanced independently
- **Scalable Architecture**: Easy to add features without refactoring
- **Learning Focused**: Each implementation teaches core Godot concepts
- **Professional Practices**: Code structure follows industry standards

### Common Temptations to Avoid:
- Using global variables instead of signals
- Putting all logic in _process() functions
- Hardcoding values instead of using exports
- Skipping proper scene organization
- Using yield/await without understanding coroutines

## Getting Help

When requesting assistance:
1. Reference this README's philosophy
2. Specify which phase/system you're working on  
3. Show current code structure
4. Ask for proper implementation, not quick fixes

**Remember: The goal is learning Godot correctly, not just making something that works.**# DragRacingSim
