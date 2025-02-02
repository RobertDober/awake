
# Compilation

Now we have patter -> ast -> bytecode -> compiled_function -> runtime

the bytecode generation can easily be replaced by creating the compiled function and
can therefore be omitted if we do not want to create a compiled file.

Thusly we might have to workflows

## _Normal_ call

```sh
... | awake <pattern>

    pattern -> ast -> compiled_function -> Runtime.each_line(&compiled_function)
```

## Create and use bytecode

```sh
awake -c <pattern> > some_file

    pattern -> ast -> bytecode 

... | awake -f bytecode_file

    bytecode -> compiled_function -> Runtime.each_line(&compiled_function)
```
