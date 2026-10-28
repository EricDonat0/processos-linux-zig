
const std = @import("std");
const posix = std.posix.system;

pub fn main(init: std.process.Init) !void {
    var buffer: [256]u8 = undefined;
    var stdin = std.Io.File.stdin().reader(init.io, &buffer);

    while (true) {
        std.debug.print("> ", .{});

        const linha =
            (try stdin.interface.takeDelimiter('\n')) orelse break;

        var tokens = std.mem.tokenizeAny(u8, linha, " \t\r");

        var args = [_]?[*:0]const u8{null} ** 9;
        var arg_buffer: [8][256]u8 = undefined;
        var quantidade: usize = 0;

        while (tokens.next()) |texto| {
            if (quantidade == 8) {
                std.debug.print(
                    "Limite de 8 argumentos atingido.\n",
                    .{},
                );
                break;
            }

            const arg = std.fmt.bufPrintSentinel(
                &arg_buffer[quantidade],
                "{s}",
                .{texto},
                0,
            ) catch {
                std.debug.print(
                    "Argumento muito longo.\n",
                    .{},
                );
                quantidade = 0;
                break;
            };

            args[quantidade] = arg.ptr;
            quantidade += 1;
        }

        if (quantidade == 0) continue;

        const comando = std.mem.span(args[0].?);

        if (std.mem.eql(u8, comando, "exit")) break;

        var caminho_buffer: [256]u8 = undefined;

        const caminho = std.fmt.bufPrintSentinel(
            &caminho_buffer,
            "/bin/{s}",
            .{comando},
            0,
        ) catch {
            std.debug.print(
                "Nome do comando muito longo.\n",
                .{},
            );
            continue;
        };

        const pid = posix.fork();

        if (pid < 0) {
            std.debug.print(
                "Erro ao criar processo!\n",
                .{},
            );
            continue;
        }

        if (pid == 0) {
            // FILHO
            const env = [_:null]?[*:0]const u8{};

            _ = posix.execve(
                caminho.ptr,
                @ptrCast(&args),
                &env,
            );

            std.debug.print(
                "Comando nao encontrado ou nao pode ser executado!\n",
                .{},
            );

            std.process.exit(127);
        } else {
            // PAI
            var status: c_int = 0;

            if (posix.waitpid(pid, &status, 0) < 0) {
                std.debug.print(
                    "Erro ao esperar pelo processo filho!\n",
                    .{},
                );
            }
        }
    }

    std.debug.print("Shell encerrada.\n", .{});
}
