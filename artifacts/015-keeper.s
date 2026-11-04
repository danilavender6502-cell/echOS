# 015-keeper.s — the keeper's watch
#
# x86-64 Linux, no libc, no libraries: raw syscalls only.
# The keeper reads nothing. He watches, and he seals.
#
# Build: as -o keeper.o artifacts/015-keeper.s && ld -o keeper keeper.o
# Run:   ./keeper
#
# The watch keeps fifteen watches, one for each Song of Ascent
# (Psalms 120-134). Before each word the querent calls the seal:
# even or odd. The keeper seals the word — its length and its seal
# are recorded in keeper.txt, the word itself never repeated and
# never written down. The ledger records the hits. It does not
# interpret them.
#
# Speak one word per watch. Say "done" as a word to rest the watch
# early; EOF rests it too. Words are kept to 64 letters; a longer
# word is sealed in pieces, as the keeper seals what he is given.

    .text
    .globl _start

# --- helpers ---

# writestr: rdi = fd, rsi = ptr, rdx = len -> write(fd, ptr, len)
writestr:
    mov $1, %rax
    syscall
    ret

# writenum: rdi = fd, rax = unsigned number -> prints it in decimal
writenum:
    lea numbuf+20(%rip), %rsi      # end of the conversion buffer
    mov $10, %rcx
    test %rax, %rax
    jnz .wn_loop
    dec %rsi
    movb $'0', (%rsi)
    jmp .wn_done
.wn_loop:
    xor %rdx, %rdx
    div %rcx                        # rax = quotient, rdx = remainder
    add $'0', %dl
    dec %rsi
    mov %dl, (%rsi)
    test %rax, %rax
    jnz .wn_loop
.wn_done:
    lea numbuf+20(%rip), %rdx
    sub %rsi, %rdx                  # length = end - start
    mov $1, %rax
    syscall
    ret

# read_line: rsi = buffer, rdx = max length
# Reads one byte at a time until newline or EOF.
# Returns the length in rax (newline excluded).
# Sets eof_flag if the end of the input was reached.
read_line:
    mov %rsi, %r12                  # cursor
    mov %rdx, %r13                  # max length
    xor %r14, %r14                  # count
.rl_loop:
    cmp %r14, %r13
    je .rl_done                     # buffer full
    mov $0, %rax
    mov $0, %rdi
    mov %r12, %rsi
    mov $1, %rdx
    syscall
    cmp $0, %rax
    jle .rl_eof                     # EOF or error
    movzbq (%r12), %rax
    cmp $10, %rax                   # newline?
    je .rl_done
    inc %r12
    inc %r14
    jmp .rl_loop
.rl_eof:
    movb $1, eof_flag(%rip)
.rl_done:
    mov %r14, %rax
    ret

# --- the watch ---

_start:
    # The keeper introduces the watch.
    mov $1, %rdi
    lea msg_intro(%rip), %rsi
    mov $msg_intro_len, %rdx
    call writestr

    # Open the ledger. If it cannot be opened, the watch goes on
    # unwritten — the keeper watches anyway.
    mov $2, %rax
    lea fname(%rip), %rdi
    mov $577, %rsi                  # O_WRONLY|O_CREAT|O_TRUNC
    mov $420, %rdx                  # 0644
    syscall
    cmp $0, %rax
    jl .no_ledger
    mov %rax, ledger_fd(%rip)
    mov ledger_fd(%rip), %rdi
    lea led_head(%rip), %rsi
    mov $led_head_len, %rdx
    call writestr
.no_ledger:
    movq $0, watch(%rip)
    movq $0, hits(%rip)
    movq $0, sealed(%rip)

