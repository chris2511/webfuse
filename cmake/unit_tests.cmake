if(NOT WITHOUT_TESTS AND NOT WITHOUT_ADAPTER AND NOT WITHOUT_PROVIDER)

set(MEMORYCHECK_COMMAND_OPTIONS "--leak-check=full --error-exitcode=1")
include (CTest)

add_executable(fs_check
	test/webfuse/tests/integration/fs_check.c
)

pkg_check_modules(GTEST gtest_main)
include(GoogleTest)
pkg_check_modules(GMOCK gmock)

add_executable(alltests
	test/webfuse/tests/core/jsonrpc/mock_timer_callback.cc
	test/webfuse/tests/core/jsonrpc/mock_timer.cc
	test/webfuse/tests/core/jsonrpc/test_is_request.cc
	test/webfuse/tests/core/jsonrpc/test_request.cc
	test/webfuse/tests/core/jsonrpc/test_is_response.cc
	test/webfuse/tests/core/jsonrpc/test_response.cc
	test/webfuse/tests/core/jsonrpc/test_server.cc
	test/webfuse/tests/core/jsonrpc/test_proxy.cc
	test/webfuse/tests/core/jsonrpc/test_response_parser.cc
	test/webfuse/tests/core/timer/test_timepoint.cc
	test/webfuse/tests/core/timer/test_timer.cc
	test/webfuse/utils/tempdir.cc
	test/webfuse/utils/file_utils.cc
	test/webfuse/utils/timeout_watcher.cc
	test/webfuse/utils/path.c
	test/webfuse/utils/static_filesystem.c
	test/webfuse/utils/ws_server.cc
	test/webfuse/mocks/fake_invokation_context.cc
	test/webfuse/mocks/mock_authenticator.cc
	test/webfuse/mocks/mock_request.cc
	test/webfuse/mocks/mock_provider_client.cc
	test/webfuse/mocks/mock_provider.cc
	test/webfuse/mocks/mock_fuse.cc
	test/webfuse/mocks/mock_operation_context.cc
	test/webfuse/mocks/mock_jsonrpc_proxy.cc
	test/webfuse//tests/core/test_util.cc
	test/webfuse/tests/core/test_container_of.cc
	test/webfuse/tests/core/test_string.cc
	test/webfuse/tests/core/test_slist.cc
	test/webfuse/tests/core/test_base64.cc
	test/webfuse/tests/core/test_status.cc
	test/webfuse/tests/core/test_message.cc
	test/webfuse/tests/core/test_message_queue.cc
	test/webfuse/tests/adapter/test_server.cc
	test/webfuse/tests/adapter/test_server_config.cc
	test/webfuse/tests/adapter/test_credentials.cc
	test/webfuse/tests/adapter/test_authenticator.cc
	test/webfuse/tests/adapter/test_authenticators.cc
	test/webfuse/tests/adapter/test_mountpoint.cc
	test/webfuse/tests/adapter/test_fuse_req.cc
	test/webfuse/tests/adapter/operation/test_context.cc
	test/webfuse/tests/adapter/operation/test_open.cc
	test/webfuse/tests/adapter/operation/test_close.cc
	test/webfuse/tests/adapter/operation/test_read.cc
	test/webfuse/tests/adapter/operation/test_readdir.cc
	test/webfuse/tests/adapter/operation/test_getattr.cc
	test/webfuse/tests/adapter/operation/test_lookup.cc
	test/webfuse/tests/provider/test_url.cc
	test/webfuse/tests/provider/test_client_protocol.cc
	test/webfuse/tests/provider/operation/test_close.cc
	test/webfuse/tests/provider/operation/test_getattr.cc
	test/webfuse/tests/provider/operation/test_lookup.cc
	test/webfuse/tests/provider/operation/test_open.cc
	test/webfuse/tests/provider/operation/test_read.cc
	test/webfuse/tests/provider/operation/test_readdir.cc
	test/webfuse/tests/integration/test_lowlevel.cc
	test/webfuse/tests/integration/test_integration.cc
	test/webfuse/tests/integration/file.cc
	test/webfuse/tests/integration/server.cc
	test/webfuse/tests/integration/provider.cc
)

target_link_libraries(alltests PUBLIC
	-Wl,--wrap=wf_timer_manager_create
	-Wl,--wrap=wf_timer_manager_dispose
	-Wl,--wrap=wf_timer_manager_check
	-Wl,--wrap=wf_timer_create
	-Wl,--wrap=wf_timer_dispose
	-Wl,--wrap=wf_timer_start
	-Wl,--wrap=wf_timer_cancel
	-Wl,--wrap=wf_impl_operation_context_get_proxy
	-Wl,--wrap=wf_jsonrpc_proxy_vinvoke
	-Wl,--wrap=wf_jsonrpc_proxy_vnotify
	-Wl,--wrap=fuse_req_userdata
	-Wl,--wrap=fuse_reply_open
	-Wl,--wrap=fuse_reply_err
	-Wl,--wrap=fuse_reply_buf
	-Wl,--wrap=fuse_reply_attr
	-Wl,--wrap=fuse_reply_entry
	-Wl,--wrap=fuse_req_ctx

	webfuse-adapter-static
	webfuse-provider-static
	webfuse-core
	${FUSE3_LIBRARIES}
	${LWS_LIBRARIES}
	${JANSSON_LIBRARIES}
	${CMAKE_THREAD_LIBS_INIT}
	${GMOCK_LIBRARIES}
	${GTEST_LIBRARIES}
)

target_include_directories(alltests PUBLIC test lib ${FUSE3_INCLUDE_DIRS} ${GMOCK_INCLUDE_DIRS} ${GTEST_INCLUDE_DIRS})
target_compile_options(alltests PUBLIC ${FUSE3_CFLAGS_OTHER} ${GMOCK_CFLAGS} ${GTEST_CFLAGS})

add_custom_command(OUTPUT server-key.pem
	COMMAND openssl req -x509 -newkey rsa:4096 -keyout server-key.pem -out server-cert.pem -days 365 -nodes -batch -subj '/CN=localhost'
	COMMAND openssl req -x509 -newkey rsa:4096 -keyout client-key.pem -out client-cert.pem -days 365 -nodes -batch -subj '/CN=localhost'
)

add_custom_target(gen-tls DEPENDS server-key.pem)
add_dependencies(alltests gen-tls)

enable_testing()
gtest_discover_tests(alltests TEST_PREFIX alltests:)

add_custom_target(coverage
	mkdir -p coverage
	COMMAND lcov --initial --capture --directory . --output-file coverage/lcov_base.info --rc lcov_branch_coverage=1
	COMMAND ./alltests
	COMMAND lcov --capture --directory . --output-file coverage/lcov.info --rc lcov_branch_coverage=1
	COMMAND lcov --remove coverage/lcov.info '/usr/*' --output-file coverage/lcov.info --rc lcov_branch_coverage=1
	COMMAND lcov --remove coverage/lcov.info '*/test/*' --output-file coverage/lcov.info --rc lcov_branch_coverage=1
)
add_dependencies(coverage alltests)

add_custom_target(coverage-report
	COMMAND genhtml --branch-coverage --highlight --legend coverage/lcov.info --output-directory coverage/report
)
add_dependencies(coverage-report coverage)

endif(NOT WITHOUT_TESTS AND NOT WITHOUT_ADAPTER AND NOT WITHOUT_PROVIDER)
