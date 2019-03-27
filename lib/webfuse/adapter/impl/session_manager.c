#include "webfuse/adapter/impl/session_manager.h"
#include <stddef.h>

void wf_impl_session_manager_init(
    struct wf_impl_session_manager * manager)
{
    wf_impl_session_init(&manager->session, NULL, NULL, NULL);
}

void wf_impl_session_manager_cleanup(
    struct wf_impl_session_manager * manager)
{
    wf_impl_session_cleanup(&manager->session);
}

struct wf_impl_session * wf_impl_session_manager_add(
    struct wf_impl_session_manager * manager,
    struct lws * wsi,
    struct wf_impl_authenticators * authenticators,
    struct wf_impl_jsonrpc_server * rpc)
{
    struct wf_impl_session * session = NULL; 
    if (NULL == manager->session.wsi)
    {
        session = &manager->session;
        wf_impl_session_init(&manager->session, wsi, authenticators, rpc);        
    }

    return session;
}

struct wf_impl_session * wf_impl_session_manager_get(
    struct wf_impl_session_manager * manager,
    struct lws * wsi)
{
    struct wf_impl_session * session = NULL;
    if (wsi == manager->session.wsi)
    {
        session = &manager->session;
    }

    return session;
}

void wf_impl_session_manager_remove(
    struct wf_impl_session_manager * manager,
    struct lws * wsi)
{
    if (wsi == manager->session.wsi)
    {
        wf_impl_session_cleanup(&manager->session);
        manager->session.wsi = NULL;
    }
}
