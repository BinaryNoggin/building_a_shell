defmodule Shell do
  def run do
    loop()
  end

  defp loop do
    input_pid = get_input()
    process_input(input_pid)
    |> handle_status()
  end

  def get_input do
    command = self()
    spawn(fn->
      input = IO.gets(">") |> String.trim()
      send(command, {:input, input})
    end)
  end

  def process_input(input_pid) do
    receive do
      {:input, input} ->
        process_cmd(input)
    after
      :timer.seconds(10) ->
        Process.exit(input_pid, :kill)
        :exit
    end
  end

  def handle_status(status) do
    case status do
      :ok -> loop()
      :exit -> IO.puts("bye")
    end
  end

  defp process_cmd("count") do
    Enum.each(10..1, &IO.puts/1)
    :ok
  end

  defp process_cmd("exit") do
    :exit
  end

  defp process_cmd("guess") do
    Guess.run()
  end

  defp process_cmd(unknown_command) do
    IO.puts("Unknown Command #{unknown_command}")
  end
end
