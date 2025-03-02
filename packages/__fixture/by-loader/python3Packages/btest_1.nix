# SPDX-FileCopyrightText: 2023 The omnibus Authors
# SPDX-FileCopyrightText: 2024 The omnibus Authors
#
# SPDX-License-Identifier: MIT

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  __inputs__,
}:

buildPythonPackage rec {
  pname = "btest";
  version = "1.1-test";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "btest";
    rev = "refs/tags/v${version}";
    hash = "sha256-D01hAKcE52eKJRUh1/x5DGxRQpWgA2J0nutshpKrtRU=";
  };

  # No tests available and no module to import
  doCheck = false;

  passthru = {
    __inputs__ = __inputs__;
  };

  meta = with lib; {
    description = "A Generic Driver for Powerful System Tests";
    homepage = "https://github.com/zeek/btest";
    changelog = "https://github.com/zeek/btest/blob/${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
