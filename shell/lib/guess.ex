defmodule Guess do
  @behaviour Command

  def run do
    Command.run(__MODULE__, [])
  end

  def init(_) do
    num = Enum.random(1..100)
    {:ok, num}
  end

  def handle_prompt(_) do
    "?> "
  end

  def handle_input(input, num) do
    input
    |> Integer.parse()
    |> check_guess(num)
  end

  def check_guess({guess, _}, num) when guess == num do
    IO.puts("Correct")
    {:exit, :ok, num}
  end

  def check_guess({guess, _}, num) when guess != num do
    if guess > num do
      IO.puts("lower")
    else
      IO.puts("higher")
    end
    {:ok, num}
  end
end
