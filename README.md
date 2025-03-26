# Modern UI Animations Library for Garry's Mod

A comprehensive collection of modern, stylish UI animations for Garry's Mod. This highly customizable animation library will significantly enhance the visual appeal of your GMod addons and interfaces.

## Features

- **20+ Professional Animations** - including cubes, circles, pulses, spinners, progress bars, fades, waves, neon effects, logos, typewriter text, particles, moving cubes, orbital shapes, flowing patterns, interactive backgrounds, matrix effects, starfields, and more
- **Universal and Customizable** - use built-in styles or create your own with extensive configuration options
- **Easy Integration** - simple to implement in any addon with minimal code
- **Interactive Demo Panel** - built-in visual demonstration with real-time configuration
- **Optimized Performance** - designed for efficiency with smooth animations
- **Multiple Animation Styles** - variety of movement patterns including circular, wave, bounce, zigzag, spiral, and orbital

## Animation Categories

| Category | Animations |
|-----------|----------|
| **Basic Elements** | Cubes, Circles, Pulses, Spinners, Progress Bars, Fades |
| **Text & Logos** | Typewriter, Universal Logo, Glow Effects |
| **Particles & Effects** | Particles, Waves, Neon Effects |
| **Dynamic Motion** | Moving Cubes, Orbital Shapes, Flowing Patterns |
| **Interactive Elements** | Interactive Background with mouse movement detection |
| **Advanced Backgrounds** | Matrix, Starfield, Honeycomb, Circuit, Bubbles, Noise patterns |

## Usage Examples

### Moving Cubes Animation

```lua
-- Include the animation file in your code
local MovingCubesAnimation = include('animations/animations_movingcubes.lua')

-- Create the animation
local animation = vgui.Create('AnimatedMovingCubes', parent)
animation:SetSize(200, 200)

-- Configure with custom settings
animation:Configure({
    Colors = {
        Color(70, 150, 255),  -- Blue
        Color(255, 70, 150),  -- Pink
        Color(100, 255, 100), -- Green
        Color(255, 200, 70)   -- Yellow
    },
    CubeSize = 15,
    CubeCount = 4,
    Speed = 1.2,
    AnimationStyle = 'orbital', -- Options: circle, wave, bounce, zigzag, spiral, orbital, figure8
    TrailEffect = true,
    RotateCubes = true
})
```

### Interactive Background

```lua
-- Include the interactive background animation
local InteractiveBackground = include('animations/animations_interactivebackground.lua')

-- Create a panel that uses the interactive background
local frame = vgui.Create('DFrame')
frame:SetSize(800, 600)
frame:Center()
frame:MakePopup()
frame:SetTitle('Interactive Background Demo')

-- Add the interactive background as a child panel
local background = vgui.Create('AnimatedInteractiveBackground', frame)
background:Dock(FILL) -- Fill the entire frame
background:SetZPos(-1) -- Place it behind other elements

-- Configure the background
background:Configure({
    ElementType = 'particles',
    ElementCount = 150,
    BackgroundColor = Color(20, 22, 30),
    ColorScheme = {
        Color(70, 150, 255, 80),
        Color(255, 70, 150, 80),
        Color(100, 255, 100, 80)
    },
    ColorMode = 'theme',
    ConnectElements = true,
    InteractionRadius = 200,
    BaseMotion = 'gentle'
})

-- Add content on top of the interactive background
local label = vgui.Create('DLabel', frame)
label:SetText('Move your mouse to interact with the background')
label:SetFont('DermaLarge')
label:SetTextColor(Color(255, 255, 255))
label:SizeToContents()
label:Center()
```

### Advanced Backgrounds

```lua
-- Include the advanced backgrounds animation
local AdvancedBackgrounds = include('animations/animations_advancedbackgrounds.lua')

-- Create a panel that uses an advanced background
local frame = vgui.Create('DFrame')
frame:SetSize(800, 600)
frame:Center()
frame:MakePopup()
frame:SetTitle('Matrix Digital Rain Background')

-- Add the advanced background as a child panel
local background = vgui.Create('AnimatedAdvancedBackground', frame)
background:Dock(FILL)
background:SetZPos(-1) -- Place it behind other elements

-- Configure as matrix digital rain
background:Configure({
    Style = 'matrix',
    BackgroundColor = Color(10, 10, 15),
    PrimaryColor = Color(0, 200, 0, 100),
    AccentColor = Color(200, 255, 200, 100),
    Speed = 1.5,
    MatrixCharacters = '01アイウエオカキクケコサシスセソタチツテト',
    GlowEffect = true,
    MatrixFontSize = 16
})

-- Or configure as starfield
local starfield = vgui.Create('AnimatedAdvancedBackground', nil)
starfield:SetSize(400, 300)
starfield:Configure({
    Style = 'starfield',
    BackgroundColor = Color(0, 0, 20),
    PrimaryColor = Color(200, 200, 255, 100),
    AccentColor = Color(255, 200, 100, 100),
    Depth = true,
    Speed = 2,
    ElementsCount = 200,
    GlowEffect = true
})
```

## Installation

1. Clone or download this repository
2. Copy the `animations` folder to your addon's directory
3. Include the animation files you want to use:
   ```lua
   include('animations/animations_XXX.lua')
   ```
   where XXX is the animation type (movingcubes, orbitalshapes, etc.)

## Animation Types and Their Features

### Moving Cubes
- Multiple movement patterns: circle, wave, bounce, zigzag, spiral, orbital, figure8
- Configurable trail effects
- Rotation and 3D-like appearance
- Customizable colors, sizes, and speeds

### Orbital Shapes
- Variety of shape types: square, circle, triangle, diamond, star, hexagon, mixed
- Different orbital patterns: circle, ellipse, spiral, figure8, flower
- Glow effects and rotation options
- Fully customizable appearance

### Flowing Patterns
- Pattern styles: dots, lines, blocks, circles, waves
- Flow directions: left, right, up, down, circular, random
- Color styles: solid, gradient, rainbow, pulse
- Density and interaction controls

### Interactive Background
- Reacts to mouse movements in real-time
- Multiple element types: particles, grid, waves, flow, voronoi
- Various motion styles: gentle, wave, pulse, circular
- Connection options between elements
- Depth and glow effects for enhanced visuals
- Customizable interaction radius and strength

### Advanced Backgrounds
- Matrix style digital rain with customizable characters and colors
- Starfield animation with depth effect and motion trails
- Honeycomb pattern with pulsing hexagons and color transitions
- Circuit board style with animated connections and data flow
- Bubbles/particles with physics-based movements and interactions
- Perlin noise patterns with gradient coloring and interactive elements

### Other Animations
- Progress bars with multiple styles and effects
- Typewriter text with customizable typing speeds and effects
- Particle systems with physics and interaction
- Pulsing and glowing elements
- Logo animations with configurable text

## Demo Panel

To open the demonstration panel with all animations:

1. Run the included file: `cl_animation_demo.lua`
2. Explore each animation tab to see and configure different animation styles
3. Use the showcase mode to automatically cycle through all animations

## Contributing

Contributions are welcome! Feel free to:
- Add new animation types
- Improve existing animations
- Fix bugs or optimize performance
- Enhance the documentation

## License

This project is released under the MIT License. Feel free to use it in your personal and commercial Garry's Mod projects.
