{ fetchFromGitHub, python3Packages }:

python3Packages.sendspin.overridePythonAttrs (_: {
  version = "9.1.0";
  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "sendspin-cli";
    tag = "9.1.0";
    hash = "sha256-cEISCLSmu5IgvlJ6Dsuc2rk04OL5+Ic0pErApnoT93c=";
  };
})
