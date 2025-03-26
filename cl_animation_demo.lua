--[[
    Animation Demo for Garry's Mod
    
    This is a demo panel that showcases all the animations
    included in the animation collection.
    
    Usage:
    - Run this file on the client to open the demo panel
    
    Each animation can be customized via the Configuration tab.
]]


print("Launching DDI animation demo for Garry's Mod...")
print('Note: This is just a demo, no animations will be displayed without the GMod environment.')

-- Add utility functions to draw namespace
if (not draw.LinearGradient) then
    function draw.LinearGradient(x, y, w, h, startColor, endColor, horizontal)
        horizontal = horizontal or false
        
        local vertices = {}
        
        if horizontal then
            vertices[1] = { x = x, y = y, u = 0, v = 0, color = startColor }
            vertices[2] = { x = x + w, y = y, u = 1, v = 0, color = endColor }
            vertices[3] = { x = x + w, y = y + h, u = 1, v = 1, color = endColor }
            vertices[4] = { x = x, y = y + h, u = 0, v = 1, color = startColor }
        else
            vertices[1] = { x = x, y = y, u = 0, v = 0, color = startColor }
            vertices[2] = { x = x + w, y = y, u = 1, v = 0, color = startColor }
            vertices[3] = { x = x + w, y = y + h, u = 1, v = 1, color = endColor }
            vertices[4] = { x = x, y = y + h, u = 0, v = 1, color = endColor }
        end
        
        surface.DrawPoly(vertices)
    end
end

if (not draw.RadialGradient) then
    function draw.RadialGradient(x, y, radius, innerColor, outerColor)
        local segments = 32
        local vertices = {}
        
        -- Center vertex with inner color
        table.insert(vertices, { x = x, y = y, u = 0.5, v = 0.5, color = innerColor })
        
        -- Create vertices around the circle
        for i = 0, segments do
            local angle = (i / segments) * math.pi * 2
            local vx = x + math.cos(angle) * radius
            local vy = y + math.sin(angle) * radius
            
            table.insert(vertices, { 
                x = vx, 
                y = vy, 
                u = 0.5 + math.cos(angle) * 0.5, 
                v = 0.5 + math.sin(angle) * 0.5, 
                color = outerColor
            })
        end
        
        surface.DrawPoly(vertices)
    end
end

