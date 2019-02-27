defmodule Shell do
  def run do
    loop()
  end

  def loop do
    IO.gets(">")
    |> process_cmd()
    loop()
  end

  def process_cmd("count\n") do
    Enum.each(10..1, &IO.puts/1)
  end

  def process_cmd(unknown_command) do
    IO.puts("Unknown Command #{unknown_command}")
  end
end
