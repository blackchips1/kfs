NAME	= kfs
CFLAGS	= -ffreestanding -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -m32 -g3 -std=gnu99
OBJS	= ./main.o ./crt0.o

RM	= rm -f


QEMU	= qemu-system-i386
QEMU_FLAGS	= -kernel $(NAME) -serial stdio
QEMU_DEBUG	= -S -s

GDB	= gdb
GDBCONF	= ./gdbconf

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -T ./kfs.ld -o $(NAME) -nostdlib -lgcc

./main.o: ./src/main.c
	$(CC) ./src/main.c $(CFLAGS) -c -o main.o

./crt0.o: ./src/crt0.S
	$(CC) ./src/crt0.S -c -o crt0.o $(CFLAGS)

fclean:
	$(RM) $(OBJS)
	$(RM) $(NAME)

boot: $(NAME)
	$(QEMU) $(QEMU_FLAGS)

debug: $(NAME)
	$(QEMU) $(QEMU_FLAGS) $(QEMU_DEBUG) &
	$(GDB) $(NAME) -x $(GDBCONF)

all: $(NAME)
