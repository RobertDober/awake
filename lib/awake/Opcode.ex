defmodule Awake.Opcode do
  use Awake.Types
  alias Awake.{Builtin, Exceptions, Function, State}

  @moduledoc ~S"""
  Representation of Virtual Machine Instructions
  """

  defstruct function: nil, symbolic: nil, arguments: []

  @type t :: %__MODULE__{function: Function.t(), symbolic: atom(), arguments: scalars()}
  @type ts :: list(t())

  @typep arg_t :: scalar() | scalars()
  @typep special_field_t :: {atom(), Function.t(), Function.t()}

  @functions %{
    invoke: &Function.invoke/2,
    outputfld: &Function.outputfld/2,
    outputline: &Function.outputline/1, 
    outputspc: &Function.outputspc/2,
    outputstr: &Function.outputstr/2,
    push: &Function.push/2,
    pushspc: &Function.pushspc/2,
  }

  @translations %{
    mcs: {:tmicros, &State.mcs_to_out/1, &State.mcs_to_stack/1},
    ms: {:tmillis, &State.ms_to_out/1, &State.ms_to_stack/1},
    n: {:lnb,  &State.lnb_to_out/1, &State.lnb_to_stack/1},
    nmcs: {:nowmicro, &State.nmcs_to_out/1, &State.nmcs_to_stack/1},
    nms: {:nowmillis, &State.nms_to_out/1, &State.nms_to_stack/1},
    ns: {:nows, &State.ns_to_out/1, &State.ns_to_stack/1},
    nx: {:nowhex, &State.nx_to_out/1, &State.nx_to_stack/1},
    nxm: {:nowhexmilli, &State.nxm_to_out/1, &State.nxm_to_stack/1},
    nxmc: {:nowhexmicro, &State.nxmc_to_out/1, &State.nxmc_to_stack/1},
    s: {:tsec, &State.s_to_out/1, &State.s_to_stack/1},
    x: {:xsec, &State.x_to_out/1, &State.x_to_stack/1},
    xm: {:xmillis, &State.xm_to_out/1, &State.xm_to_stack/1},
    xmc: {:xmicros, &State.xmc_to_out/1, &State.xmc_to_stack/1},
  }

  @spec invoke_to_out(atom(), non_neg_integer()) :: ts()
  def invoke_to_out(name, arity) do
    builtin = Builtin.make(name, arity)
    function = make_builtin_call(builtin, arity, :out)
    [%__MODULE__{function: function, symbolic: :invokeout, arguments: [arity]}]
  end

  @spec invoke_to_stack(atom(), non_neg_integer()) :: ts()
  def invoke_to_stack(name, arity) do
    builtin = Builtin.make(name, arity)
    function = make_builtin_call(builtin, arity, :stack)
    [%__MODULE__{function: function, symbolic: :invokestk, arguments: [arity]}]
  end

  @spec make(atom(), arg_t()) :: t()
  def make(name, args)

  def make(name, args) when is_list(args) do
    function = get_opcode(name)
    function1 = fn state ->
      apply(function, [state|args])
    end
    %__MODULE__{symbolic: name, arguments: args, function: function1}
  end

  def make(name, args), do: make(name, [args])

  @spec makeary(atom(), arg_t()) :: ts()
  def makeary(name, args), do: [make(name, args)]


  @spec make_special(atom(), stack_t()) :: ts()
  def make_special(name, target) do
    case Map.fetch(@translations, name) do
      {:ok, special} -> _make_special(special, target)
      :error -> raise CompilationError, "undefined field %#{name}"
    end
  end

  @spec representation(t()) :: tuple()
  def representation(%__MODULE__{symbolic: symbolic, arguments: arguments}) do
    [symbolic | arguments]
    |> List.to_tuple()
  end

  @spec _make_special(special_field_t(), stack_t()) :: ts()
  defp _make_special(special, target)
  defp _make_special({name, function, _}, :out) do
    [%__MODULE__{function: function, symbolic: :outputspc, arguments: [name]}]
  end
  defp _make_special({name, _, function, _}, :stack) do
    [%__MODULE__{function: function, symbolic: :pushspc, arguments: [name]}]
  end

  @spec get_builtin(atom()) :: function()
  defp get_builtin(name) do
    case Map.fetch(@builtins, name) do
      {:ok, builtin} -> builtin
      :error -> raise Exceptions.CompilationError, "undefined builtin function: #{name}"
    end
  end

  @spec get_opcode(atom()) :: Function.t()
  defp get_opcode(name) do
    case Map.fetch(@functions, name) do
      {:ok, o} -> o
      :error -> raise Exceptions.CompilationError, "undefined opcode: #{name}"
    end
  end
  @spec make_builtin_call(Builtin.t(), non_neg_integer(), stack_t()) :: Function.t()
  defp make_builtin_call(builtin, arity, stack_type)

  defp make_builtin_call(builtin, arity, :out) do
    function = make_builtin_call_function(builtin, arity)

    fn state ->
      result = function.(state)
      State.replace_out(state, arity, result)
    end
  end

  defp make_builtin_call(builtin, arity, :stack) do
    function = make_builtin_call_function(builtin, arity)

    fn state ->
      result = function.(state)
      State.replace_stack(state, arity, result)
    end
  end

  @spec make_builtin_call_function(Builtin.t(), non_neg_integer()) :: Function.t()
  defp make_builtin_call_function(builtin, arity) do
    if builtin.arity do
      fn state ->
        args = Enum.take(state.opstack, arity)
        result = apply(builtin.function, args)
      end
    end

    fn state ->
      args = Enum.take(state.opstack, arity)
      result = builtin.function.(args)
    end
  end

end

# SPDX-License-Identifier: AGPL-3.0-or-later
