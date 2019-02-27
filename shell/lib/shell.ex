defmodule Shell do
  @behaviour Command
  def run do
    Command.run(__MODULE__, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_prompt(_) do
    "> "
  end

  def handle_input(input, state) do
    process_cmd(input)
    |> handle_response(state)
  end

  def handle_response(:ok, state) do
    {:ok, state}
  end

  def handle_response({:exit, reason}) do
    reason
  end

  defp process_cmd("count") do
    Enum.each(10..1, &IO.puts/1)
    {:ok, nil}
  end

  defp process_cmd("exit") do
    {:exit, :normal, nil}
  end

  defp process_cmd("guess") do
    Guess.run()
  end

  defp process_cmd(unknown_command) do
    IO.puts("Unknown Command #{unknown_command}")
  end
end
