defmodule Guess do
  def run do
    Enum.random(1..100)
    |> loop()
  end

  defp loop(num) do
    IO.gets("?>")
    |> process_input(num)
    |> handle_status(num)
  end

  def process_input(guess, num) do
    guess
    |> Integer.parse()
    |> check_guess(num)
  end

  def check_guess({guess, _}, num) when guess == num do
    IO.puts("Correct")
    :exit
  end

  def check_guess({guess, _}, num) when guess != num do
    if guess > num do
      IO.puts("lower")
    else
      IO.puts("higher")
    end
    :ok
  end

  def handle_status(status, num) do
    case status do
      :ok -> loop(num)
      :exit -> :ok
    end
  end
end
