# This is the window class that will allow you to give it a target to render inside and
# keep it with in the window bounds.
# Anything denoted t_x, t_y, etc . . . are target attributes.

# To allow window to update certain things like user input only when mouse is over
# must implement a function with signature:
#       update_while_selected
# Put what you would noramlly update in side that function so that window can make
# use of logic you want to happen when selected.

# To render a stuff you want to display to a window, you will need to implement this function
# signature, which returns a :target :
#       create_render_target args


class Window
    attr_gtk
    # Window attributes
    attr_accessor :x, :y, :w, :h, :window_sprite, :main_window, :window_selected, 
    # Target attributes 
    :t_x, :t_y, :t_w, :t_h, :target, :target_object

    def initialize init_list
        self.args = init_list[:args]
        self.x = init_list[:x]
        self.y = init_list[:y]
        self.w = init_list[:w]
        self.h = init_list[:h]

        self.window_sprite = init_list.find(:window_sprite) ? init_list[:window_sprite] : nil
        self.main_window = { x: self.x, y: self.y, w: self.w, h: self.h }
        self.window_selected = false
    end

    def init_window_content init_window
        self.target = init_window[:target]
        self.target_object = init_window[:target_object]
        self.t_x = init_window[:x]
        self.t_y = init_window[:y]
        self.t_w = init_window[:w]
        self.t_h = init_window[:h]
    end

    # This should render window to scale for now.
    def render_window 
        outputs.sprites << {x: self.t_x >= 0 ? self.x : self.x - self.t_x, 
            y: self.t_y >= 0 ? self.y : self.y - self.t_y,
            w: self.t_x >= 0 ? self.w : self.w + self.t_x,
            h: self.t_y >= 0 ? self.h : self.h + self.t_y,
            path: self.target,
            source_x: self.t_x >= 0 ? self.t_x : 0,
            source_y: self.t_y >= 0 ? self.t_y : 0, 
            source_w: self.t_x >= 0 ? self.w : self.w + self.t_x, 
            source_h: self.t_y >= 0 ? self.h : self.h + self.t_y
        }
    end

    def check_if_window_selected
        if !self.window_selected &&
        self.args.mouse.point.inside_rect?([self.x, self.y, self.w, self.h])
            self.window_selected = true
            #update_first_selected
        elsif
            self.window_selected = false
        end
    end

    def update_while_selected
        if(self.window_selected)
            self.target_object&.update_while_selected
        end
    end

    def update_on_enter

    end

    def update_on_exit

    end

    def update
        check_if_window_selected
        update_while_selected

        self.target = self.target_object&.create_render_target
        display
        render_window
    end

    def display
        if self.window_sprite.nil?
            self.args.outputs.borders << self.main_window
        else
            self.args.outputs.sprites << {x: self.x,
                y: self.y,
                w: self.w,
                h: self.h,
                path: self.window_sprite,
                source_x: 0,
                source_y: 0,
                source_w: self.w,
                source_h: self.h
            }
        end
    end

    # 1. Create a serialize method that returns a hash with all of
    #    the values you care about.
    def serialize
        { x: x, y: y, w: w, h: h, main_window: main_window, window_selected: window_selected, 
        t_x: t_x, t_y: t_y, t_w: t_w, t_h: t_h, target: target, target_object: target_object }
    end

    # 2. Override the inspect method and return ~serialize.to_s~.
    def inspect
        serialize.to_s
    end

    # 3. Override to_s and return ~serialize.to_s~.
    def to_s
        serialize.to_s
    end
end