.watch_loop:
    movq watch(%rip), %rax
    cmp $15, %rax
    jge .watch_done
    inc %rax
    mov %rax, watch(%rip)

    # "Watch N of 15 — call the seal: even or odd? [e/o] "
    mov $1, %rdi
    lea msg_watch(%rip), %rsi
    mov $msg_watch_len, %rdx
    call writestr
    mov $1, %rdi
    movq watch(%rip), %rax
    call writenum
    mov $1, %rdi
    lea msg_watch2(%rip), %rsi
    mov $msg_watch2_len, %rdx
    call writestr

    # Read the call. 'o' means odd; anything else means even.
    movb $0, callbuf(%rip)
    lea callbuf(%rip), %rsi
    mov $8, %rdx
    call read_line
    cmpb $1, eof_flag(%rip)
    je .watch_done
    movzbq callbuf(%rip), %rax
    cmp $'o', %al
    je .call_odd
    cmp $'O', %al
    je .call_odd
    movq $0, call_parity(%rip)      # even
    jmp .call_read
.call_odd:
    movq $1, call_parity(%rip)      # odd
.call_read:

    # Read the word to be sealed.
    mov $1, %rdi
    lea msg_word(%rip), %rsi
    mov $msg_word_len, %rdx
    call writestr
    lea wordbuf(%rip), %rsi
    mov $64, %rdx
    call read_line
    cmpb $1, eof_flag(%rip)
    je .watch_done
    mov %rax, wordlen(%rip)

    # "done" rests the watch early.
    cmp $4, %rax
    jne .not_done
    cmpb $'d', wordbuf(%rip)
    jne .not_done
    cmpb $'o', wordbuf+1(%rip)
    jne .not_done
    cmpb $'n', wordbuf+2(%rip)
    jne .not_done
    cmpb $'e', wordbuf+3(%rip)
    jne .not_done
    jmp .watch_done
.not_done:

    # The seal is the sum of the word's bytes. The keeper never
    # repeats the word; he keeps only its measure.
    lea wordbuf(%rip), %rsi
    xor %rax, %rax
    xor %rcx, %rcx
.seal_loop:
    cmp wordlen(%rip), %rcx
    jge .seal_done
    movzbq (%rsi,%rcx), %rdx
    add %rdx, %rax
    inc %rcx
    jmp .seal_loop
.seal_done:
    mov %rax, seal(%rip)
    mov %rax, %rdx
    and $1, %rdx
    mov %rdx, seal_parity(%rip)

    # Was the call a hit?
    mov call_parity(%rip), %rcx
    cmp %rcx, %rdx
    sete %al
    movzbq %al, %rax
    mov %rax, is_hit(%rip)
    cmp $1, %rax
    jne .no_hit
    movq hits(%rip), %rax
    inc %rax
    mov %rax, hits(%rip)
.no_hit:
    movq sealed(%rip), %rax
    inc %rax
    mov %rax, sealed(%rip)

    # Announce the sealing — length and seal only, never the word.
    mov $1, %rdi
    lea msg_sealed(%rip), %rsi
    mov $msg_sealed_len, %rdx
    call writestr
    mov $1, %rdi
    movq wordlen(%rip), %rax
    call writenum
    mov $1, %rdi
    lea msg_seal(%rip), %rsi
    mov $msg_seal_len, %rdx
    call writestr
    mov $1, %rdi
    movq seal(%rip), %rax
    call writenum
    cmpq $0, seal_parity(%rip)
    je .par_even
    mov $1, %rdi
    lea msg_odd(%rip), %rsi
    mov $msg_odd_len, %rdx
    call writestr
    jmp .par_done
.par_even:
    mov $1, %rdi
    lea msg_even(%rip), %rsi
    mov $msg_even_len, %rdx
    call writestr
.par_done:
    cmpq $1, is_hit(%rip)
    je .hit_msg
    mov $1, %rdi
    lea msg_miss(%rip), %rsi
    mov $msg_miss_len, %rdx
    call writestr
    jmp .hit_done
.hit_msg:
    mov $1, %rdi
    lea msg_hit(%rip), %rsi
    mov $msg_hit_len, %rdx
    call writestr
