TARGET = cipher
CC = gcc
DBFLAG = -ggdb
CFLAGS = $(DBFLAG) -m32
LDFLAGS = -march=i386	

$(TARGET): $(TARGET).o
	$(CC) $(DBFLAG) $^ -o $@ $(LDFLAGS)

$(TARGET).o: $(TARGET).S glibc.s
	$(CC) $(CFLAGS) $< -c -o $@

.PHONY: clean
clean:
	$(RM) $(TARGET) $(TARGET).o
