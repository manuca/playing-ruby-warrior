class Direction
  def self.oposite(direction)
    (direction == :forward)? :backward : :forward
  end
end

class Player
  attr_accessor :health, :direction
  MAX_HEALTH    = 20
  ATTACK_HEALTH = 12
  ARCHER_DAMAGE = 3
  ROUNDS_TO_DEFEAT_ARCHER = 5
  MIN_ARCHER_ATTACK_HEALTH = ARCHER_DAMAGE * ROUNDS_TO_DEFEAT_ARCHER

  def receiving_damage?(warrior)
    if !health.nil? && health > warrior.health
      true
    else
      false
    end
  end

  def set_direction!(warrior)
    if direction.nil?
      self.direction = :backward 
      warrior.pivot!
      true
    elsif warrior.feel(direction).wall?
      self.direction = :forward
      warrior.pivot!
      true
    else
      false
    end
  end

  def needs_rest?(warrior)
    !warrior.feel(direction).stairs? && (warrior.health < MIN_ARCHER_ATTACK_HEALTH) &&
      !receiving_damage?(warrior)
  end

  def attack_or_retreat_strategy(warrior)
    if warrior.health < ATTACK_HEALTH
      retreat_strategy(warrior)
    else
      attack_strategy(warrior)
    end
  end

  def attack_strategy(warrior)
    if warrior.feel(direction).empty?
      warrior.walk!(direction)
    elsif warrior.feel(direction).enemy?
      warrior.attack!(direction)
    end
  end

  def retreat_strategy(warrior)
    warrior.walk!(Direction.oposite(direction))
  end

  def play_turn(warrior)
    return if set_direction!(warrior)

    if warrior.feel(direction).enemy?
      warrior.attack!(direction)
    elsif warrior.feel(direction).captive?
      warrior.rescue!(direction)
    else
      if needs_rest?(warrior)
        warrior.rest!
      elsif receiving_damage?(warrior)
        attack_or_retreat_strategy(warrior)
      else
        warrior.walk!(direction)
      end
    end

    self.health = warrior.health
  end
end