-- If surface.DrawCircle is not defined or causes errors, replace it with its own implementation
if not surface.SafeDrawCircle then
    function surface.SafeDrawCircle(x, y, radius, segments, color)
        color = color or Color(255, 255, 255, 255) -- If no color is specified, use white
        
        local vertices = {}
        segments = segments or 32
        
        for i = 0, segments do
            local angle = math.rad((i / segments) * 360)
            local px = x + math.cos(angle) * radius
            local py = y + math.sin(angle) * radius
            table.insert(vertices, {x = px, y = py})
        end
        
        if (#vertices > 2) then
            draw.NoTexture()
            if color then
                surface.SetDrawColor(color.r, color.g, color.b, color.a)
            end
            surface.DrawPoly(vertices)
        end
    end
    
    -- Override the original function if it doesn't work
    local originalDrawCircle = surface.DrawCircle
    surface.DrawCircle = function(x, y, radius, segments, color)
        if segments and color then
            surface.SafeDrawCircle(x, y, radius, segments, color)
        elseif segments then
            surface.SafeDrawCircle(x, y, radius, segments)
        else
            -- If no segments are specified, use the default value
            surface.SafeDrawCircle(x, y, radius, 32)
        end
    end
end


-- Demo Panel
local DEMO = {}

-- Initialize the panel
function DEMO:Init()
    self:SetSize(900, 700)
    self:SetTitle('')
    self:Center()
    self:MakePopup()
    
    -- DDI Theme Colors
    self.Theme = {
        Primary = Color(70, 150, 255),       -- DDI Blue
        Secondary = Color(255, 70, 150),     -- DDI Pink
        Accent = Color(100, 255, 100),       -- DDI Green
        Background = Color(40, 40, 44),      -- Dark background
        BackgroundLight = Color(50, 50, 54), -- Light background
        Text = Color(230, 230, 230),         -- Text color
        TextDark = Color(180, 180, 180)      -- Darker text
    }
    
    -- Custom title bar
    self.TitleBar = vgui.Create('DPanel', self)
    self.TitleBar:SetPos(0, 0)
    self.TitleBar:SetSize(self:GetWide() - 40, 30)
    self.TitleBar.Paint = function(_, w, h)
        -- Color accent
        local accentWidth = 4
        -- Title text with shadow
        local title = 'DDI Modern UI Animations Demo'
        surface.SetFont('DermaDefaultBold')
        local tw, th = surface.GetTextSize(title)
        -- Text
        surface.SetTextColor(self.Theme.Text)
        surface.SetTextPos(accentWidth * 3, h/2 - th/2)
        surface.DrawText(title)
    end
    
    -- Main container
    self.Container = vgui.Create('DPanel', self)
    self.Container:SetPos(0, 30)
    self.Container:SetSize(self:GetWide(), self:GetTall() - 30)
    self.Container.Paint = function(_, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, self.Theme.Background, false, false, true, true)
    end
    
    -- Create tabs
    self.Tabs = vgui.Create('DPropertySheet', self.Container)
    self.Tabs:Dock(FILL)
    
    -- Add animation tabs
    self:AddAnimationTab('Cubes', 'AnimatedCubes', {
        Width = 300,
        Height = 100,
        Description = 'A loading animation with colored cubes that move between each other.',
        Config = {
            Colors = {
                {name = 'Red Cube', default = Color(255, 70, 70)},
                {name = 'Blue Cube', default = Color(70, 150, 255)},
                {name = 'Green Cube', default = Color(70, 255, 70)},
                {name = 'Yellow Cube', default = Color(255, 200, 70)}
            },
            CubeSize = {name = 'Cube Size', type = 'slider', min = 10, max = 40, default = 20},
            CubeCount = {name = 'Cube Count', type = 'slider', min = 2, max = 8, default = 4},
            Speed = {name = 'Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            Spacing = {name = 'Spacing', type = 'slider', min = 5, max = 30, default = 15},
            MovementRange = {name = 'Movement Range', type = 'slider', min = 5, max = 50, default = 20}
        }
    })
    
    self:AddAnimationTab('Circles', 'AnimatedCircles', {
        Width = 200,
        Height = 200,
        Description = 'A loading animation with circles that orbit around a center point.',
        Config = {
            Colors = {
                {name = 'Red Circle', default = Color(255, 70, 70, 230)},
                {name = 'Blue Circle', default = Color(70, 150, 255, 230)},
                {name = 'Green Circle', default = Color(70, 255, 70, 230)},
                {name = 'Yellow Circle', default = Color(255, 200, 70, 230)}
            },
            CircleRadius = {name = 'Circle Radius', type = 'slider', min = 5, max = 20, default = 10},
            CircleCount = {name = 'Circle Count', type = 'slider', min = 2, max = 8, default = 4},
            Speed = {name = 'Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            OrbitRadius = {name = 'Orbit Radius', type = 'slider', min = 10, max = 60, default = 30},
            InnerRotation = {name = 'Inner Rotation', type = 'checkbox', default = true}
        }
    })
    
    self:AddAnimationTab('Pulse', 'AnimatedPulse', {
        Width = 120,
        Height = 120,
        Description = 'A pulsing animation that can be used to highlight elements.',
        Config = {
            Color = {name = 'Color', default = Color(70, 150, 255, 180)},
            Speed = {name = 'Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            PulseSize = {name = 'Pulse Size', type = 'slider', min = 0.1, max = 0.5, default = 0.3},
            PulseMin = {name = 'Pulse Min', type = 'slider', min = 0.5, max = 0.9, default = 0.7},
            BorderWidth = {name = 'Border Width', type = 'slider', min = 0, max = 5, default = 2},
            Style = {name = 'Style', type = 'options', options = {'circle', 'square', 'hexagon'}, default = 'circle'},
            GlowFactor = {name = 'Glow Factor', type = 'slider', min = 0, max = 1, default = 0.5}
        }
    })
    
    self:AddAnimationTab('Spinner', 'AnimatedSpinner', {
        Width = 120,
        Height = 120,
        Description = 'A spinner animation that can be used for loading indicators.',
        Config = {
            Color = {name = 'Color', default = Color(255, 255, 255, 230)},
            ColorSecondary = {name = 'Secondary Color', default = Color(70, 150, 255, 230)},
            Speed = {name = 'Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            Style = {name = 'Style', type = 'options', options = {'simple', 'dual', 'dots', 'segments'}, default = 'dual'},
            Width = {name = 'Line Width', type = 'slider', min = 1, max = 8, default = 3},
            SegmentCount = {name = 'Segment Count', type = 'slider', min = 4, max = 16, default = 8},
            GapSize = {name = 'Gap Size', type = 'slider', min = 0, max = 0.5, default = 0.2},
            Reverse = {name = 'Reverse Direction', type = 'checkbox', default = false}
        }
    })
    
    self:AddAnimationTab('Progress Bar', 'AnimatedProgressBar', {
        Width = 300,
        Height = 30,
        Description = 'An animated progress bar with various styles.',
        Config = {
            Color = {name = 'Color', default = Color(70, 150, 255)},
            BackgroundColor = {name = 'Background Color', default = Color(40, 40, 40, 200)},
            BorderColor = {name = 'Border Color', default = Color(100, 100, 100, 100)},
            Progress = {name = 'Progress', type = 'slider', min = 0, max = 1, default = 0.5},
            SmoothSpeed = {name = 'Smooth Speed', type = 'slider', min = 1, max = 10, default = 3},
            Height = {name = 'Height', type = 'slider', min = 4, max = 20, default = 8},
            Style = {name = 'Style', type = 'options', options = {'default', 'segments', 'gradient', 'pulse'}, default = 'default'},
            Rounded = {name = 'Rounded Corners', type = 'checkbox', default = true},
            Animated = {name = 'Animated', type = 'checkbox', default = true},
            SegmentCount = {name = 'Segment Count', type = 'slider', min = 4, max = 20, default = 10},
            SegmentGap = {name = 'Segment Gap', type = 'slider', min = 1, max = 10, default = 3},
            GlowFactor = {name = 'Glow Factor', type = 'slider', min = 0, max = 1, default = 0.3}
        }
    })
    
    self:AddAnimationTab('Fade', 'AnimatedFade', {
        Width = 300,
        Height = 80,
        Description = 'Fade in/out animations for panels, text, and other UI elements.',
        Config = {
            FadeInTime = {name = 'Fade In Time', type = 'slider', min = 0.1, max = 2, default = 0.5},
            FadeOutTime = {name = 'Fade Out Time', type = 'slider', min = 0.1, max = 2, default = 0.3},
            HoldTime = {name = 'Hold Time', type = 'slider', min = 0.5, max = 3, default = 1.0},
            StartDelay = {name = 'Start Delay', type = 'slider', min = 0, max = 1, default = 0.0},
            RepeatDelay = {name = 'Repeat Delay', type = 'slider', min = 0, max = 1, default = 0.0},
            Color = {name = 'Color', default = Color(70, 150, 255, 200)},
            Text = {name = 'Text', type = 'text', default = 'Fade Animation'},
            TextAlign = {name = 'Text Align', type = 'options', options = {'left', 'center', 'right'}, default = 'center'},
            Font = {name = 'Font', type = 'options', options = {'DermaDefault', 'DermaLarge', 'DermaDefaultBold'}, default = 'DermaLarge'},
            AutoPlay = {name = 'Auto Play', type = 'checkbox', default = true},
            Loop = {name = 'Loop', type = 'checkbox', default = true},
            FadeStyle = {name = 'Fade Style', type = 'options', options = {'smooth', 'linear', 'bounce'}, default = 'smooth'},
            Direction = {name = 'Direction', type = 'options', options = {'horizontal', 'vertical', 'both'}, default = 'horizontal'},
            DrawPanel = {name = 'Draw Panel', type = 'checkbox', default = true}
        }
    })
    
    self:AddAnimationTab('Wave', 'AnimatedWave', {
        Width = 300,
        Height = 80,
        Description = 'Wave animation with customizable parameters.',
        Config = {
            Color = {name = 'Color', default = self.Theme.Primary},
            Speed = {name = 'Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            Amplitude = {name = 'Amplitude', type = 'slider', min = 1, max = 20, default = 8},
            Frequency = {name = 'Frequency', type = 'slider', min = 0.1, max = 2, default = 0.5},
            LineWidth = {name = 'Line Width', type = 'slider', min = 1, max = 10, default = 2},
            GlowFactor = {name = 'Glow Factor', type = 'slider', min = 0, max = 1, default = 0.3},
            Style = {name = 'Style', type = 'options', options = {'sine', 'square', 'sawtooth'}, default = 'sine'},
            Direction = {name = 'Direction', type = 'options', options = {'horizontal', 'vertical', 'diagonal'}, default = 'horizontal'},
            Points = {name = 'Points Count', type = 'slider', min = 10, max = 100, default = 40},
            DDIColors = {name = 'Use DDI Colors', type = 'checkbox', default = true},
            DDIStyled = {name = 'DDI Styled', type = 'checkbox', default = true}
        }
    })

    self:AddAnimationTab('Neon', 'AnimatedNeon', {
        Width = 200,
        Height = 100,
        Description = 'Neon animation with glow and color effects.',
        Config = {
            Color = {name = 'Color', default = self.Theme.Primary},
            SecondaryColor = {name = 'Secondary Color', default = self.Theme.Secondary},
            AccentColor = {name = 'Accent Color', default = self.Theme.Accent},
            Speed = {name = 'Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            GlowStrength = {name = 'Glow Strength', type = 'slider', min = 0, max = 5, default = 2},
            PulseEffect = {name = 'Pulse Effect', type = 'checkbox', default = true},
            PulseSpeed = {name = 'Pulse Speed', type = 'slider', min = 0.1, max = 2, default = 0.5},
            BorderWidth = {name = 'Border Width', type = 'slider', min = 1, max = 5, default = 2},
            BackgroundOpacity = {name = 'Background Opacity', type = 'slider', min = 0, max = 1, default = 0.2},
            Style = {name = 'Style', type = 'options', options = {'outline', 'filled', 'dotted'}, default = 'outline'},
            DDIStyled = {name = 'DDI Styled', type = 'checkbox', default = true}
        }
    })
    
    self:AddAnimationTab('DDI Logo', 'AnimatedDDILogo', {
        Width = 150,
        Height = 150,
        Description = 'Animated DDI logo with different styles and effects.',
        Config = {
            LogoStyle = {name = 'Logo Style', type = 'options', options = {'standard', 'minimal', 'tech', 'glow'}, default = 'standard'},
            PrimaryColor = {name = 'Primary Color', default = self.Theme.Primary},
            SecondaryColor = {name = 'Secondary Color', default = self.Theme.Secondary},
            AccentColor = {name = 'Accent Color', default = self.Theme.Accent},
            Size = {name = 'Size', type = 'slider', min = 50, max = 200, default = 100},
            AnimationStyle = {name = 'Animation Style', type = 'options', options = {'pulse', 'rotate', 'wave', 'flicker', 'morph'}, default = 'pulse'},
            AnimationSpeed = {name = 'Animation Speed', type = 'slider', min = 0.1, max = 2, default = 1},
            BackgroundStyle = {name = 'Background Style', type = 'options', options = {'none', 'circle', 'square', 'hex'}, default = 'none'},
            BorderStyle = {name = 'Border Style', type = 'options', options = {'none', 'simple', 'double', 'glow'}, default = 'none'},
            TextTagline = {name = 'Show Tagline', type = 'checkbox', default = false},
            Tagline = {name = 'Tagline', type = 'text', default = 'DDI Modern UI Animations'},
            GlowAmount = {name = 'Glow Amount', type = 'slider', min = 0, max = 1, default = 0.5}
        }
    })
    
    self:AddAnimationTab('Logo', 'AnimatedUniversalLogo', {
        Width = 150,
        Height = 150,
        Description = 'Universal animated logo with customizable parameters.',
        Config = {
            LogoStyle = {name = 'Logo Style', type = 'options', options = {'standard', 'minimal', 'tech', 'glow', 'retro', 'neon'}, default = 'standard'},
            PrimaryColor = {name = 'Primary Color', default = self.Theme.Primary},
            SecondaryColor = {name = 'Secondary Color', default = self.Theme.Secondary},
            AccentColor = {name = 'Accent Color', default = self.Theme.Accent},
            Size = {name = 'Size', type = 'slider', min = 50, max = 200, default = 100},
            AnimationStyle = {name = 'Animation Style', type = 'options', options = {'pulse', 'rotate', 'wave', 'flicker', 'morph'}, default = 'pulse'},
            AnimationSpeed = {name = 'Animation Speed', type = 'slider', min = 0.1, max = 2, default = 1},
            BackgroundStyle = {name = 'Background Style', type = 'options', options = {'none', 'circle', 'square', 'hex'}, default = 'none'},
            BorderStyle = {name = 'Border Style', type = 'options', options = {'none', 'simple', 'double', 'glow'}, default = 'none'},
            TextTagline = {name = 'Show Tagline', type = 'checkbox', default = false},
            Tagline = {name = 'Tagline', type = 'text', default = 'Custom Logo Animation'},
            GlowAmount = {name = 'Glow Amount', type = 'slider', min = 0, max = 1, default = 0.5},
            CustomText = {name = 'Custom Text', type = 'text', default = 'LOGO'}
        }
    })
    
    self:AddAnimationTab('Type Writer', 'AnimatedTypeWriter', {
        Width = 300,
        Height = 100,
        Description = 'Typing animation with typewriter effect.',
        Config = {
            Text = {name = 'Text Content', type = 'text', default = 'DDI Modern UI Animations'},
            Color = {name = 'Text Color', default = self.Theme.Primary},
            Font = {name = 'Font', type = 'options', options = {'DermaLarge', 'DermaDefaultBold', 'CloseCaption_Bold'}, default = 'DermaLarge'},
            TypeSpeed = {name = 'Typing Speed', type = 'slider', min = 0.01, max = 0.2, default = 0.05},
            BlinkCursor = {name = 'Blink Cursor', type = 'checkbox', default = true},
            CursorColor = {name = 'Cursor Color', default = self.Theme.Secondary},
            CursorChar = {name = 'Cursor Character', type = 'options', options = {'|', '_', '▌', '■'}, default = '|'},
            Loop = {name = 'Loop Animation', type = 'checkbox', default = false},
            LoopDelay = {name = 'Loop Delay', type = 'slider', min = 0.5, max = 5, default = 1},
            BackgroundColor = {name = 'Background Color', default = Color(40, 40, 44, 100)},
            DDIStyled = {name = 'DDI Styled', type = 'checkbox', default = true}
        }
    })
    
    self:AddAnimationTab('Glow', 'AnimatedGlow', {
        Width = 200,
        Height = 200,
        Description = 'Pulsating glow with customizable shapes and colors.',
        Config = {
            GlowColor = {name = 'Glow Color', default = self.Theme.Primary},
            SecondaryColor = {name = 'Secondary Color', default = self.Theme.Secondary},
            PulseSpeed = {name = 'Pulse Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            MaxGlowSize = {name = 'Max Glow Size', type = 'slider', min = 5, max = 30, default = 15},
            MinGlowSize = {name = 'Min Glow Size', type = 'slider', min = 1, max = 10, default = 5},
            GlowShape = {name = 'Glow Shape', type = 'options', options = {'circle', 'square', 'hexagon', 'diamond'}, default = 'circle'},
            GlowIntensity = {name = 'Glow Intensity', type = 'slider', min = 0.1, max = 1, default = 0.8},
            MultiColor = {name = 'Multi-Color', type = 'checkbox', default = true},
            ColorShift = {name = 'Color Shift', type = 'checkbox', default = false},
            InteractionGlow = {name = 'Interaction', type = 'checkbox', default = true},
            ContentType = {name = 'Content Type', type = 'options', options = {'none', 'text'}, default = 'text'},
            Content = {name = 'Content Text', type = 'text', default = 'DDI'},
            ContentColor = {name = 'Content Color', default = Color(255, 255, 255, 255)},
            DDIStyled = {name = 'DDI Styled', type = 'checkbox', default = true}
        }
    })
    
    self:AddAnimationTab('Particles', 'AnimatedParticles', {
        Width = 300, 
        Height = 200,
        Description = 'Interactive particle system with physics and effects.',
        Config = {
            ParticleCount = {name = 'Particle Count', type = 'slider', min = 10, max = 100, default = 30},
            MinSize = {name = 'Min Size', type = 'slider', min = 1, max = 5, default = 2},
            MaxSize = {name = 'Max Size', type = 'slider', min = 3, max = 15, default = 8},
            Colors = {
                {name = 'Primary Particles', default = self.Theme.Primary},
                {name = 'Secondary Particles', default = self.Theme.Secondary},
                {name = 'Accent Particles', default = self.Theme.Accent}
            },
            Shape = {name = 'Particle Shape', type = 'options', options = {'circle', 'square', 'diamond', 'triangle'}, default = 'circle'},
            EmissionMode = {name = 'Emission Mode', type = 'options', options = {'all', 'burst', 'continuous'}, default = 'all'},
            EmissionPoint = {name = 'Emission Point', type = 'options', options = {'center', 'edges', 'random'}, default = 'center'},
            GravityEffect = {name = 'Gravity', type = 'slider', min = 0, max = 1, default = 0},
            MouseInteraction = {name = 'Mouse Interaction', type = 'checkbox', default = true},
            Turbulence = {name = 'Turbulence', type = 'slider', min = 0, max = 1, default = 0.2},
            FadeOut = {name = 'Fade Out', type = 'checkbox', default = true},
            RotatingParticles = {name = 'Rotating Particles', type = 'checkbox', default = true},
            CollisionDetection = {name = 'Collision Detection', type = 'checkbox', default = false},
            BackgroundDim = {name = 'Background Dim', type = 'slider', min = 0, max = 1, default = 0},
            DDIStyled = {name = 'DDI Styled', type = 'checkbox', default = true}
        }
    })
    
    self:AddAnimationTab('Moving Cubes', 'AnimatedMovingCubes', {
        Width = 200,
        Height = 200,
        Description = 'Animation with moving cubes on different trajectories.',
        Config = {
            Colors = {
                {name = 'Color 1', default = Color(70, 150, 255)},
                {name = 'Color 2', default = Color(255, 70, 150)},
                {name = 'Color 3', default = Color(100, 255, 100)},
                {name = 'Color 4', default = Color(255, 200, 70)}
            },
            CubeSize = {name = 'Cube Size', type = 'slider', min = 5, max = 30, default = 15},
            CubeCount = {name = 'Cube Count', type = 'slider', min = 1, max = 8, default = 4},
            Speed = {name = 'Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            AnimationStyle = {name = 'Animation Style', type = 'options', 
                options = {'circle', 'wave', 'bounce', 'zigzag', 'spiral', 'orbital', 'figure8'}, 
                default = 'circle'
            },
            TrailEffect = {name = 'Trail Effect', type = 'checkbox', default = false},
            RotateCubes = {name = 'Rotate Cubes', type = 'checkbox', default = true}
        }
    })
    
    self:AddAnimationTab('Orbital Shapes', 'AnimatedOrbitalShapes', {
        Width = 200,
        Height = 200,
        Description = 'Animation with different shapes moving on orbital trajectories.',
        Config = {
            Colors = {
                {name = 'Color 1', default = Color(70, 150, 255)},
                {name = 'Color 2', default = Color(255, 70, 150)},
                {name = 'Color 3', default = Color(100, 255, 100)},
                {name = 'Color 4', default = Color(255, 200, 70)}
            },
            ShapeSize = {name = 'Shape Size', type = 'slider', min = 5, max = 30, default = 15},
            ShapeCount = {name = 'Shape Count', type = 'slider', min = 3, max = 10, default = 5},
            Speed = {name = 'Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            ShapeType = {name = 'Shape Type', type = 'options', 
                options = {'square', 'circle', 'triangle', 'diamond', 'star', 'hexagon', 'mixed'}, 
                default = 'mixed'
            },
            OrbitStyle = {name = 'Orbit Style', type = 'options', 
                options = {'circle', 'ellipse', 'spiral', 'figure8', 'flower'}, 
                default = 'circle'
            },
            RotateShapes = {name = 'Rotate Shapes', type = 'checkbox', default = true},
            GlowEffect = {name = 'Glow Effect', type = 'checkbox', default = false},
            GlowAmount = {name = 'Glow Amount', type = 'slider', min = 0, max = 1, default = 0.5}
        }
    })
    
    self:AddAnimationTab('Flowing Patterns', 'AnimatedFlowingPatterns', {
        Width = 300,
        Height = 200,
        Description = 'Animation with smooth moving patterns and effects.',
        Config = {
            Colors = {
                {name = 'Color 1', default = Color(70, 150, 255)},
                {name = 'Color 2', default = Color(255, 70, 150)},
                {name = 'Color 3', default = Color(100, 255, 100)}
            },
            PatternStyle = {name = 'Pattern Style', type = 'options', 
                options = {'dots', 'lines', 'blocks', 'circles', 'waves'}, 
                default = 'dots'
            },
            ItemSize = {name = 'Item Size', type = 'slider', min = 2, max = 15, default = 6},
            Density = {name = 'Density', type = 'slider', min = 0.1, max = 1, default = 0.5},
            Speed = {name = 'Speed', type = 'slider', min = 0.1, max = 3, default = 1},
            FlowDirection = {name = 'Flow Direction', type = 'options', 
                options = {'left', 'right', 'up', 'down', 'circular', 'random'}, 
                default = 'random'
            },
            ColorStyle = {name = 'Color Style', type = 'options', 
                options = {'solid', 'gradient', 'rainbow', 'pulse'}, 
                default = 'solid'
            },
            Interaction = {name = 'Mouse Interaction', type = 'checkbox', default = false}
        }
    })

    self:AddAnimationTab('Interactive Background', 'AnimatedInteractiveBackground', {
        Width = 340,
        Height = 400,
        Description = 'Animated background responding to mouse movements. Move the cursor to create interactive effects.',
        Config = {
            BackgroundColor = {name = 'Background Color', default = Color(30, 30, 35)},
            
            ElementType = {name = 'Element Type', type = 'options', 
                options = {'particles', 'grid', 'waves', 'flow', 'voronoi'}, 
                default = 'particles'
            },
            ElementCount = {name = 'Element Count', type = 'slider', min = 20, max = 200, default = 100},
            ElementSize = {name = 'Element Size', type = 'slider', min = 1, max = 10, default = 3},
            ElementSpacing = {name = 'Element Spacing', type = 'slider', min = 20, max = 80, default = 40},
            
            InteractionRadius = {name = 'Interaction Radius', type = 'slider', min = 50, max = 300, default = 150},
            InteractionStrength = {name = 'Interaction Strength', type = 'slider', min = 0.1, max = 3, default = 1},
            InteractionFade = {name = 'Interaction Fade', type = 'slider', min = 0.8, max = 0.99, default = 0.95},
            InteractionPersistence = {name = 'Interaction Persistence', type = 'slider', min = 0, max = 1, default = 0.4},
            
            BaseMotion = {name = 'Base Motion', type = 'options', 
                options = {'none', 'gentle', 'wave', 'pulse', 'circular'}, 
                default = 'gentle'
            },
            MotionSpeed = {name = 'Motion Speed', type = 'slider', min = 0, max = 2, default = 0.5},
            MotionAmount = {name = 'Motion Amount', type = 'slider', min = 0, max = 1, default = 0.3},
            
            ColorMode = {name = 'Color Mode', type = 'options', 
                options = {'monochrome', 'gradient', 'rainbow', 'theme'}, 
                default = 'monochrome'
            },
            ColorScheme = {
                {name = 'Primary Color', default = Color(70, 150, 255, 100)},
                {name = 'Secondary Color', default = Color(255, 70, 150, 100)},
                {name = 'Accent Color', default = Color(100, 255, 100, 100)}
            },
            Depth = {name = '3D Depth Effect', type = 'slider', min = 0, max = 1, default = 0.3},
            GlowEffect = {name = 'Glow Effect', type = 'checkbox', default = false},
            ConnectElements = {name = 'Connect Elements', type = 'checkbox', default = false},
            ConnectionThreshold = {name = 'Connection Distance', type = 'slider', min = 20, max = 150, default = 60},
            
            UpdateFrequency = {name = 'Update Frequency', type = 'slider', min = 0.01, max = 0.1, default = 0.03},
            EnableFading = {name = 'Enable Fading', type = 'checkbox', default = true}
        }
    })
    
    -- Adding instructions
    self:AddInstructionsTab()
end

-- Add an animation tab
function DEMO:AddAnimationTab(name, panelType, options)
    options = options or {}
    local width = options.Width or 200
    local height = options.Height or 100
    
    -- Tab panel
    local panel = vgui.Create('DPanel', self.Container)
    panel:Dock(FILL)
    panel.Paint = function(_, w, h)
        -- Themed background
        draw.RoundedBox(4, 0, 0, w, h, self.Theme.BackgroundLight)
        
        -- Accent pattern at the bottom
        local patternHeight = 4
        local patternWidth = w / 3
        
        -- Primary color segment
        surface.SetDrawColor(self.Theme.Primary)
        surface.DrawRect(0, h - patternHeight, patternWidth, patternHeight)
        
        -- Secondary color segment
        surface.SetDrawColor(self.Theme.Secondary)
        surface.DrawRect(patternWidth, h - patternHeight, patternWidth, patternHeight)
        
        -- Accent color segment
        surface.SetDrawColor(self.Theme.Accent)
        surface.DrawRect(patternWidth * 2, h - patternHeight, patternWidth, patternHeight)
    end
    
    -- Split into preview and configuration
    -- local splitPanel = vgui.Create('DHorizontalDivider', panel)
    -- splitPanel:Dock(FILL)
    -- splitPanel:SetLeftWidth(400)
    -- splitPanel:SetDividerWidth(4)
    
    -- Preview panel
    local previewContainer = vgui.Create('DPanel', panel)
    previewContainer:Dock(LEFT)
    previewContainer:SetWide(400)
    previewContainer:DockMargin(10, 10, 5, 10)
    previewContainer.Paint = function(_, w, h)
        -- Styled preview container with rounded corners
        draw.RoundedBox(6, 0, 0, w, h, self.Theme.Background)

        -- Draw small subtle grid pattern
        surface.SetDrawColor(50, 50, 54, 100)
        local gridSize = 20
        for i = 0, w, gridSize do
            surface.DrawLine(i, 0, i, h)
        end
        for i = 0, h, gridSize do
            surface.DrawLine(0, i, w, i)
        end
    end
    
    -- Preview section with gray box to show animation against
    local previewSection = vgui.Create('DPanel', previewContainer)
    previewSection:SetSize(previewContainer:GetWide(), height)
    previewSection:Dock(TOP)
    previewSection:DockMargin(10, 10, 10, 0)
    previewSection.Paint = function(_, w, h)
        -- Draw background
        surface.SetDrawColor(60, 60, 60, 255)
        surface.DrawRect(0, 0, w, h)
        
        -- Draw grid
        surface.SetDrawColor(70, 70, 70, 255)
        for x = 0, w, 20 do
            surface.DrawLine(x, 0, x, h)
        end
        for y = 0, h, 20 do
            surface.DrawLine(0, y, w, y)
        end
        
        -- Draw border
        surface.SetDrawColor(90, 90, 90, 255)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end
    
    -- Description
    local descLabel = vgui.Create('DLabel', previewContainer)
    descLabel:SetText(options.Description or '')
    descLabel:SetTextColor(Color(200, 200, 200))
    descLabel:SetFont('DermaDefaultBold')
    descLabel:Dock(TOP)
    descLabel:DockMargin(20, 20, 20, 0)
    descLabel:SetTall(20)
    descLabel:SetContentAlignment(5) -- Center
    
    -- The actual animation panel
    local animation = vgui.Create(panelType, previewSection)
    animation:SetSize(width, height)
    animation:Center()
    panel.Animation = animation
    
    -- Configuration panel
    local configContainer = vgui.Create('DScrollPanel', panel)
    configContainer:Dock(FILL)
    configContainer:DockMargin(5, 10, 10, 10)
    configContainer.Paint = function(_, w, h)
        -- Styled config container
        draw.RoundedBox(6, 0, 0, w, h, self.Theme.Background)
        
        -- Add subtle vertical accent line on the left with theme colors
        surface.SetDrawColor(self.Theme.Primary.r, self.Theme.Primary.g, self.Theme.Primary.b, 100)
        surface.DrawRect(0, 0, 2, h/3)
        
        surface.SetDrawColor(self.Theme.Secondary.r, self.Theme.Secondary.g, self.Theme.Secondary.b, 100)
        surface.DrawRect(0, h/3, 2, h/3)
        
        surface.SetDrawColor(self.Theme.Accent.r, self.Theme.Accent.g, self.Theme.Accent.b, 100)
        surface.DrawRect(0, h*2/3, 2, h/3)
    end
    
    -- Add configuration controls
    self:AddConfigurationControls(configContainer, animation, options.Config or {})
    
    -- splitPanel:SetLeft(previewContainer)
    -- splitPanel:SetRight(configContainer)
    
    -- Add the tab
    self.Tabs:AddSheet(name, panel, nil, false, false, name .. ' animation')
end

-- Add configuration controls
function DEMO:AddConfigurationControls(parent, animation, config)
    local configs = {}
    
    -- Configuration title
    local titleLabel = vgui.Create('DLabel', parent)
    titleLabel:SetText('Configuration')
    titleLabel:SetTextColor(Color(230, 230, 230))
    titleLabel:SetFont('DermaDefaultBold')
    titleLabel:Dock(TOP)
    titleLabel:DockMargin(10, 10, 10, 10)
    titleLabel:SetContentAlignment(5) -- Center
    titleLabel:SetTall(20)
    
    local yPos = 40
    
    -- Create controls for each configuration option
    for key, options in pairs(config) do
        if (key == 'Colors') then
            -- Special handling for color array
            for i, colorOption in ipairs(options) do
                local colorLabel = vgui.Create('DLabel', parent)
                colorLabel:SetText(colorOption.name or '')
                colorLabel:SetTextColor(Color(200, 200, 200))
                colorLabel:SetPos(20, yPos)
                colorLabel:SetSize(150, 20)
                
                local colorMixer = vgui.Create('DColorMixer', parent)
                colorMixer:SetPos(175, yPos)
                colorMixer:SetSize(180, 100)
                colorMixer:SetPalette(false)
                colorMixer:SetAlphaBar(true)
                colorMixer:SetColor(colorOption.default)
                
                colorMixer.OnValueChanged = function(_, col)
                    local newColors = table.Copy(animation.Colors or {})
                    newColors[i] = col
                    animation:Configure({ Colors = newColors })
                end
                
                yPos = yPos + 110
            end
        else
            local optionLabel = vgui.Create('DLabel', parent)
            optionLabel:SetText(options.name or '')
            optionLabel:SetTextColor(Color(200, 200, 200))
            optionLabel:SetPos(20, yPos)
            optionLabel:SetSize(150, 20)
            
            if options.type == 'slider' then
                local slider = vgui.Create('DNumSlider', parent)
                slider:SetPos(10, yPos + 20)
                slider:SetSize(350, 20)
                slider:SetMin(options.min)
                slider:SetMax(options.max)
                slider:SetDecimals(2)
                slider:SetValue(options.default)
                
                slider.OnValueChanged = function(_, val)
                    local config = {}
                    config[key] = val
                    animation:Configure(config)
                end
                
                yPos = yPos + 50
            elseif options.type == 'checkbox' then
                local checkbox = vgui.Create('DCheckBoxLabel', parent)
                checkbox:SetPos(175, yPos)
                checkbox:SetText('')
                checkbox:SetValue(options.default and 1 or 0)
                
                checkbox.OnChange = function(_, val)
                    local config = {}
                    config[key] = val
                    animation:Configure(config)
                end
                
                yPos = yPos + 30
            elseif options.type == 'options' then
                local comboBox = vgui.Create('DComboBox', parent)
                comboBox:SetPos(175, yPos)
                comboBox:SetSize(180, 20)
                comboBox:SetValue(options.default)
                
                for _, option in ipairs(options.options) do
                    comboBox:AddChoice(option)
                end
                
                comboBox.OnSelect = function(_, _, val)
                    local config = {}
                    config[key] = val
                    animation:Configure(config)
                end
                
                yPos = yPos + 30
            elseif options.type == 'text' then
                local textEntry = vgui.Create('DTextEntry', parent)
                textEntry:SetPos(175, yPos)
                textEntry:SetSize(180, 20)
                textEntry:SetValue(options.default)
                
                textEntry.OnEnter = function(self)
                    local config = {}
                    config[key] = self:GetValue()
                    animation:Configure(config)
                end
                
                yPos = yPos + 30
            elseif key == 'Color' or key == 'ColorSecondary' or key == 'BackgroundColor' or key == 'BorderColor' then
                -- Color mixer for individual colors
                local colorMixer = vgui.Create('DColorMixer', parent)
                colorMixer:SetPos(175, yPos)
                colorMixer:SetSize(180, 100)
                colorMixer:SetPalette(false)
                colorMixer:SetAlphaBar(true)
                colorMixer:SetColor(options.default)
                
                colorMixer.OnValueChanged = function(_, col)
                    local config = {}
                    config[key] = col
                    animation:Configure(config)
                end
                
                yPos = yPos + 110
            else
                yPos = yPos + 30
            end
        end
    end
    
    -- Container for buttons
    local buttonContainer = vgui.Create('DPanel', parent)
    buttonContainer:SetPos(20, yPos + 10)
    buttonContainer:SetSize(350, 35)
    buttonContainer.Paint = function() end
    
    -- Reset button
    local resetButton = vgui.Create('DButton', buttonContainer)
    resetButton:SetText('Reset to Defaults')
    resetButton:Dock(LEFT)
    resetButton:SetSize(120, 30)
    resetButton:DockMargin(0, 0, 10, 0)
    resetButton:SetTextColor(Color(220, 220, 220))
    resetButton.Paint = function(_, w, h)
        -- Themed styled button
        local isHovered = resetButton:IsHovered()
        local isPressed = resetButton:IsDown()
        
        -- Base background
        local bgColor = self.Theme.Secondary
        local bgAlpha = isHovered and 180 or 130
        if isPressed then bgAlpha = 220 end
        
        draw.RoundedBox(4, 0, 0, w, h, Color(bgColor.r, bgColor.g, bgColor.b, bgAlpha))
        
        -- Border
        surface.SetDrawColor(255, 255, 255, isHovered and 50 or 30)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        
        -- Bottom accent
        local accentHeight = 2
        surface.SetDrawColor(self.Theme.Secondary)
        surface.DrawRect(0, h - accentHeight, w, accentHeight)
        
        -- Highlight on hover
        if isHovered then
            surface.SetDrawColor(255, 255, 255, 15)
            surface.DrawRect(0, 0, w, h - accentHeight)
        end
    end
    resetButton.DoClick = function()
        animation:Configure({})
    end
    
    -- Apply button
    local applyButton = vgui.Create('DButton', buttonContainer)
    applyButton:SetText('Apply Settings')
    applyButton:Dock(LEFT)
    applyButton:SetSize(120, 30)
    applyButton:DockMargin(0, 0, 0, 0)
    applyButton:SetTextColor(Color(220, 220, 220))
    applyButton.Paint = function(_, w, h)
        -- Themed styled button
        local isHovered = applyButton:IsHovered()
        local isPressed = applyButton:IsDown()
        
        -- Base background
        local bgColor = self.Theme.Primary
        local bgAlpha = isHovered and 180 or 130
        if isPressed then bgAlpha = 220 end
        
        draw.RoundedBox(4, 0, 0, w, h, Color(bgColor.r, bgColor.g, bgColor.b, bgAlpha))
        
        -- Border
        surface.SetDrawColor(255, 255, 255, isHovered and 50 or 30)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        
        -- Bottom accent
        local accentHeight = 2
        surface.SetDrawColor(self.Theme.Primary)
        surface.DrawRect(0, h - accentHeight, w, accentHeight)
        
        -- Highlight on hover
        if isHovered then
            surface.SetDrawColor(255, 255, 255, 15)
            surface.DrawRect(0, 0, w, h - accentHeight)
        end
    end
    applyButton.DoClick = function()
        animation:Configure({}) -- This will trigger a refresh with current settings
    end
    
    -- Add Theme style button to quickly apply theme colors
    local themeButton = vgui.Create('DButton', buttonContainer)
    themeButton:SetText('Apply Theme')
    themeButton:Dock(LEFT)
    themeButton:SetSize(100, 30)
    themeButton:DockMargin(10, 0, 0, 0)
    themeButton:SetTextColor(Color(220, 220, 220))
    themeButton.Paint = function(_, w, h)
        -- Theme styled button
        local isHovered = themeButton:IsHovered()
        local isPressed = themeButton:IsDown()
        
        -- Border
        surface.SetDrawColor(255, 255, 255, isHovered and 50 or 30)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        
        -- Theme accent line at bottom
        local lineHeight = 2
        local segmentWidth = w / 3
        
        surface.SetDrawColor(self.Theme.Primary)
        surface.DrawRect(0, h - lineHeight, segmentWidth, lineHeight)
        
        surface.SetDrawColor(self.Theme.Secondary)
        surface.DrawRect(segmentWidth, h - lineHeight, segmentWidth, lineHeight)
        
        surface.SetDrawColor(self.Theme.Accent)
        surface.DrawRect(segmentWidth * 2, h - lineHeight, segmentWidth, lineHeight)
        
        -- Highlight on hover
        if isHovered then
            surface.SetDrawColor(255, 255, 255, 15)
            surface.DrawRect(0, 0, w, h - lineHeight)
        end
    end
    themeButton.DoClick = function()
        -- Apply theme colors to the animation
        local themeConfig = {}
        
        -- Determine what theme-related properties exist on this animation
        if animation.Config.DDIColors ~= nil then
            themeConfig.DDIColors = true
        end
        if animation.Config.DDIStyled ~= nil then
            themeConfig.DDIStyled = true
        end
        if animation.Config.ThemePattern ~= nil then
            themeConfig.ThemePattern = true
        end
        if animation.Config.ThemeMode ~= nil then
            themeConfig.ThemeMode = true
        end
        if animation.Config.DDILogo ~= nil then
            themeConfig.DDILogo = true
        end
        if animation.Config.ThemeSignature ~= nil then
            themeConfig.ThemeSignature = true
        end
        if animation.Config.ThemeElements ~= nil then
            themeConfig.ThemeElements = true
        end
        if animation.Config.Watermark ~= nil then
            themeConfig.Watermark = true
        end
        if animation.Config.Style ~= nil then
            themeConfig.Style = true
        end
        
        -- Apply basic colors if available
        if animation.Config.Color ~= nil then
            themeConfig.Color = self.Theme.Primary
        end
        if animation.Config.SecondaryColor ~= nil then
            themeConfig.SecondaryColor = self.Theme.Secondary
        end
        if animation.Config.ColorSecondary ~= nil then
            themeConfig.ColorSecondary = self.Theme.Secondary
        end
        if animation.Config.AccentColor ~= nil then
            themeConfig.AccentColor = self.Theme.Accent
        end
        
        -- Apply to colors array if it exists
        if animation.Config.Colors ~= nil and type(animation.Config.Colors) == 'table' then
            themeConfig.Colors = {
                self.Theme.Primary,
                self.Theme.Secondary,
                self.Theme.Accent
            }
        end
        
        -- Apply configuration
        animation:Configure(themeConfig)
    end
    
    yPos = yPos + 45
    
    -- Add padding at the bottom
    local padding = vgui.Create('DPanel', parent)
    padding:SetPos(0, yPos)
    padding:SetSize(10, 10)
    padding.Paint = function() end
end

-- Add instructions tab
function DEMO:AddInstructionsTab()
    local panel = vgui.Create('DPanel', self.Container)
    panel:Dock(FILL)
    panel.Paint = function(_, w, h)
        -- Themed background
        draw.RoundedBox(4, 0, 0, w, h, self.Theme.Background)
        
        -- Add themed pattern at bottom
        local patternHeight = 4
        local patternWidth = w / 3
        
        -- Primary color segment
        surface.SetDrawColor(self.Theme.Primary)
        surface.DrawRect(0, h - patternHeight, patternWidth, patternHeight)
        
        -- Secondary color segment
        surface.SetDrawColor(self.Theme.Secondary)
        surface.DrawRect(patternWidth, h - patternHeight, patternWidth, patternHeight)
        
        -- Accent color segment
        surface.SetDrawColor(self.Theme.Accent)
        surface.DrawRect(patternWidth * 2, h - patternHeight, patternWidth, patternHeight)
        
        -- Accent pattern at the bottom
        local patternHeight = 4
        local patternWidth = w / 3
        
        -- Primary color segment
        surface.SetDrawColor(self.Theme.Primary)
        surface.DrawRect(0, h - patternHeight, patternWidth, patternHeight)
        
        -- Secondary color segment
        surface.SetDrawColor(self.Theme.Secondary)
        surface.DrawRect(patternWidth, h - patternHeight, patternWidth, patternHeight)
        
        -- Accent color segment
        surface.SetDrawColor(self.Theme.Accent)
        surface.DrawRect(patternWidth * 2, h - patternHeight, patternWidth, patternHeight)
        
        -- Add DDI logo in corner
        local logoSize = 40
        local logoMargin = 10
        surface.SetDrawColor(self.Theme.Primary.r, self.Theme.Primary.g, self.Theme.Primary.b, 100)
        draw.RoundedBox(6, logoMargin, logoMargin, logoSize, logoSize, Color(self.Theme.Primary.r, self.Theme.Primary.g, self.Theme.Primary.b, 60))
        draw.SimpleText('DDI', 'DermaDefaultBold', logoMargin + logoSize/2, logoMargin + logoSize/2, Color(self.Theme.Primary.r, self.Theme.Primary.g, self.Theme.Primary.b, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    -- local scroll = vgui.Create('DScrollPanel', panel)
    -- scroll:Dock(FILL)
    -- scroll:DockMargin(10, 10, 10, 10)

    -- Rich Text panel
    local richtext = vgui.Create( "RichText", panel )
    richtext:Dock( FILL )
    richtext:DockMargin(10, 10, 10, 10)

    -- Text segment #1 (grayish color)
    richtext:InsertColorChange( 220, 220, 220, 255 )
    richtext:AppendText([[
        DDI Modern UI Animations for Garry's Mod
        
        This collection provides 12 modern UI animations with customizable styling that you can use in your GMod addons.
        
        Usage Instructions:
        
        1. Including animations in your addon:
           - Copy the 'animations' folder to your addon directory
           - Include the animation file you want to use in your code:
             local CubesAnimation = include('animations/animations_cubes.lua')
        
        2. Creating an animation:
           - Create the animation panel:
             local animation = vgui.Create('AnimatedCubes', parent)
             animation:SetSize(200, 60)
           
           - Configure the animation:
             animation:Configure({
                 Colors = {Color(41, 128, 185), Color(52, 152, 219), Color(155, 89, 182)},
                 CubeSize = 15,
                 Speed = 1.2,
                 DDIStyled = true
             })
        
        3. Available animations:
           - AnimatedCubes: Moving colored cubes with customizable styling
           - AnimatedCircles: Orbiting colored circles with particle effects
           - AnimatedPulse: Pulsing shapes with glow and ripple effects
           - AnimatedSpinner: Various spinner animations with modern aesthetics
           - AnimatedProgressBar: Animated progress bars with gradient fills
           - AnimatedFade: Fade in/out animations with smooth transitions
           - AnimatedDDILogo: DDI Logo animations with various effects
           - AnimatedWave: Wave animations for loading and background effects
           - AnimatedNeon: Neon glow animations with vibrant colors
           - AnimatedTypeWriter: Text typing animations with cursor effects
           - AnimatedGlow: Customizable glowing elements with shapes
           - AnimatedParticles: Interactive particle systems with physics
        
        4. Theme Support:
           - Each animation includes an 'Apply Theme' button for one-click styling
           - All animations support customizable colors and styling elements
           - Use the DDIStyled property to enable DDI-branded styled versions
           - Custom color schemes and accent patterns are available throughout
        
        Each animation has its own configuration options that can be customized.
        
        Use the tabs above to see each animation and its available settings.
        
        Toggle Showcase Mode to cycle through all animations automatically.
    ]])

    self.Tabs:AddSheet('Instructions', panel, nil, false, false, 'Usage instructions')
end

-- Create demo panel
local function CreateDemoPanel()
    if IsValid(DemoPanel) then
        DemoPanel:Remove()
    end
    
    DemoPanel = vgui.Create('DFrame')
    table.Merge(DemoPanel, DEMO)
    DemoPanel:Init()
    
    return DemoPanel
end

-- Console command to open demo
concommand.Add('ddi_animations_demo', function()
    CreateDemoPanel()
end)
