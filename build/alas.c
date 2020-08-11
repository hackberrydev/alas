#include <janet.h>
static const unsigned char bytes[] = {215, 205, 0, 153, 0, 0, 3, 0, 0, 205, 127, 255, 255, 255, 2, 5, 206, 4, 109, 97, 105, 110, 206, 10, 97, 108, 97, 115, 46, 106, 97, 110, 101, 116, 206, 15, 72, 101, 108, 108, 111, 32, 102, 114, 111, 109, 32, 65, 108, 97, 115, 216, 5, 112, 114, 105, 110, 116, 44, 1, 0, 0, 42, 2, 0, 0, 47, 2, 0, 0, 42, 2, 1, 0, 52, 2, 0, 0, 1, 1, 1, 3, 0, 3, 0, 3, 0, 3};

const unsigned char *janet_payload_image_embed = bytes;
size_t janet_payload_image_embed_size = sizeof(bytes);

int main(int argc, const char **argv) {

#if defined(JANET_PRF)
    uint8_t hash_key[JANET_HASH_KEY_SIZE + 1];
#ifdef JANET_REDUCED_OS
    char *envvar = NULL;
#else
    char *envvar = getenv("JANET_HASHSEED");
#endif
    if (NULL != envvar) {
        strncpy((char *) hash_key, envvar, sizeof(hash_key) - 1);
    } else if (janet_cryptorand(hash_key, JANET_HASH_KEY_SIZE) != 0) {
        fputs("unable to initialize janet PRF hash function.\n", stderr);
        return 1;
    }
    janet_init_hash_key(hash_key);
#endif

    janet_init();

    /* Get core env */
    JanetTable *env = janet_core_env(NULL);
    JanetTable *lookup = janet_env_lookup(env);
    JanetTable *temptab;
    int handle = janet_gclock();

    /* Load natives into unmarshalling dictionary */

        /* Unmarshal bytecode */
    Janet marsh_out = janet_unmarshal(
      janet_payload_image_embed,
      janet_payload_image_embed_size,
      0,
      lookup,
      NULL);

    /* Verify the marshalled object is a function */
    if (!janet_checktype(marsh_out, JANET_FUNCTION)) {
        fprintf(stderr, "invalid bytecode image - expected function.");
        return 1;
    }
    JanetFunction *jfunc = janet_unwrap_function(marsh_out);

    /* Check arity */
    janet_arity(argc, jfunc->def->min_arity, jfunc->def->max_arity);

    /* Collect command line arguments */
    JanetArray *args = janet_array(argc);
    for (int i = 0; i < argc; i++) {
        janet_array_push(args, janet_cstringv(argv[i]));
    }

    /* Create enviornment */
    temptab = janet_table(0);
    temptab = env;
    janet_table_put(temptab, janet_ckeywordv("args"), janet_wrap_array(args));
    janet_gcroot(janet_wrap_table(temptab));

    /* Unlock GC */
    janet_gcunlock(handle);

    /* Run everything */
    JanetFiber *fiber = janet_fiber(jfunc, 64, argc, argc ? args->data : NULL);
    fiber->env = temptab;
    Janet out;
    JanetSignal result = janet_continue(fiber, janet_wrap_nil(), &out);
    if (result != JANET_SIGNAL_OK && result != JANET_SIGNAL_EVENT) {
      janet_stacktrace(fiber, out);
      janet_deinit();
      return result;
    }
#ifdef JANET_NET
    janet_loop();
#endif
    janet_deinit();
    return 0;
}
