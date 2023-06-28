defmodule Instruction do

  @callback decode(bitstring()) :: %{assembly: String.t(), remaining_binary: binary()}

end