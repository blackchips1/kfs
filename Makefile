NAME	= kfs
CFLAGS	= -ffreestanding -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -m32 -g3 -std=gnu99
OBJS	= ./main.o ./crt0.o

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -T ./kfs.ld -o kfs -nostdlib -lgcc

./main.o: ./src/main.c
	$(CC) ./src/main.c $(CFLAGS) -c -o main.o

./crt0.o: ./src/crt0.S
	$(CC) ./src/crt0.S -c -o crt0.o $(CFLAGS)

fclean:
	rm -f $(OBJS)
	rm -f $(NAME)

boot: $(NAME)
	qemu-system-i386 -kernel ./kfs -serial stdio

debug:
	qemu-system-i386 -S -s -kernel ./kfs -serial stdio &
	gdb ./kfs -x ./gdbconf

all: $(NAME)
