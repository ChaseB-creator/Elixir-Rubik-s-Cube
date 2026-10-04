IO.puts("Welcome to the Rubik's Cube!")
IO.puts("This program is still in development.")
IO.puts("Please stay tuned while this program is being built.\n")

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

  @moves [:U, :D, :L, :R, :F, :B, :F_prime, :U_prime]

  @doc "Solved Rubik's Cube."
  def new do
    %{
      u: List.duplicate(:white, 9) |> List.to_tuple(),
      d: List.duplicate(:yellow, 9) |> List.to_tuple(),
      f: List.duplicate(:green, 9) |> List.to_tuple(),
      b: List.duplicate(:blue, 9) |> List.to_tuple(),
      l: List.duplicate(:orange, 9) |> List.to_tuple(),
      r: List.duplicate(:red, 9) |> List.to_tuple()
    }
  end

  # Creating Face Rotation Matrix (FRM)
  def rotate_face_cw({a, b, c, d, e, f, g, h, i}) do
    {g, d, a, h, e, b, i, f, c}
  end

  def rotate_face_ccw(face) do
    face
    |> rotate_face_cw()
    |> rotate_face_cw()
    |> rotate_face_cw()
  end

  # Defining Face Turns (Core Logic Functionality)
  def move(cube, :F) do
    # Destructure the faces from the cube map first
    %{u: u, d: d, l: l, r: r, f: f} = cube

    {u0, u1, u2, u3, u4, u5, u6, u7, u8} = u
    {d0, d1, d2, d3, d4, d5, d6, d7, d8} = d
    {l0, l1, l2, l3, l4, l5, l6, l7, l8} = l
    {r0, r1, r2, r3, r4, r5, r6, r7, r8} = r

    %{
      cube
      | f: rotate_face_cw(f),
        u: {u0, u1, u2, u3, u4, u5, l8, l5, l2},
        r: {u6, r1, r2, u7, r4, r5, u8, r7, r8},
        d: {r6, r3, r0, d3, d4, d5, d6, d7, d8},
        l: {l0, l1, d0, l3, l4, d1, l6, l7, d2}
    }
  end

  def move(cube, :F_prime) do
    cube |> move(:F) |> move(:F) |> move(:F)
  end

  # Fallback for moves not yet implemented
  def move(cube, _move), do: cube

  # Scrambling & Movement Pipelines
  def apply_moves(cube, moves) when is_list(moves) do
    Enum.reduce(moves, cube, fn m, acc -> move(acc, m) end)
  end

  def scramble(cube, length \\ 20) do
    random_moves = Enum.map(1..length, fn _ -> Enum.random(@moves) end)
    {apply_moves(cube, random_moves), random_moves}
  end

  # Terminal Visualizer
  def render(cube) do
    c = fn color ->
      case color do
        :white -> "W"
        :yellow -> "Y"
        :green -> "G"
        :blue -> "B"
        :orange -> "O"
        :red -> "R"
      end
    end

    row = fn face, r ->
      idx = r * 3

      "#{c.(elem(face, idx))} #{c.(elem(face, idx + 1))} #{c.(elem(face, idx + 2))}"
    end

    # UP Face
    IO.puts("      " <> row.(cube.u, 0))
    IO.puts("      " <> row.(cube.u, 1))
    IO.puts("      " <> row.(cube.u, 2))

    # Middle Layer (L, F, R, B)
    for r <- 0..2 do
      IO.puts(
        "#{row.(cube.l, r)}  #{row.(cube.f, r)}  #{row.(cube.r, r)}  #{row.(cube.b, r)}"
      )
    end

    # DOWN Face
    IO.puts("      " <> row.(cube.d, 0))
    IO.puts("      " <> row.(cube.d, 1))
    IO.puts("      " <> row.(cube.d, 2))
  end
end

# --- Execution ---
cube = RubiksCube.new()
IO.puts("Initial Solved State:")
RubiksCube.render(cube)

IO.puts("\nAfter performing one Front turn (:F):")
cube = RubiksCube.move(cube, :F)
RubiksCube.render(cube)
