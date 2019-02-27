defmodule Shell do
  def run do
    loop()
  end

  defp loop do
    IO.gets(">")
    |> process_cmd()
    |> handle_status()
  end

  def handle_status(status) do
    case status do
      :ok -> loop()
      :exit -> IO.puts("bye")
    end
  end

  defp process_cmd("count\n") do
    Enum.each(10..1, &IO.puts/1)
    :ok
  end

  defp process_cmd("exit\n") do
    :exit
  end

  defp process_cmd("guess\n") do
    Guess.run()
  end

  defp process_cmd(unknown_command) do
    IO.puts("Unknown Command #{unknown_command}")
  end
end
