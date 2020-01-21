# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_jar", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")

def repositories():
    http_archive(
        name = "io_k8s_repo_infra",
        sha256 = "5ee2a8e306af0aaf2844b5e2c79b5f3f53fc9ce3532233f0615b8d0265902b2a",
        strip_prefix = "repo-infra-0.0.1-alpha.1",
        urls = [
            "https://github.com/kubernetes/repo-infra/archive/v0.0.1-alpha.1.tar.gz",
        ],
    )
    http_archive(
        name = "io_bazel_rules_docker",
        sha256 = "413bb1ec0895a8d3249a01edf24b82fd06af3c8633c9fb833a0cb1d4b234d46d",
        strip_prefix = "rules_docker-0.12.0",
        urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.12.0.tar.gz"],
    )

    http_archive(
        name = "io_bazel_rules_k8s",
        sha256 = "a34539941fd920432b7c545f720129e2f2e6b2285f1beb66de25e429f91759bf",
        strip_prefix = "rules_k8s-0.3",
        urls = ["https://github.com/bazelbuild/rules_k8s/releases/download/v0.3/rules_k8s-v0.3.tar.gz"],
    )
    # get antlr compiler
    http_jar(
        name = "antlr_compiler",
        url = "https://www.antlr.org/download/antlr-4.7.1-complete.jar",
        sha256 = "f41dce7441d523baf9769cb7756a00f27a4b67e55aacab44525541f62d7f6688",
    )
    # get antlr runtime for Go
    http_archive(
        name = "antlr_runtime",
        url = "https://github.com/antlr/antlr4/archive/4.7.2.tar.gz",
        strip_prefix = "antlr4-4.7.2",
        build_file = "@io_k8s_test_infra//:antlr_runtime.BUILD",
        sha256 = "46f5e1af5f4bd28ade55cb632f9a069656b31fc8c2408f9aa045f9b5f5caad64",
    )

    # https://github.com/bazelbuild/rules_nodejs
    http_archive(
        name = "build_bazel_rules_nodejs",
        sha256 = "9abd649b74317c9c135f4810636aaa838d5bea4913bfa93a85c2f52a919fdaf3",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.36.0/rules_nodejs-0.36.0.tar.gz"],
    )

    # Python setup
    # pip_import() calls must live in WORKSPACE, otherwise we get a load() after non-load() error
    git_repository(
        name = "rules_python",
        commit = "94677401bc56ed5d756f50b441a6a5c7f735a6d4",
        remote = "https://github.com/bazelbuild/rules_python.git",
        shallow_since = "1573842889 -0500",
    )

    # TODO(fejta): get this to work
    git_repository(
        name = "io_bazel_rules_appengine",
        commit = "fdbce051adecbb369b15260046f4f23684369efc",
        remote = "https://github.com/bazelbuild/rules_appengine.git",
        shallow_since = "1552415147 -0400",
        #tag = "0.0.8+but-this-isn't-new-enough", # Latest at https://github.com/bazelbuild/rules_appengine/releases.
    )

    new_git_repository(
        name = "com_github_operator_framework_community_operators",
        build_file_content = """
exports_files([
    "upstream-community-operators/prometheus/alertmanager.crd.yaml",
    "upstream-community-operators/prometheus/prometheus.crd.yaml",
    "upstream-community-operators/prometheus/prometheusrule.crd.yaml",
    "upstream-community-operators/prometheus/servicemonitor.crd.yaml",
])
""",
        commit = "efda5dc98fd580ab5f1115a50a28825ae4fe6562",
        remote = "https://github.com/operator-framework/community-operators.git",
        shallow_since = "1568320223 +0200",
    )

    http_archive(
        name = "io_bazel_rules_jsonnet",
        sha256 = "68b5bcb0779599065da1056fc8df60d970cffe8e6832caf13819bb4d6e832459",
        strip_prefix = "rules_jsonnet-0.2.0",
        urls = ["https://github.com/bazelbuild/rules_jsonnet/archive/0.2.0.tar.gz"],
    )
