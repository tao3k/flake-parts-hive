# SPDX-FileCopyrightText: 2023 The omnibus Authors
# SPDX-FileCopyrightText: 2024 The omnibus Authors
#
# SPDX-License-Identifier: MIT

# This file was generated by nvfetcher, please do not modify it manually.
{ fetchurl, dockerTools }:
{
  flake8-black = {
    pname = "flake8-black";
    version = "0.3.6";
    src = fetchurl {
      url = "https://pypi.org/packages/source/f/flake8-black/flake8-black-0.3.6.tar.gz";
      sha256 = "sha256-DfvKMnR3d5KlvLKviHpMrXLHLQ6GyU4I46PeFRu0HDQ=";
    };
  };
}
