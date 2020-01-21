def _declare_go_output(ctx):
    output_dir = "parser/"
    return [
        ctx.actions.declare_file(output_dir + ctx.attr.name + "_base_listener.go"),
        ctx.actions.declare_file(output_dir + ctx.attr.name + "_lexer.go"),
        ctx.actions.declare_file(output_dir + ctx.attr.name + "_listener.go"),
        ctx.actions.declare_file(output_dir + ctx.attr.name + "_parser.go")
    ]

def _declare_runtime_output(ctx, parser_dir):
    grammar_file = ctx.attr.src.files.to_list()[0]
    output_dir = parser_dir.path + "/"
    return [
        ctx.actions.declare_file(output_dir + grammar_file.basename[:-3] + ".interp"),
        ctx.actions.declare_file(output_dir + grammar_file.basename[:-3] + ".tokens"),
        ctx.actions.declare_file(output_dir + grammar_file.basename[:-3] + "Lexer.interp"),
        ctx.actions.declare_file(output_dir + grammar_file.basename[:-3] + "Lexer.tokens")
    ]

def _build_shell_command(antlr_file, grammar_file, output_dir):
    cmd_text = (
        "cp '%s' ./ && " +
        "if [ \"" + grammar_file.dirname + "\" != \"$(pwd)\" ] " +
        "&& [ \"" + grammar_file.dirname + "\" != \".\" ]; then " +
        "cp '%s' ./ ; fi && " +
        "java -jar '%s' -Dlanguage=Go -o '%s' '%s'"
    )
    return cmd_text % (
        antlr_file.path,
        grammar_file.path,
        antlr_file.basename,
        output_dir,
        grammar_file.basename
    )

def _generate_parser(ctx):
    grammar_file = ctx.attr.src.files.to_list()[0]
    antlr_jar_file = ctx.attr._antlr_compiler.files.to_list()[0]
    output_go_sources = _declare_go_output(ctx)
    cmd = _build_shell_command(antlr_jar_file, grammar_file, output_go_sources[0].dirname)
    ctx.actions.run_shell(
        inputs = [grammar_file, antlr_jar_file],
        outputs = output_go_sources,
        progress_message = "running: %s in %s" % (cmd, output_go_sources[0].dirname),
        command = cmd
    )
    return [
        DefaultInfo(
            files = depset(output_go_sources),
        )
    ]

antlr = rule(
    implementation = _generate_parser,
    attrs = {
        "src": attr.label(allow_single_file = True, mandatory = True),
        "_antlr_compiler": attr.label(default="@antlr_compiler//jar"),
    }
)
