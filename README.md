
# Exercícios de Processos em Zig

Projeto acadêmico desenvolvido para praticar conceitos de processos no Linux utilizando a linguagem Zig.

## Exercícios

### 1. Órfãos e Zumbis
Arquivo: `orfaos_zumbis.zig`

Exercício sobre os conceitos de processos órfãos e zumbis no Linux.

### 2. Mini Shell
Arquivo: `mini_shell.zig`

Implementação de um interpretador de comandos simples que utiliza chamadas de sistema para criar processos filhos, executar comandos e aguardar sua conclusão.

Comandos testados: `pwd`, `ls`, `echo` e `exit`.

## Requisitos

- Linux
- Zig 0.16.0

## Compilação e execução

Compile a mini shell:

```sh
zig build-exe mini_shell.zig -lc
```

Execute:

```sh
./mini_shell
```

Digite `exit` para encerrar a mini shell.

## Observação

Este projeto tem finalidade educacional e faz parte dos exercícios acadêmicos sobre processos no Linux.

