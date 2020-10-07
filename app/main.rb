require 'app/window.rb'


class Game_One
  attr_gtk
  attr_accessor :render_signiture, :y

  def update_while_selected
    if self.args.inputs.keyboard.key_held.w
      self.y += 5
    end
  end

  def create_render_target
    self.args.render_target(self.render_signiture).sprites << [50, self.y, 32, 32, 'sprites/dragon-0.png']
    return self.render_signiture
  end

  def serialize
    { render_signiture: render_signiture, y: y}
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end


def init args
  args.state.window_one = (Window.new x: 0,
    y: 0,
    w: 500,
    h: 500,
    args: args,
    window_sprite: 'sprites/circle-green.png'
  )

  args.state.game_one = Game_One.new
  args.state.game_one.render_signiture = :blood
  args.state.game_one.args = args

  args.state.window_one.init_window_content x: 0, y: 0, w: 1280, h: 500,
    target: args.state.game_one.render_signiture, target_object: args.state.game_one
end


def tick args
  init args if args.state.tick_count == 1

  args.state.window_one&.update
end
