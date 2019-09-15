TARGET = cipher
CC = gcc
DBFLAG = -ggdb
x86 = -m32
CFLAGS = $(DBFLAG) $(x86)
LDFLAGS = $(x86)

$(TARGET): $(TARGET).o
	$(CC) $(DBFLAG) $^ -o $@ $(LDFLAGS)

$(TARGET).o: $(TARGET).S glibc.s
	$(CC) $(CFLAGS) $< -c -o $@

.PHONY: clean
clean:
	$(RM) $(TARGET) $(TARGET).o
