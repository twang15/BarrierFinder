#include <pthread.h>

void waitForAll(void)
{
  pthread_join(0, 0);
}