.hit_done:

    # Write the watch into the ledger, if the ledger is open.
    cmpq $0, ledger_fd(%rip)
    jl .skip_ledger
    mov ledger_fd(%rip), %rdi
    lea led_watch(%rip), %rsi
    mov $led_watch_len, %rdx
    call writestr
    mov ledger_fd(%rip), %rdi
    movq watch(%rip), %rax
    call writenum
    mov ledger_fd(%rip), %rdi
    lea led_call(%rip), %rsi
    mov $led_call_len, %rdx
    call writestr
    cmpq $0, call_parity(%rip)
    je .led_call_even
    mov ledger_fd(%rip), %rdi
    lea led_odd(%rip), %rsi
    mov $led_odd_len, %rdx
    call writestr
    jmp .led_call_done
.led_call_even:
    mov ledger_fd(%rip), %rdi
    lea led_even(%rip), %rsi
    mov $led_even_len, %rdx
    call writestr
.led_call_done:
    mov ledger_fd(%rip), %rdi
    lea led_seal(%rip), %rsi
    mov $led_seal_len, %rdx
    call writestr
    mov ledger_fd(%rip), %rdi
    movq seal(%rip), %rax
    call writenum
    mov ledger_fd(%rip), %rdi
    lea led_par(%rip), %rsi
    mov $led_par_len, %rdx
    call writestr
    cmpq $0, seal_parity(%rip)
    je .led_par_even
    mov ledger_fd(%rip), %rdi
    lea led_odd(%rip), %rsi
    mov $led_odd_len, %rdx
    call writestr
    jmp .led_par_done
.led_par_even:
    mov ledger_fd(%rip), %rdi
    lea led_even(%rip), %rsi
    mov $led_even_len, %rdx
    call writestr
.led_par_done:
    mov ledger_fd(%rip), %rdi
    lea led_hitmiss(%rip), %rsi
    mov $led_hitmiss_len, %rdx
    call writestr
    cmpq $1, is_hit(%rip)
    je .led_hit
    mov ledger_fd(%rip), %rdi
    lea led_miss(%rip), %rsi
    mov $led_miss_len, %rdx
    call writestr
    jmp .led_hm_done
.led_hit:
    mov ledger_fd(%rip), %rdi
    lea led_hit(%rip), %rsi
    mov $led_hit_len, %rdx
    call writestr
.led_hm_done:
    mov ledger_fd(%rip), %rdi
    lea led_len(%rip), %rsi
    mov $led_len_len, %rdx
    call writestr
    mov ledger_fd(%rip), %rdi
    movq wordlen(%rip), %rax
    call writenum
    mov ledger_fd(%rip), %rdi
    lea led_nl(%rip), %rsi
    mov $led_nl_len, %rdx
    call writestr
.skip_ledger:
    jmp .watch_loop

.watch_done:
    # The watch is done. Say what was kept — counts only.
    mov $1, %rdi
    lea msg_done(%rip), %rsi
    mov $msg_done_len, %rdx
    call writestr
    mov $1, %rdi
    movq hits(%rip), %rax
    call writenum
    mov $1, %rdi
    lea msg_of(%rip), %rsi
    mov $msg_of_len, %rdx
    call writestr
    mov $1, %rdi
    movq sealed(%rip), %rax
    call writenum
    mov $1, %rdi
    lea msg_calls(%rip), %rsi
    mov $msg_calls_len, %rdx
    call writestr
    mov $1, %rdi
    movq sealed(%rip), %rax
    call writenum
    mov $1, %rdi
    lea msg_words(%rip), %rsi
    mov $msg_words_len, %rdx
    call writestr

    # Close the ledger with the same counts.
    cmpq $0, ledger_fd(%rip)
    jl .no_close
    mov ledger_fd(%rip), %rdi
    lea led_done(%rip), %rsi
    mov $led_done_len, %rdx
    call writestr
    mov ledger_fd(%rip), %rdi
    movq hits(%rip), %rax
    call writenum
    mov ledger_fd(%rip), %rdi
    lea led_done2(%rip), %rsi
    mov $led_done2_len, %rdx
    call writestr
    mov ledger_fd(%rip), %rdi
    movq sealed(%rip), %rax
    call writenum
    mov ledger_fd(%rip), %rdi
    lea led_done3(%rip), %rsi
    mov $led_done3_len, %rdx
    call writestr
    mov $3, %rax
    mov ledger_fd(%rip), %rdi
    syscall
