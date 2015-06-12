#include <stddef.h>

#define COLUMN_SIZE 80
#define LINES 25


static size_t xpos = 0;
static size_t ypos = 0;
static unsigned char	*video = (unsigned char*)(0xB8000);
static short	serial = 0x03F8;


static void outb(short port, unsigned char val)
{
  asm volatile ("outb %0, %1" : : "a"(val), "d"(serial));
}


static void	putchark(int c)
{
  if (c != '\n') {
    video[(xpos + ypos * COLUMN_SIZE) * 2] = c & 0xFF;
    video[(xpos + ypos * COLUMN_SIZE) * 2 + 1] = 0x12;
    xpos++;
  }
  if (c == '\n' || xpos == COLUMN_SIZE) {
    ypos++;
    xpos = 0;
  }
  outb(serial, c);
  if (ypos == LINES) {
    ypos = 0;
    return ;
  }
}

void		printk(const char *msg)
{
  size_t	i = 0;

  while (msg[i])
    putchark(msg[i++]);
}

static void	init_screen(void)
{
  for (int i = 0; i < COLUMN_SIZE * LINES; i += 2) {
    video[i] = ' ';
    video[i + 1] = 0;
  }
}

void		main(void)
{
  init_screen();
  /* printk("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n1234567890\n"); */
  printk("abc\ncd\ne\n\n6--------");
}
