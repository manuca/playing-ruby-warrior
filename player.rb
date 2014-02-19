class Player
  attr_accessor :health

  def receiving_damage?(warrior)
    if !health.nil? && health > warrior.health
      true
    else
      false
    end
  end

  def play_turn(warrior)
    if warrior.feel.enemy?
      warrior.attack!
    elsif warrior.feel.captive?
      warrior.rescue!
    else
      if warrior.health <= 12 && !receiving_damage?(warrior)
        warrior.rest!
      else
        warrior.walk!
      end
    end

    self.health = warrior.health
  end
end