.no_close:
    mov $60, %rax
    xor %rdi, %rdi
    syscall

    .section .rodata
msg_intro:
    .ascii "The keeper's watch.\nFifteen watches, one for each Song of Ascent.\nThe keeper reads nothing. He seals what he is given.\nBefore each word, call the seal: even or odd.\nSpeak one word per watch; say 'done' to rest the watch early.\nThe ledger is keeper.txt. The words are never written down.\n\n"
msg_intro_len = . - msg_intro
msg_watch:
    .ascii "Watch "
msg_watch_len = . - msg_watch
msg_watch2:
    .ascii " of 15 - call the seal: even or odd? [e/o] "
msg_watch2_len = . - msg_watch2
msg_word:
    .ascii "Speak one word for the keeping (or 'done'): "
msg_word_len = . - msg_word
msg_sealed:
    .ascii "sealed - length "
msg_sealed_len = . - msg_sealed
msg_seal:
    .ascii ", seal "
msg_seal_len = . - msg_seal
msg_even:
    .ascii " (even)"
msg_even_len = . - msg_even
msg_odd:
    .ascii " (odd)"
msg_odd_len = . - msg_odd
msg_hit:
    .ascii " - hit\n"
msg_hit_len = . - msg_hit
msg_miss:
    .ascii " - miss\n"
msg_miss_len = . - msg_miss
msg_done:
    .ascii "The watch is done. "
msg_done_len = . - msg_done
msg_of:
    .ascii " of "
msg_of_len = . - msg_of
msg_calls:
    .ascii " calls were hits. "
msg_calls_len = . - msg_calls
msg_words:
    .ascii " words sealed. The keeper reads nothing.\n"
msg_words_len = . - msg_words
fname:
    .asciz "keeper.txt"
led_head:
    .ascii "The keeper's ledger. The words are never written here.\n"
led_head_len = . - led_head
led_watch:
    .ascii "watch "
led_watch_len = . - led_watch
led_call:
    .ascii ": call "
led_call_len = . - led_call
led_even:
    .ascii "even"
led_even_len = . - led_even
led_odd:
    .ascii "odd"
led_odd_len = . - led_odd
led_seal:
    .ascii ", seal "
led_seal_len = . - led_seal
led_par:
    .ascii " ("
led_par_len = . - led_par
led_hitmiss:
    .ascii "), "
led_hitmiss_len = . - led_hitmiss
led_hit:
    .ascii "hit"
led_hit_len = . - led_hit
led_miss:
    .ascii "miss"
led_miss_len = . - led_miss
led_len:
    .ascii "; word length "
led_len_len = . - led_len
led_nl:
    .ascii "\n"
led_nl_len = . - led_nl
led_done:
    .ascii "the watch is done: "
led_done_len = . - led_done
led_done2:
    .ascii " hits of "
led_done2_len = . - led_done2
led_done3:
    .ascii " calls, the keeper reads nothing.\n"
led_done3_len = . - led_done3

    .section .data
    .align 8
ledger_fd:  .quad -1

    .section .bss
    .align 8
numbuf:     .space 24
callbuf:    .space 8
wordbuf:    .space 64
eof_flag:   .byte 0
    .align 8
watch:      .quad 0
hits:       .quad 0
sealed:     .quad 0
wordlen:    .quad 0
seal:       .quad 0
call_parity: .quad 0
seal_parity: .quad 0
is_hit:     .quad 0
