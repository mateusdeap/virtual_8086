defmodule Instructions.Mov.ImmediateToRegister do
  @behaviour Instruction

  @impl Instruction
  def decode(<<0b0::1, register::3, data::8, rest::bits>>) do
    %{assembly: "mov #{operands(0, register, data)}\n", remaining_binary: rest}
  end

  def decode(<<0b1::1, register::3, data_lo::8, data_hi::8, rest::bits>>) do
    <<data::16>> = <<data_hi::8, data_lo::8>>
    %{assembly: "mov #{operands(0b1, register, data)}\n", remaining_binary: rest}
  end

  def operands(w_field, register, data) do
    "#{destination_operand(w_field, register)}, #{data}"
  end

  def destination_operand(0b0, register) do
    Virtual8086.byte_registers[BinaryUtilities.binary_digits(register)]
  end

  def destination_operand(0b1, register) do
    Virtual8086.word_registers[BinaryUtilities.binary_digits(register)]
  end
end
