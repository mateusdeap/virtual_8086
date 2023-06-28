defmodule Instructions.Mov do
  @behaviour Instruction

  alias Instructions.Mov.RegisterToRegister

  @impl Instruction
  def decode(binary), do: RegisterToRegister.decode(binary)
end