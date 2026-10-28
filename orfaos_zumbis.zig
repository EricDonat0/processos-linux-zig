const std = @import("std");
pub fn main(init: std.process.Init) !void {
    const resultado = std.posix.system.fork();
    const erro = std.posix.errno(resultado);

    if (erro != .SUCCESS) {
        std.debug.print(
            "Erro ao criar processo: errno={d}\n",
            .{@intFromEnum(erro)},
        );
        return;
    }

    if (resultado == 0) {
        // BLOCO DO FILHO
        const pid = std.posix.system.getpid();

        std.debug.print(
            "Filho (PID: {d}) iniciando...\n",
            .{pid},
        );

        try init.io.sleep(
            .{ .nanoseconds = 5 * std.time.ns_per_s },
            .awake,
        );

        std.debug.print(
            "Filho (PID: {d}) terminou após 5 segundos.\n",
            .{pid},
        );

        std.process.exit(0);
    } else {
        // BLOCO DO PAI
        const pid = std.posix.system.getpid();

        std.debug.print(
            "Pai (PID: {d}) terminando cedo; o filho continuará executando.\n",
            .{pid},
        );

        std.process.exit(0);
    }
}
