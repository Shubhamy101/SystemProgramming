#include <stdio.h>
#include <stdlib.h>

#define MAX_LINE_LENGTH 1024

// Struct to hold a line of text
typedef struct {
    char text[MAX_LINE_LENGTH];
} Line;

// Function to print the last 'n' lines from the circular buffer
void printLastNLines(Line *buffer, int bufferSize, int n) {
    int start = 0;
    int count = 0;
    int i;

    for (i = 0; i < bufferSize; i++) {
        if (buffer[i].text[0] != '\0') {
            count++;
            if (count > n) {
                start = (start + 1) % bufferSize;
            }
        }
    }

    printf("Last %d lines:\n", n);
    for (i = 0; i < n; i++) {
        printf("%s", buffer[start].text);
        start = (start + 1) % bufferSize;
    }
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <input_file> <n>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[2]);
    if (n <= 0) {
        printf("Invalid value of 'n'. It must be a positive integer.\n");
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        printf("Error opening file: %s\n", argv[1]);
        return 1;
    }

    // Allocate memory for the circular buffer
    Line *buffer = (Line *)malloc(n * sizeof(Line));
    if (buffer == NULL) {
        printf("Memory allocation failed.\n");
        fclose(file);
        return 1;
    }

    // Initialize the buffer
    int i;
    for (i = 0; i < n; i++) {
        buffer[i].text[0] = '\0';
    }

    // Read the file line by line and update the buffer
    char line[MAX_LINE_LENGTH];
    while (fgets(line, MAX_LINE_LENGTH, file) != NULL) {
        int index = i % n;
        strcpy(buffer[index].text, line);
        i++;
    }

    fclose(file);

    // Print the last 'n' lines
    printLastNLines(buffer, n, n);

    // Free allocated memory
    free(buffer);

    return 0;
}
