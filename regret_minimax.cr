# This implements the regret minimax function, as described in
# https://en.wikipedia.org/wiki/Regret_(decision_theory)#Minimax_regret. I'm
# even going to use the exact example they use.

enum Choice
  Stocks
  Bonds
  MoneyMarket
end

enum Outcome
  RisingInterestRates
  StaticInterestRates
  FallingInterestRates
end

def regret_minimax(expected_returns : Hash(Tuple(Choice, Outcome), Int32)) : Choice
  best_returns = Hash(Outcome, Int32).new default_value: Int32::MIN

  expected_returns.each do |(choice, outcome), return_for_choice|
    if return_for_choice >= best_returns[outcome]
      best_returns[outcome] = return_for_choice
    end
  end

  expected_regrets = Hash(Tuple(Choice, Outcome), Int32).new

  expected_returns.each do |(choice, outcome), return_for_choice|
    expected_regrets[{choice, outcome}] = best_returns[outcome] - return_for_choice
  end

  worst_regrets = Hash(Choice, Int32).new default_value: Int32::MIN

  expected_regrets.each do |(choice, outcome), regret|
    if regret >= worst_regrets[choice]
      worst_regrets[choice] = regret
    end
  end

  # puts worst_regrets

  worst_regrets.min_by { |(key, value)| value }.first
end

expected_returns = { {Choice::Stocks, Outcome::RisingInterestRates} => -4, {Choice::Stocks, Outcome::StaticInterestRates} => 4, {Choice::Stocks, Outcome::FallingInterestRates} => 12,
                    {Choice::Bonds, Outcome::RisingInterestRates} => -2, {Choice::Bonds, Outcome::StaticInterestRates} => 3, {Choice::Bonds, Outcome::FallingInterestRates} => 8,
                    {Choice::MoneyMarket, Outcome::RisingInterestRates} => 3, {Choice::MoneyMarket, Outcome::StaticInterestRates} => 2, {Choice::MoneyMarket, Outcome::FallingInterestRates} => 1 }

p! regret_minimax expected_returns
