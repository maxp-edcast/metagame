require './metagame.rb'

i = 0
game_loop = GameLoop.default
step = GameLoopStep.default(
  content: -> (game_loop, step) {
    puts "step"
    step.state[:count] += 1
    if step.state[:count] > 5
      throw(:exit_game_loop)
    end
  },
  state: {
    count: 1
  }
)
game_loop.steps.push step
game_loop.start