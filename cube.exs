

IO.puts("Welcome to the Rubik's Cube!")

IO.puts("This program is still in development.")

IO.puts("Please stay tuned while this program is being built.")

# Creating the base and dimensions for the Rubik's Cube:

defmodule RubiksCube do
  @type color :: :white | :yellow | :green | :blue | :red | :orange
  @type face :: {
    color(), color(), color(),
    color(), color(), color(),
    color(), color(), color()
}

  @type t :: %{
    u: face(),
    d: face(),
    f: face(),
    b: face(),
    l: face(),
    r: face()
  }

  @doc "Solved Rubik's Cube."
  def new do
    %{
      u: List.duplicate(:white, 9) |> List.to_tuple(),
      d: List.duplicate(:yellow, 9) |> List.to_tuple(),
      f: List.duplicate(:green, 9) |> List.to_tuple(),
      b: List.duplicate(:blue, 9) |> List.to_tuple(),
      l: List.duplicate(:orange, 9) |> List.to_tuple(),
      r: List.duplicates(:red, 9) |> List.to_tuple()
    }
  end
end
