class Api::RobotController < ApplicationController
  def orders
    @robot = []
    commands = params[:commands] # Commands for robot
    if commands.present?
      commands.each_with_index do |command, index|
        if index == 0
          #  Place robot
          place_command = command.split(' ')[1].split(',')
          return unless place_robot(place_command[0].to_i, place_command[1].to_i, place_command[2])
        else
          #  Move/Turn Robot
          face = @robot[2]
          case command
          when "MOVE"
            move_robot(@robot)
          when "LEFT", "RIGHT"
            turn_robot(command, face)
          when "REPORT"
            render json: { location: @robot } and return
          end
        end
      end
    end
  end

  private

  def valid_positions
    (0..5).to_a
  end

  def valid_position?(x,y)
    valid_positions.include?(x) && valid_positions.include?(y)
  end

  def place_robot(x, y, facing)
    if valid_position?(x,y)
      @robot = [x, y, facing]
      true
    else
      false
    end
  end

  def move_robot(robot)
    x = robot[0]
    y = robot[1]
    face = robot[2]

    new_x = x
    new_y = y

    case face
    when "NORTH"
      new_y = y+1 if valid_position?(x, y+1)
    when "SOUTH"
      new_y = y-1 if valid_position?(x, y-1)
    when "EAST"
      new_x = x+1 if valid_position?(x+1, y)
    when "WEST"
      new_x = x-1 if valid_position?(x-1, y)
    end

    @robot[0] = new_x
    @robot[1] = new_y
  end

  def turn_robot(side, face)
    new_face = face

    case face
    when "NORTH"
      if side == "LEFT"
        new_face = "WEST"
      else
        new_face = "EAST"
      end
    when "SOUTH"
      if side == "LEFT"
        new_face = "EAST"
      else
        new_face = "WEST"
      end
    when "EAST"
      if side == "LEFT"
        new_face = "NORTH"
      else
        new_face = "SOUTH"
      end
    when "WEST"
      if side == "LEFT"
        new_face = "SOUTH"
      else
        new_face = "NORTH"
      end
    end
    @robot[2] = new_face
  end
end
