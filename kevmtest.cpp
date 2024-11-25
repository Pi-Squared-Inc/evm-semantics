#include <cstdint>
#include <kllvm/runtime/types.h>
#include <pthread.h>
#include <string>

#define NUM_THREADS 2

extern "C" {
void init_static_objects(void);
block * parse_configuration(const char *filename);
block *take_steps(int64_t depth, block *term);
void print_configuration(FILE *file, block *subject);

void run_llvm_backend(
    const char *input_kore_file_name, const char *output_kore_file_name) {
  init_static_objects();
  block *init_config = parse_configuration(input_kore_file_name);
  block *result = take_steps(-1, init_config);
  FILE *out_fd = fopen(output_kore_file_name, "w");
  print_configuration(out_fd, result);
  fclose(out_fd);
}

void *thread_work(void *args) {
  char **argument_array = (char **) args;
  run_llvm_backend(argument_array[0], argument_array[1]);
  return NULL;
}

int main(int argc, char **argv) {
  pthread_t threads[NUM_THREADS];
  int thread_results[NUM_THREADS];
  std::string output_names[NUM_THREADS];
  const char *thread_args[NUM_THREADS][2];

  // prepare thread arguments
  for (unsigned i = 0; i < NUM_THREADS; ++i) {
    thread_args[i][0] = argv[1];
    output_names[i] = std::string(argv[2]) + std::to_string(i);
    thread_args[i][1] = output_names[i].c_str();
  }

  // spawn threads
  for (unsigned i = 0; i < NUM_THREADS; ++i) {
    thread_results[i] =
        pthread_create(&threads[i], NULL, thread_work, (void*) &thread_args[i]);
  }

  // join threads
  for (unsigned i = 0; i < NUM_THREADS; ++i) {
    pthread_join(threads[i], NULL);
  }

  return 0;
}
}
