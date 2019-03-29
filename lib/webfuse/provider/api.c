#include "webfuse_provider.h"

#include "webfuse/provider/impl/request.h"
#include "webfuse/provider/impl/operation/getattr.h"
#include "webfuse/provider/impl/operation/lookup.h"
#include "webfuse/provider/impl/operation/readdir.h"
#include "webfuse/provider/impl/operation/open.h"
#include "webfuse/provider/impl/operation/close.h"
#include "webfuse/provider/impl/operation/read.h"
#include "webfuse/provider/impl/client_protocol.h"
#include "webfuse/provider/impl/client_config.h"
#include "webfuse/provider/impl/client.h"
#include "webfuse/provider/impl/dirbuffer.h"

// respond

void wfp_respond_error(
    struct wfp_request * request,
    wf_status status)
{
    wfp_impl_respond_error(request, status);
}

void wfp_respond_getattr(
    struct wfp_request * request,
    struct stat const * stat)
{
    wfp_impl_respond_getattr(request, stat);
}

void wfp_respond_lookup(
    struct wfp_request * request,
    struct stat const * stat)
{
    wfp_impl_respond_lookup(request, stat);
}

void wfp_respond_open(
    struct wfp_request * request,
    uint32_t handle)
{
    wfp_impl_respond_open(request, handle);
}

void wfp_respond_read(
    struct wfp_request * request,
    char const * data,
    size_t length)
{
    wfp_impl_respond_read(request, data, length);
}

void wfp_respond_readdir(
    struct wfp_request * request,
    struct wfp_dirbuffer * dirbuffer)
{
    wfp_impl_respond_readdir(request, dirbuffer);
}

// config


struct wfp_client_config * wfp_client_config_create(void)
{
    return wfp_impl_client_config_create();
}

void wfp_client_config_dispose(
    struct wfp_client_config * config)
{
    wfp_impl_client_config_dispose(config);
}

void wfp_client_config_set_userdata(
    struct wfp_client_config * config,
    void * user_data)
{
    wfp_impl_client_config_set_userdata(config, user_data);
}

void wfp_client_config_set_keypath(
    struct wfp_client_config * config,
    char const * key_path)
{
    wfp_impl_client_config_set_keypath(config, key_path);
}

void wfp_client_config_set_certpath(
    struct wfp_client_config * config,
    char const * cert_path)
{
    wfp_impl_client_config_set_certpath(config, cert_path);
}

void wfp_client_config_set_onconnected(
    struct wfp_client_config * config,
    wfp_connected_fn * handler)
{
    wfp_impl_client_config_set_onconnected(config, handler);
}

void wfp_client_config_set_ondisconnected(
    struct wfp_client_config * config,
    wfp_disconnected_fn * handler)
{
    wfp_impl_client_config_set_ondisconnected(config, handler);
}

void wfp_client_config_set_ontimer(
    struct wfp_client_config * config,
    wfp_ontimer_fn * handler)
{
    wfp_impl_client_config_set_ontimer(config, handler);
}

void wfp_client_config_set_onlookup(
    struct wfp_client_config * config,
    wfp_lookup_fn * handler)
{
    wfp_impl_client_config_set_onlookup(config, handler);
}

void wfp_client_config_set_ongetattr(
    struct wfp_client_config * config,
    wfp_getattr_fn * handler)
{
    wfp_impl_client_config_set_ongetattr(config, handler);
}

void wfp_client_config_set_onreaddir(
    struct wfp_client_config * config,
    wfp_readdir_fn * handler)
{
    wfp_impl_client_config_set_onreaddir(config, handler);
}

void wfp_client_config_set_onopen(
    struct wfp_client_config * config,
    wfp_open_fn * handler)
{
    wfp_impl_client_config_set_onopen(config, handler);
}

void wfp_client_config_set_onclose(
    struct wfp_client_config * config,
    wfp_close_fn * handler)
{
    wfp_impl_client_config_set_onclose(config, handler);
}

void wfp_client_config_set_onread(
    struct wfp_client_config * config,
    wfp_read_fn * handler)
{
    wfp_impl_client_config_set_onread(config, handler);
}

// protocol


struct wfp_client_protocol * wfp_client_protocol_create(
    struct wfp_provider const * provider,
    void * user_data)
{
    return wfp_impl_client_protocol_create(provider, user_data);
}

void wfp_client_protocol_dispose(
    struct wfp_client_protocol * protocol)
{
    wfp_impl_client_protocol_dispose(protocol);
}

void wfp_client_protocol_init_lws(
    struct wfp_client_protocol * protocol,
    struct lws_protocols * lws_protocol)
{
    wfp_impl_client_protocol_init_lws(protocol, lws_protocol);
}

// client

struct wfp_client * wfp_client_create(
    struct wfp_client_config * config)
{
    return wfp_impl_client_create(config);
}

void wfp_client_connect(
    struct wfp_client * client,
    char const * url)
{
    wfp_impl_client_connect(client, url);
}

void wfp_client_disconnect(
    struct wfp_client * client)
{
    wfp_impl_client_disconnect(client);
}

void wfp_client_dispose(
    struct wfp_client * client)
{
    wfp_impl_client_dispose(client);
}

void wfp_client_run(
    struct wfp_client * client)
{
    wfp_impl_client_run(client);
}

void wfp_client_shutdown(
    struct wfp_client * client)
{
    wfp_impl_client_shutdown(client);
}

// dirbuffer

struct wfp_dirbuffer * wfp_dirbuffer_create(void)
{
    return wfp_impl_dirbuffer_create();
}

void wfp_dirbuffer_dispose(
    struct wfp_dirbuffer * buffer)
{
    wfp_impl_dirbuffer_dispose(buffer);
}

void wfp_dirbuffer_add(
    struct wfp_dirbuffer * buffer,
    char const * name,
    ino_t inode)
{
    wfp_impl_dirbuffer_add(buffer, name, inode);
}
