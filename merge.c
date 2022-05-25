/**
 * A program that implements two functions, merge and print_array,
 * and calls those two functions to show that they operate correctly
 * @author Jingbo Wang
 */

#include <stdio.h>
#include <stdlib.h>

/**
 * perform the merge of two arrays
 * input arrays must be in order
 * input arrays must be contiguous in memory, with
 * the first coming before the second
 * @param a the first array
 * @param a_length the number of elements in the first array
 * @param b the second array
 * @param b_length the number of elements in the second array
 */
void merge(int* a, size_t a_length, int* b, size_t b_length);

/**
 * print the contents of an array
 * @param a the array
 * @param a_length the number of elements in the array
 */
void print_array(int* a, size_t a_length);

int main(void)
{
  /* the two arrays are global in assembly */
  int array1[] = {1, 3, 4, 5, 8, 9};
  int array2[] = {2, 6, 7, 8};

  /* these two numbers are calculated without sizeof in assembly */
  size_t a1_length = sizeof(array1) / sizeof(int);
  size_t a2_length = sizeof(array2) / sizeof(int);

  print_array(array1, a1_length);
  print_array(array2, a2_length);

  merge(array1, a1_length, array2, a2_length);

  print_array(array1, a1_length + a2_length);
  return 0;
}

void merge(int* a, size_t a_length, int* b, size_t b_length)
{
  /* this array is allocated on the stack in assembly */
  int* result = (int*)malloc((a_length + b_length) * sizeof(int));

  size_t a_index = 0;
  size_t b_index = 0;
  size_t r_index = 0;

  while (a_index < a_length && b_index < b_length)
  {
    if (a[a_index] < b[b_index])
    {
      result[r_index] = a[a_index];
      a_index++;
    }
    else
    {
      result[r_index] = b[b_index];
      b_index++;
    }
    r_index++;
  }

  while (a_index < a_length)
  {
    result[r_index] = a[a_index];
    a_index++;
    r_index++;
  }

  while (b_index < b_length)
  {
    result[r_index] = b[b_index];
    b_index++;
    r_index++;
  }

  for (r_index = 0; r_index < a_length + b_length; r_index++)
  {
    a[r_index] = result[r_index];
  }

  print_array(result, a_length + b_length);

  /* in assembly, tear down stack instead */
  free(result);
}

void print_array(int* a, size_t a_length)
{
  size_t index;
  for (index = 0; index < a_length; index++)
  {
    printf("%d ", a[index]);
  }
  printf("\n");
}
