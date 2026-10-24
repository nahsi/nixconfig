{ fetchFromGitHub, python3Packages }:

python3Packages.sendspin.overridePythonAttrs (_: {
  version = "8.0.0";
  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "sendspin-cli";
    tag = "8.0.0";
    hash = "sha256-88mKR0hmVMVLLl1GTVZYEAQg3b/DUOG30kHlyXQ2kLE=";
  };
})
