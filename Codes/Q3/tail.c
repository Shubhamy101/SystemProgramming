#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void error(char *);

int readLine(char s[], FILE* fptr) {

    int i, c;
    for (i = 0; i < BUFSIZ - 1 && (c = fgetc(fptr)) != EOF && c != '\n'; i++) {
        s[i] = c;
    }
    
    if (c == '\n') {
        s[i++] = c;
    }

    s[i] = '\0';
    return i;
}

/* print the last n lines of the input */
int main(int argc, char *argv[]) {

    char line[BUFSIZ];
    char *linePtr[BUFSIZ];
    int i, start, end, n, nlines;
    FILE *file;

    //Filename to open
    char filename[] = "input.txt";

    if (argc != 2) {
        printf("Provide valid arguments with n.\n");
        exit(1);
    }

    n = atoi(argv[1]);

    for (i = 0; i < BUFSIZ; i++)
        linePtr[i] = NULL;

    if (n <= 0) {
        printf("Please provide a positive n.\n");
        exit(1);
    }

    if ((file = fopen(filename, "r")) == NULL) {
        printf("Error opening the file.\n");
        exit(1);
    }

    end = 0;
    nlines = 0;

    while (readLine(line, file) > 0) {
        linePtr[end] = malloc(strlen(line) + 1);
        strcpy(linePtr[end], line);

        if (++end >= BUFSIZ) {
            end = 0;
        }

        nlines++;
    }

    if (n > nlines) {
        n = nlines;
    }

    start = end - n;
    if (start < 0) {
        start += BUFSIZ;
    }

    for (i = start; n-- > 0; i = (i + 1) % BUFSIZ) {
        printf("%s", linePtr[i]);
        free(linePtr[i]);
    }

    fclose(file);
    return 0;
}
