#ifndef BACKFS_CACHE_WRF_H
#define BACKFS_CACHE_WRF_H

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

#define BUCKET_MAX_SIZE 1048576

void cache_init(const char *cache_dir, uint64_t cache_size, uint64_t bucket_max_size);
int cache_fetch(const char *filename, uint32_t block, uint64_t offset,
        char *buf, uint64_t len, uint64_t *bytes_read);
int cache_add(const char *filename, uint32_t block, char *buf, 
        uint64_t len);
int cache_delete(const char *filename);

#endif //BACKFS_CACHE_WRF_H