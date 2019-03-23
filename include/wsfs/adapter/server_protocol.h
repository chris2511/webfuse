#ifndef WSFS_ADAPTER_SERVER_PROTOCOL_H
#define WSFS_ADAPTER_SERVER_PROTOCOL_H

#include "wsfs/adapter/api.h"

struct wsfs_server_protocol;
struct lws_protocols;

#ifdef __cplusplus
extern "C"
{
#endif

extern WSFSA_API struct wsfs_server_protocol * wsfs_server_protocol_create(
    char * mount_point);

extern WSFSA_API void wsfs_server_protocol_dispose(
    struct wsfs_server_protocol * protocol);

extern WSFSA_API void wsfs_server_protocol_init_lws(
    struct wsfs_server_protocol * protocol,
    struct lws_protocols * lws_protocol);

#ifdef __cplusplus
}
#endif

#endif