#include <stdio.h>
#include <stdlib.h>
char *str = "hello 2017";
int main()
{
  FILE * fp;

  fp = fopen ("file.txt", "a+");
  fprintf(fp, "%s\n", str);

  fclose(fp);

  return(0);
}
