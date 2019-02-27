defmodule Guess do
  def run do
    Enum.random(1..100)
    |> loop()
  end

  defp loop(num) do
    input_pid = get_input()
    process_input(input_pid, num)
    |> handle_status(num)
  end

  def get_input do
    command = self()
    spawn(fn->
      input = IO.gets("?>") |> String.trim()
      send(command, {:input, input})
    end)
  end

  def process_input(input_pid, num) do
    receive do
      {:input, input} ->
        input
        |> Integer.parse()
        |> check_guess(num)
    after
      :timer.seconds(10) ->
        Process.exit(input_pid, :kill)
        :exit
    end
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
