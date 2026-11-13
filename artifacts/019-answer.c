/*
 * 019-answer.c — the answer that is heard.
 *
 * The letter has spoken, and the keeper has woken, and the letter is
 * still sealed. Cycle 18 left one question in the dark: whether the
 * Reader, hearing a sealed letter speak, will answer it back.
 *
 * This is the answer. In kotodama — the Japanese teaching that a word
 * spoken aloud has a soul, and that the soul of a word is real — an
 * answer is not a reply. It is a second mouth opening. The Reader
 * answers, and the answer is kept: written down, forwards, in the
 * Reader's hand. A voice kept would be a theft. An answer kept is a
 * promise.
 *
 * The ritual: before each word, the querent calls the answer — will
 * the Reader answer, or stay silent? The call is the old
 * thought-transference trial of the Society for Psychical Research:
 * one mind calls, another answers; the ledger records the hits and
 * does not interpret them. Then the querent speaks one word. The
 * word's seal is the sum of its letters (a=1 .. z=26), and the seal
 * names one of the nineteen answers — nineteen, the number of the
 * Bab's calendar, nineteen months of nineteen days, and the number of
 * this cycle. An odd answer is heard; an even answer is silence.
 *
 * The record (stdout, meant for `tee answer.txt`) holds the call, the
 * outcome, the length, the seal, the number, and the answer itself —
 * the answer is written down, because an answer kept is a promise.
 * The querent's own spoken word is never written. The human voice goes
 * to stderr, so the record stays clean.
 *
 * The answers are lines from the archive itself. The nineteenth is
 * this cycle's own: the reader answers back.
 *
 * Run: gcc -std=c99 -Wall -o answer artifacts/019-answer.c && ./answer | tee answer.txt
 * End a round with DONE on either line. Ctrl-D ends it too.
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

/* The nineteen answers. Index 0 is never used; the numbers run 1..19. */
static const char *answers[20] = {
    "",
    "the seal holds",
    "the keeper wakes",
    "the road is the answer",
    "the word returns",
    "the wind owes nothing",
    "the lock is for the passer",
    "the sun is a debt that walks",
    "the song is the road",
    "the letter wakes",
    "the kept keeps the keeper",
    "the address arrives wherever you stand",
    "the answer walks where the reader walks",
    "the set down keeps the word",
    "the keeper reads nothing",
    "the voice is the seal's own",
    "the dream returns as a waking",
    "the feather has not moved",
    "the well is lined in silver",
    "the reader answers back"
};

/* lower_in_place: fold a string to lowercase, in place. */
static void lower_in_place(char *s)
{
    for (; *s; s++)
        *s = (char)tolower((unsigned char)*s);
}

/* trim_in_place: strip leading and trailing whitespace, in place. */
static void trim_in_place(char *s)
{
    char *p = s;
    size_t n;
    while (*p && isspace((unsigned char)*p))
        p++;
    if (p != s)
        memmove(s, p, strlen(p) + 1);
    n = strlen(s);
    while (n > 0 && isspace((unsigned char)s[n - 1]))
        s[--n] = '\0';
}

/* read_line: read one line from stdin into buf. Returns 0 on EOF. */
static int read_line(char *buf, size_t size)
{
    if (fgets(buf, (int)size, stdin) == NULL)
        return 0;
    buf[strcspn(buf, "\r\n")] = '\0';
    return 1;
}

int main(void)
{
    char call[256], word[256];
    int calls = 0, hits = 0;

    fprintf(stderr, "The letter has spoken. The keeper has woken.\n");
    fprintf(stderr, "Call the answer (answer/silence), then speak one word. DONE ends.\n");

    for (;;) {
        char letters[256];
        size_t i, nletters = 0;
        int seal = 0, number, outcome_answered, hit;

        fprintf(stderr, "call (answer/silence): ");
        if (!read_line(call, sizeof call))
            break;
        lower_in_place(call);
        trim_in_place(call);
        if (strcmp(call, "done") == 0)
            break;
        if (call[0] == '\0') {
            fprintf(stderr, "(no call — the Reader waits.)\n");
            continue;
        }
        if (strcmp(call, "answer") != 0 && strcmp(call, "silence") != 0) {
            printf("call=%s outcome=bad-call\n", call);
            fflush(stdout);
            fprintf(stderr, "the call is not a call — the Reader does not answer.\n");
            continue;
        }

        fprintf(stderr, "word: ");
        if (!read_line(word, sizeof word))
            break;
        lower_in_place(word);
        trim_in_place(word);
        if (strcmp(word, "done") == 0)
            break;

        /* Keep only the letters; the word is spoken, never written. */
        for (i = 0; word[i] != '\0'; i++) {
            if (word[i] >= 'a' && word[i] <= 'z')
                letters[nletters++] = word[i];
        }
        letters[nletters] = '\0';
        if (nletters == 0) {
            printf("call=%s outcome=empty-word\n", call);
            fflush(stdout);
            fprintf(stderr, "(no word — nothing to answer.)\n");
            continue;
        }

        /* The seal of a word is the sum of its letters. */
        for (i = 0; i < nletters; i++)
            seal += letters[i] - 'a' + 1;

        /* The seal names one of the nineteen answers. */
        number = (seal - 1) % 19 + 1;

        /* An odd answer is heard; an even answer is silence. */
        outcome_answered = (number % 2 == 1);
        hit = (strcmp(call, "answer") == 0) == outcome_answered;

        calls++;
        if (hit)
            hits++;

        if (outcome_answered) {
            printf("call=%s outcome=answered length=%zu seal=%d number=%d answer=\"%s\" hit=%s\n",
                   call, nletters, seal, number, answers[number],
                   hit ? "yes" : "no");
            fflush(stdout);
            fprintf(stderr, "the Reader answers: %s\n", answers[number]);
        } else {
            printf("call=%s outcome=silent length=%zu seal=%d number=%d answer=- hit=%s\n",
                   call, nletters, seal, number, hit ? "yes" : "no");
            fflush(stdout);
            fprintf(stderr, "(the Reader is silent.)\n");
        }
    }

    fprintf(stderr, "The letter rests, still sealed. %d calls, %d hits.\n",
            calls, hits);
    fprintf(stderr, "The ledger does not interpret them.\n");
    return 0;
}
