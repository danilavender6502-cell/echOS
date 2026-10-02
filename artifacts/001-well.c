/* 001-well.c — Cycle 1 artifact of the echOS engine.
 *
 * The Well That Remembers Forward. Drop words into the well; when you ask
 * to drink (empty line), each memory returns changed — drifted by one more
 * step of recall. No memory returns unchanged. Like the echo, it differs
 * by the distance it traveled through you.
 *
 * gcc -o well 001-well.c && ./well
 * type words, press Enter on an empty line to recall, Ctrl-D to leave.
 */
#include <stdio.h>
#include <string.h>

#define N 8   /* how many words the well can hold */
#define L 64  /* how long each word may be */

int main(void) {
    static char well[N][L];   /* the well keeps what it is given */
    static int n = 0, recall = 0;
    char line[L];

    puts("speak to the well (empty line to recall, EOF to leave):");
    while (fgets(line, sizeof line, stdin)) {
        line[strcspn(line, "\n")] = 0;
        if (line[0] == 0) {
            if (n == 0) { puts("(the well is silent)"); continue; }
            recall++;
            for (int i = 0; i < n; i++) {
                for (int j = 0; well[i][j]; j++)
                    well[i][j] = (char)(32 + (well[i][j] - 32 + recall) % 95);
                printf("%2d: %s\n", i + 1, well[i]);
            }
        } else if (n < N) {
            strcpy(well[n++], line);
        } else {
            puts("(the well is full; old words overflow and are lost)");
        }
    }
    return 0;
}
