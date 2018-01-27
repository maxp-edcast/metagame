require 'byebug'
require 'quick_class'

class Base < QuickClass
end

class GameLoopStep < Base
  self.attributes = {
    condition: -> (game_loop, step) { true },
    content: -> (game_loop, step) { },
    persistent: true,
    state: {}
  }
end

class GameLoop < Base
  self.attributes = {
    steps: [],
    state: {}
  }
  def start
    next_steps = []
    catch(:exit_game_loop) do
      loop do
        next_steps = run_current_step(next_steps)
      end
    end
  end
  private
  def run_current_step(next_steps)
    current_step = steps.shift
    if current_step
      evaluate_step(current_step)
      next_steps = determine_next_steps(current_step, next_steps)
    else
      next_steps = apply_next_steps(next_steps)
    end
  end
  def evaluate_step(current_step)
    if current_step.condition.call(self, current_step)
      current_step.content.call(self, current_step)
    end
  end
  def determine_next_steps(current_step, next_steps)
    if current_step.persistent
      next_steps.push current_step
    end
    next_steps
  end
  def apply_next_steps(next_steps)
    self.steps = next_steps
    []
  end

end

